# Authentication and roles

Keycloak handles browser sign-in. Spring Security treats the business services as OAuth2 resource servers: they accept bearer access tokens, validate them, and apply role checks to API methods.

## Browser flow

`services/web-client/web/js/api/auth.js` initializes the Keycloak JavaScript client using the configuration mounted into `config.js`. It uses the standard authorization flow with PKCE (`S256`) and attempts silent single sign-on. After login, the client keeps the access token in application state and session storage, attaches it to API requests, and periodically attempts a refresh.

The checked-in realm is `purchase-service-realm`; the frontend client is `web-frontend-client`. The custom Keycloak image copies a realm export into `/opt/keycloak/data/import`, and the chart starts Keycloak with `--import-realm`. Importing a realm does not mean an existing persisted realm will be replaced on every restart.

## Issuer and signing keys are different concerns

The JWT issuer must match the URL recorded in a token. In `dev`, that is `http://localhost:8088/realms/purchase-service-realm`; in staging it is `https://keycloak.local/realms/purchase-service-realm`.

The backend's JWK URL uses the internal Service instead:

```text
http://keycloak-service:8080/realms/purchase-service-realm/protocol/openid-connect/certs
```

The browser uses the public address, while Pods can fetch signing keys through cluster DNS. Using `localhost` for the backend's key-fetching URL would refer to the backend Pod itself. Both values are configured through the service ConfigMaps; see [configuration](../reference/configuration.md).

## Role mapping

`JwtAuthConverter` reads roles from `realm_access.roles` and from `resource_access.web-frontend-client.roles`. It uppercases each role and prefixes it with `ROLE_`. Thus `user` becomes `ROLE_USER`, satisfying the controllers' `hasRole('USER')` annotations.

The JWT subject (`sub`) becomes the stored purchase user ID through `JwtService`. However, the current purchase listing methods return all matching repository entries; they do not filter by that user ID. Authentication and a stored user ID alone do not imply user-specific purchase history.

## Diagnose access failures

| Symptom | Inspect |
| --- | --- |
| 401 response | Missing or expired token, issuer mismatch, signing-key access |
| 403 response | Token accepted but required authority missing |
| 500 response after a role check | The broad MVC exception handler may convert a method-security exception into 500; inspect the underlying exception |
| Login redirect fails | Frontend URL, Keycloak client redirect URIs, browser origin |
| Staging certificate error | CA trust, Ingress certificate, host resolution |

Only `/actuator/prometheus` and matching API OPTIONS requests are explicitly permitted anonymously by the shared security configuration. Other endpoints, including health and generated OpenAPI routes, require authentication under the current rules.

The learning configuration logs authentication details and token fragments; browser debug logging can include the token itself. Avoid sharing those logs or copying that behavior into a public deployment. For the framework model, see [Spring Security resource servers](https://docs.spring.io/spring-security/reference/servlet/oauth2/resource-server/jwt.html).
