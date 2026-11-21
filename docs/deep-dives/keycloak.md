# Keycloak and OIDC explained

How browser sign-in produces a token that the Spring services trust. Thesis §2.12 covers the theory, §§2.11.3/4.9 the flows and setup. The short [authentication concept page](../concepts/authentication.md) is the practical summary.

## OAuth 2.0 and OpenID Connect

**OAuth 2.0** is an *authorization* framework: it lets an application act on a user's behalf without learning the user's password. **OpenID Connect (OIDC)** is an identity layer on top of it that answers "who is this user?" by issuing an **ID Token**.

Roles in the flow:

| Role | Here |
| --- | --- |
| Authorization Server | Keycloak |
| Resource Owner | The user (`demo001`) |
| Client | The browser frontend (`web-frontend-client`) |
| Resource Server | The Purchase and Inventory services |

## Keycloak concepts

- **Realm** — an isolated security domain. The project uses `purchase-service-realm`.
- **Client** — an application registered with the realm. `web-frontend-client` is public; `purchase-service-client` is confidential but is not used by the code.
- **User** — `demo001`, with password `demo001`, in the default group `/normal-user`.
- **Role** — `User` on the frontend client, granted by the default group. The converter turns it into Spring authority `ROLE_USER`.
- **Group** — `/normal-user` is a **default group**, so new users automatically receive the `User` client role.
- **Token** — a signed JWT carrying claims such as `iss`, `sub`, `aud`, `exp`, `iat`, plus Keycloak's `realm_access` and `resource_access`.

The realm JSON is exported at `services/keycloak/realms/purchase-service-realm-realm.json`. It sets `accessTokenLifespan: 300` seconds, `RS256` signatures, `registrationAllowed: false`, and PKCE `S256` on the public client. Redirect URIs are `http://localhost:4200/*` and `https://frontend.local/*`.

## How the realm is loaded

The custom Keycloak image copies the realm JSON into `/opt/keycloak/data/import`. `charts/keycloak-chart/templates/_helpers.tpl` defines start arguments with `--import-realm` for both the dev (`start-dev`) and staging (`start`) modes. Importing on startup does **not** overwrite an existing persisted realm — see [authentication and roles](../concepts/authentication.md#browser-flow).

## The authorization code flow with PKCE

The browser is a **public client**: it cannot keep a secret, so it uses PKCE. The thesis's illustrative client `my-spa-app` is not the deployed one; the real client is `web-frontend-client` on port 4200.

```mermaid
sequenceDiagram
  autonumber
  actor User
  participant SPA as Browser (web-frontend-client)
  participant KC as Keycloak
  User->>SPA: Open frontend
  SPA->>SPA: Generate code_verifier + SHA-256 challenge
  SPA->>KC: /auth?client_id...&code_challenge=S256&state&nonce
  KC-->>User: Login form
  User->>KC: Credentials (demo001)
  KC-->>SPA: 302 with code + state
  SPA->>SPA: Validate state
  SPA->>KC: /token with code + code_verifier (no secret)
  KC->>KC: Hash verifier, compare with stored challenge
  KC-->>SPA: access_token + id_token + refresh_token
  SPA->>SPA: Store tokens; send Bearer on API calls
```

Why PKCE matters: if an attacker intercepts the authorization `code`, they still cannot exchange it without the original `code_verifier`, which never leaves the legitimate client. The thesis stresses `state` (CSRF protection) and `nonce` (replay protection) as additional required parameters.

The actual authorization request recorded in the thesis demonstration (§5.1) uses `response_type=code`, `response_mode=fragment`, `scope=openid profile email offline_access`, random `state` and `nonce`, `code_challenge_method=S256`, realm `purchase-service-realm` and client `web-frontend-client`.

## The token: structure and validation

A JWT has three Base64Url parts: `HEADER.PAYLOAD.SIGNATURE` (§2.12.2). The header names the algorithm (RS256 here); the payload holds registered claims (`iss`, `sub`, `aud`, `exp`, `iat`) plus Keycloak roles; the signature proves the token was signed by Keycloak and not altered.

JWTs are **self-contained** — the service does not query a session database — but that makes validation essential. The services are configured as OAuth2 **resource servers**:

```properties
spring.security.oauth2.resourceserver.jwt.issuer-uri=${KEYCLOAK_ISSUER_URI}
spring.security.oauth2.resourceserver.jwt.jwk-set-uri=${KEYCLOAK_JWK_SET_URI}
```

- `issuer-uri` is the *public* address recorded in the token (`http://localhost:8080/...` in dev, `https://keycloak.local/...` in staging). The service checks the token's `iss` claim against it.
- `jwk-set-uri` is the *internal* address Pods use to fetch signing keys: `http://keycloak-service:8080/realms/purchase-service-realm/protocol/openid-connect/certs`. Using `localhost` here would point at the service Pod itself.

See [issuer vs. JWK URL](../concepts/authentication.md#issuer-and-signing-keys-are-different-concerns).

## From token to authority

`JwtAuthConverter` (in `common`) does the translation:

1. Read roles from `realm_access.roles` and `resource_access["web-frontend-client"].roles`.
2. Uppercase each and prefix `ROLE_` — `User` becomes `ROLE_USER`.
3. Keep standard scope-derived authorities too.
4. Use `preferred_username` (falling back to `sub`) as the principal name.

Controllers then enforce `@PreAuthorize("hasRole('USER')")`. `JwtService.getUserId()` reads the `sub` claim so a new purchase can store the user's ID. The listing methods do **not** filter by that ID — see the [API reference](../reference/api.md#list-and-filter-purchases).

## Where the user comes from

The realm has one user in the default group:

```text
realm:        purchase-service-realm
user:         demo001 (password demo001)
group:        /normal-user (default)
client role:  User on web-frontend-client
result:       ROLE_USER in the JWT → @PreAuthorize passes
```

Registration is disabled, which the thesis lists as a functional limitation; there is no profile management either. See [limitations](limitations.md#functional-scope).

## Service-to-service: theory vs. reality

The thesis (§2.12.5) compares **token relay** (forward the user's token downstream) with the **client credentials** grant (a service acts as itself) and says token relay was chosen to preserve user context for auditing.

The checked-in code does **not** implement either pattern for downstream calls. The only user identity that flows onward is the `userId` stamped onto the purchase and included as `lagerItemId`/`purchaseId` metadata in the event — messages carry no token or user claims. Services validate tokens from the browser; they do not authenticate to each other. This is one of the clearest gaps between the design discussion and the implementation, and it is why [Zero Trust](zero-trust.md#east-west-traffic) is only partially addressed.

> The converter and security filter log claims, token fragments and authentication details. Useful while learning, unsafe in a shared environment. See [authentication and roles](../concepts/authentication.md#diagnose-access-failures).

## Where to read next

- [Authentication and roles](../concepts/authentication.md) — operational details and 401/403 diagnosis.
- [Zero Trust](zero-trust.md) — the broader security model.
- [Shared Java library](../concepts/common-library.md#security-foundation) — the converter and filter chain in code.
- [End-to-end use cases](../concepts/use-cases.md#1-sign-in-and-load-the-frontend) — sign-in in action.
