package swtp.clouddemo.common.config;

import lombok.extern.slf4j.Slf4j;
import org.springframework.core.convert.converter.Converter;
import org.springframework.lang.NonNull;
import org.springframework.security.authentication.AbstractAuthenticationToken;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.oauth2.jwt.Jwt;
import org.springframework.security.oauth2.server.resource.authentication.JwtAuthenticationToken;
import org.springframework.security.oauth2.server.resource.authentication.JwtGrantedAuthoritiesConverter;
import org.springframework.stereotype.Component;

import java.util.Collection;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;
import java.util.stream.Collectors;
import java.util.stream.Stream;

/**
 * JwtAuthConverter converts a JWT into a Spring Security {@link AbstractAuthenticationToken}.
 *
 * <p>
 * It extracts roles and authorities from the token, combining default authorities
 * provided by {@link JwtGrantedAuthoritiesConverter} with custom roles found in
 * the JWT claims (realm_access and resource_access).
 *
 * <p>
 * Logs are added for debugging purposes, showing the subject, claims, and resulting authorities.
 */
@Slf4j
@Component
public class JwtAuthConverter implements Converter<Jwt, AbstractAuthenticationToken> {

    private final JwtGrantedAuthoritiesConverter jwtGrantedAuthoritiesConverter = new JwtGrantedAuthoritiesConverter();
    private static final String CLIENT_ID = "web-frontend-client";

    /**
     * Converts the given JWT into a {@link JwtAuthenticationToken}.
     *
     * @param jwt the JWT to convert
     * @return the resulting authentication token with granted authorities
     */
    @Override
    public @NonNull AbstractAuthenticationToken convert(@NonNull Jwt jwt) {
        log.info("JWT Subject: {}", jwt.getSubject());
        log.info("JWT Claims: {}", jwt.getClaims());

        Collection<GrantedAuthority> authorities = Stream.concat(
                jwtGrantedAuthoritiesConverter.convert(jwt).stream(),
                extractRoles(jwt).stream()
        ).collect(Collectors.toSet());

        log.info("Final granted authorities: {}", authorities);

        return new JwtAuthenticationToken(jwt, authorities, getPrincipalName(jwt));
    }

    /**
     * Extracts roles from the JWT's realm_access and resource_access claims.
     * Converts them into {@link GrantedAuthority} objects prefixed with "ROLE_".
     *
     * @param jwt the JWT
     * @return a collection of granted authorities
     */
    private Collection<? extends GrantedAuthority> extractRoles(Jwt jwt) {
        Set<String> roles = new HashSet<>();

        Object realmAccessObj = jwt.getClaim("realm_access");
        log.debug("realm_access: {}", realmAccessObj);
        roles.addAll(extractRolesFromClaim(realmAccessObj));

        Object resourceAccessObj = jwt.getClaim("resource_access");
        log.debug("resource_access: {}", resourceAccessObj);
        if (resourceAccessObj instanceof Map<?, ?> resourceAccess) {
            Object clientAccessObj = resourceAccess.get(CLIENT_ID);
            log.debug("resource_access[{}]: {}", CLIENT_ID, clientAccessObj);
            roles.addAll(extractRolesFromClaim(clientAccessObj));
        }

        log.info("Extracted roles: {}", roles);

        return roles.stream()
                .map(role -> new SimpleGrantedAuthority("ROLE_" + role.toUpperCase()))
                .collect(Collectors.toSet());
    }

    /**
     * Helper method to extract roles from a JWT claim object.
     *
     * @param claim the claim, expected to contain a "roles" collection
     * @return a set of role strings
     */
    private Set<String> extractRolesFromClaim(Object claim) {
        Set<String> roles = new HashSet<>();
        if (claim instanceof Map<?, ?> map) {
            Object rolesObj = map.get("roles");
            if (rolesObj instanceof Collection<?> collection) {
                for (Object role : collection) {
                    if (role instanceof String str) {
                        roles.add(str);
                    }
                }
            }
        }
        return roles;
    }

    /**
     * Determines the principal name for the authentication token.
     * Typically taken from the "preferred_username" claim in the JWT.
     *
     * @param jwt the JWT
     * @return the principal name
     */
    private String getPrincipalName(Jwt jwt) {
        String username = jwt.getClaimAsString("preferred_username");
        log.info("Extracted principal name: {}", username);
        return username;
    }
}
