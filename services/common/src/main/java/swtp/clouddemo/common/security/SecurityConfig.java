package swtp.clouddemo.common.security;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.method.configuration.EnableMethodSecurity;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.access.AccessDeniedHandler;
import org.springframework.security.web.authentication.preauth.AbstractPreAuthenticatedProcessingFilter;

@Configuration
@EnableWebSecurity
@EnableMethodSecurity
@Slf4j
public class SecurityConfig {

    private final JwtAuthConverter authConverter;

    @Autowired
    public SecurityConfig(JwtAuthConverter authConverter) {
        this.authConverter = authConverter;
    }

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        log.info("Setting up security filter chain");

        http
                .authorizeHttpRequests(authorize -> authorize
                        .requestMatchers("/actuator/prometheus").permitAll()
                        .anyRequest().authenticated()
                )
                .exceptionHandling(exception -> exception
                        .accessDeniedHandler(customAccessDeniedHandler())
                )
                .oauth2ResourceServer(oauth2 -> oauth2
                        .jwt(jwt -> jwt.jwtAuthenticationConverter(authConverter))
                )
                // Enhanced logging filter
                .addFilterBefore((servletRequest, response, chain) -> {
                    HttpServletRequest request = (HttpServletRequest) servletRequest;
                    logRequestDetails(request);
                    chain.doFilter(request, response);
                }, AbstractPreAuthenticatedProcessingFilter.class);

        return http.build();
    }

    @Bean
    public AccessDeniedHandler customAccessDeniedHandler() {
        return (request, response, accessDeniedException) -> {
            log.warn("Access denied for request: {} {} | Error: {}", 
                    request.getMethod(), request.getRequestURI(), accessDeniedException.getMessage());
            response.setStatus(HttpServletResponse.SC_FORBIDDEN);
            response.setContentType("application/json");
            response.getWriter().write("""
                        {
                            "error": "Unauthorized access",
                            "status": 403
                        }
                    """);
        };
    }

    /**
     * Enhanced request logging with JWT header details
     */
    private void logRequestDetails(HttpServletRequest request) {
        String method = request.getMethod();
        String uri = request.getRequestURI();
        String authHeader = request.getHeader("Authorization");
        String clientIp = request.getRemoteAddr();
        String userAgent = request.getHeader("User-Agent");

        Authentication auth = SecurityContextHolder.getContext().getAuthentication();

        log.info("=== REQUEST DEBUG ===");
        log.info("Method: {} | URI: {}", method, uri);
        log.info("Client IP: {} | User-Agent: {}", clientIp, userAgent);
        
        if (authHeader != null) {
            log.info("Authorization header present: {}", 
                     authHeader.length() > 50 ? authHeader.substring(0, 50) + "..." : authHeader);
            
            // Log JWT details if present
            if (authHeader.startsWith("Bearer ")) {
                String jwtToken = authHeader.substring(7);
                logJwtDetails(jwtToken);
            }
        } else {
            log.warn("No Authorization header found - unauthenticated request");
        }

        if (auth != null && auth.isAuthenticated()) {
            log.info("Authenticated user: {} | authorities: {}", auth.getName(), auth.getAuthorities());
        } else {
            log.warn("Unauthenticated request - no authentication found in SecurityContext");
        }
        log.info("=== END REQUEST DEBUG ===");
    }

    /**
     * Log basic JWT details without parsing (safe logging)
     */
    private void logJwtDetails(String jwtToken) {
        try {
            String[] jwtParts = jwtToken.split("\\.");
            if (jwtParts.length >= 2) {
                log.info("JWT present - Header: {}... | Payload: {}...", 
                        jwtParts[0].substring(0, Math.min(20, jwtParts[0].length())),
                        jwtParts[1].substring(0, Math.min(30, jwtParts[1].length())));
            }
        } catch (Exception e) {
            log.warn("Failed to extract JWT details: {}", e.getMessage());
        }
    }
}