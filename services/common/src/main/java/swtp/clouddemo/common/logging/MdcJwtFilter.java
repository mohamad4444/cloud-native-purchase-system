package swtp.clouddemo.common.config;

import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.slf4j.MDC;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.oauth2.jwt.Jwt;
import org.springframework.web.filter.OncePerRequestFilter;

import java.io.IOException;

/**
 * MdcJwtFilter extracts information from a JWT (if present) and populates
 * the MDC (Mapped Diagnostic Context) with user-specific details for logging.
 *
 * <p>
 * This allows all log statements executed during the request to include
 * contextual information such as userId and username.
 */
public class MdcJwtFilter extends OncePerRequestFilter {

    /**
     * Extracts user information from JWT and stores it in MDC before passing
     * the request down the filter chain. Clears MDC after processing.
     *
     * @param request     the HTTP request
     * @param response    the HTTP response
     * @param filterChain the filter chain
     * @throws ServletException in case of a servlet error
     * @throws IOException      in case of an I/O error
     */
    @Override
    protected void doFilterInternal(HttpServletRequest request,
                                    HttpServletResponse response,
                                    FilterChain filterChain)
            throws ServletException, IOException {

        try {
            Object principal = SecurityContextHolder.getContext().getAuthentication().getPrincipal();
            if (principal instanceof Jwt jwt) {
                // Populate MDC for logging
                MDC.put("userId", jwt.getClaimAsString("sub"));
                MDC.put("username", jwt.getClaimAsString("preferred_username"));
            }

            // Continue with the filter chain
            filterChain.doFilter(request, response);
        } finally {
            // Clear MDC to prevent leakage between requests
            MDC.clear();
        }
    }
}
