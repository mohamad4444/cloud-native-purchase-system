package swtp.clouddemo.common.config;

import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.oauth2.jwt.Jwt;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

/**
 * JwtService provides a convenient way to access claims and user information
 * from the current authenticated JWT stored in the Spring Security context.
 *
 * <p>
 * This service assumes that the authentication principal is an instance of {@link Jwt}.
 * It abstracts repeated code for fetching user ID, username, email, roles, and custom claims.
 */
@Service
public class JwtService {

    /**
     * Retrieves the current JWT from the SecurityContext.
     *
     * @return the authenticated Jwt
     * @throws IllegalStateException if no JWT is present in the context
     */
    private Jwt getJwt() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication == null || !(authentication.getPrincipal() instanceof Jwt)) {
            throw new IllegalStateException("No JWT token found in security context");
        }
        return (Jwt) authentication.getPrincipal();
    }

    /** @return the user's ID from the "sub" claim */
    public String getUserId() {
        return getJwt().getSubject(); // "sub"
    }

    /** @return the username from the "preferred_username" claim */
    public String getUsername() {
        return getJwt().getClaim("preferred_username");
    }

    /** @return the user's email from the "email" claim */
    public String getEmail() {
        return getJwt().getClaim("email");
    }

    /** @return the user's full name from the "name" claim */
    public String getFullName() {
        return getJwt().getClaim("name");
    }

    /**
     * @return a list of roles from the "realm_access.roles" claim
     * Returns an empty list if the claim is missing.
     */
    public List<String> getRoles() {
        Map<String, Object> realmAccess = getJwt().getClaim("realm_access");
        if (realmAccess == null || !realmAccess.containsKey("roles")) {
            return List.of();
        }
        return (List<String>) realmAccess.get("roles");
    }

    /** @param role role to check
     * @return true if the current user has the specified role */
    public boolean hasRole(String role) {
        return getRoles().contains(role);
    }

    /**
     * Retrieves a JWT claim as a string.
     *
     * @param claim the claim name
     * @return the claim value as string, or null if absent
     */
    public String getClaimAsString(String claim) {
        Object value = getJwt().getClaim(claim);
        return value != null ? value.toString() : null;
    }

    /**
     * Retrieves a JWT claim as a specific type.
     *
     * @param claim the claim name
     * @param type the expected type of the claim
     * @param <T> the claim type
     * @return the claim value cast to type T
     */
    public <T> T getClaim(String claim, Class<T> type) {
        return getJwt().getClaim(claim);
    }

    /** @return a map of all claims present in the JWT */
    public Map<String, Object> getAllClaims() {
        return getJwt().getClaims();
    }
}
