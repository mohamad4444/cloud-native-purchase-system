package swtp.clouddemo.common.service;

import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.oauth2.jwt.Jwt;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service
public class JwtService {

    private Jwt getJwt() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication == null || !(authentication.getPrincipal() instanceof Jwt)) {
            throw new IllegalStateException("No JWT token found in security context");
        }
        return (Jwt) authentication.getPrincipal();
    }

    public String getUserId() {
        return getJwt().getSubject(); // "sub"
    }

    public String getUsername() {
        return getJwt().getClaim("preferred_username");
    }

    public String getEmail() {
        return getJwt().getClaim("email");
    }

    public String getFullName() {
        return getJwt().getClaim("name");
    }

    public List<String> getRoles() {
        Map<String, Object> realmAccess = getJwt().getClaim("realm_access");
        if (realmAccess == null || !realmAccess.containsKey("roles")) {
            return List.of();
        }
        return (List<String>) realmAccess.get("roles");
    }

    public boolean hasRole(String role) {
        return getRoles().contains(role);
    }

    public String getClaimAsString(String claim) {
        Object value = getJwt().getClaim(claim);
        return value != null ? value.toString() : null;
    }

    public <T> T getClaim(String claim, Class<T> type) {
        return getJwt().getClaim(claim);
    }

    public Map<String, Object> getAllClaims() {
        return getJwt().getClaims();
    }
}
