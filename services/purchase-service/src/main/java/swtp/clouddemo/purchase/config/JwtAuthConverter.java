package swtp.clouddemo.purchase.config;

import org.springframework.lang.NonNull;
import org.springframework.lang.NonNullApi;

import org.springframework.core.convert.converter.Converter;
import org.springframework.security.authentication.AbstractAuthenticationToken;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.oauth2.jwt.Jwt;
import org.springframework.security.oauth2.server.resource.authentication.JwtAuthenticationToken;
import org.springframework.security.oauth2.server.resource.authentication.JwtGrantedAuthoritiesConverter;
import org.springframework.stereotype.Component;

import java.util.*;
import java.util.stream.Collectors;
import java.util.stream.Stream;

@Component
public class JwtAuthConverter implements Converter<Jwt, AbstractAuthenticationToken> {

    private final JwtGrantedAuthoritiesConverter jwtGrantedAuthoritiesConverter = new JwtGrantedAuthoritiesConverter();

    // Use your actual client ID here!
    private static final String CLIENT_ID = "web-frontend-client";

    @Override
    public @NonNull AbstractAuthenticationToken convert(@NonNull Jwt jwt) {
        Collection<GrantedAuthority> authorities = Stream.concat(
                jwtGrantedAuthoritiesConverter.convert(jwt).stream(),
                extractRoles(jwt).stream()
        ).collect(Collectors.toSet());

        return new JwtAuthenticationToken(jwt, authorities, getPrincipalName(jwt));
    }

    private Collection<? extends GrantedAuthority> extractRoles(Jwt jwt) {

        // realm_access
        Object realmAccessObj = jwt.getClaim("realm_access");
        Set<String> roles = new HashSet<>(extractRolesFromClaim(realmAccessObj));

        // resource_access.<clientId>
        Object resourceAccessObj = jwt.getClaim("resource_access");
        if (resourceAccessObj instanceof Map<?, ?> resourceAccess) {
            Object clientAccessObj = resourceAccess.get(CLIENT_ID);
            roles.addAll(extractRolesFromClaim(clientAccessObj));
        }

        System.out.println("Extracted roles: " + roles);

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
        // Customize if needed; by default, subject is fine
        return jwt.getClaimAsString("preferred_username");
    }
}
