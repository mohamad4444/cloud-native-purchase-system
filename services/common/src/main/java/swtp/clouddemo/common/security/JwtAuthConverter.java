package swtp.clouddemo.common.security;

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

@Slf4j
@Component
public class JwtAuthConverter implements Converter<Jwt, AbstractAuthenticationToken> {

    private final JwtGrantedAuthoritiesConverter jwtGrantedAuthoritiesConverter = new JwtGrantedAuthoritiesConverter();
    private static final String CLIENT_ID = "web-frontend-client";

    @Override
    public @NonNull AbstractAuthenticationToken convert(@NonNull Jwt jwt) {
        log.info("=== JWT CONVERSION DEBUG ===");
        log.info("JWT Subject: {}", jwt.getSubject());
        log.info("JWT Issuer: {}", jwt.getIssuer());
        log.info("JWT Audience: {}", jwt.getAudience());
        log.info("JWT Expiration: {}", jwt.getExpiresAt());
        log.info("JWT Not Before: {}", jwt.getNotBefore());
        log.info("JWT Issued At: {}", jwt.getIssuedAt());
        
        // Log all claims for debugging
        jwt.getClaims().forEach((key, value) -> 
            log.debug("Claim: {} = {}", key, value));
        
        log.info("JWT Token Value: {}", jwt.getTokenValue().substring(0, Math.min(50, jwt.getTokenValue().length())) + "...");

        Collection<GrantedAuthority> authorities = Stream.concat(
                jwtGrantedAuthoritiesConverter.convert(jwt).stream(),
                extractRoles(jwt).stream()
        ).collect(Collectors.toSet());

        log.info("Final granted authorities: {}", authorities);
        log.info("=== END JWT CONVERSION DEBUG ===");

        return new JwtAuthenticationToken(jwt, authorities, getPrincipalName(jwt));
    }

    private Collection<? extends GrantedAuthority> extractRoles(Jwt jwt) {
        Set<String> roles = new HashSet<>();

        Object realmAccessObj = jwt.getClaim("realm_access");
        log.info("realm_access claim: {}", realmAccessObj);
        roles.addAll(extractRolesFromClaim(realmAccessObj));

        Object resourceAccessObj = jwt.getClaim("resource_access");
        log.info("resource_access claim: {}", resourceAccessObj);
        if (resourceAccessObj instanceof Map<?, ?> resourceAccess) {
            Object clientAccessObj = resourceAccess.get(CLIENT_ID);
            log.info("resource_access[{}]: {}", CLIENT_ID, clientAccessObj);
            roles.addAll(extractRolesFromClaim(clientAccessObj));
        }

        log.info("Extracted roles before ROLE_ prefix: {}", roles);
        return roles.stream()
                .map(role -> new SimpleGrantedAuthority("ROLE_" + role.toUpperCase()))
                .collect(Collectors.toSet());
    }

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

    private String getPrincipalName(Jwt jwt) {
        String username = jwt.getClaimAsString("preferred_username");
        if (username == null) {
            username = jwt.getClaimAsString("sub");
            log.warn("preferred_username claim not found, using sub: {}", username);
        }
        log.info("Extracted principal name: {}", username);
        return username;
    }
}