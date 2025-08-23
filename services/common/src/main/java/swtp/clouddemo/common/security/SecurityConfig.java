package swtp.clouddemo.common.config;

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

    /**
     * Configures Spring Security filter chain.
     * - /actuator/prometheus is public
     * - all other endpoints require authentication
     * - JWT authentication with custom converter
     * - logs request details early in the filter chain
     */
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
                // Log request details before security filters
                .addFilterBefore((servletRequest, response, chain) -> {
                    HttpServletRequest request = (HttpServletRequest) servletRequest;
                    logRequestDetails(request);
                    chain.doFilter(request, response);
                }, AbstractPreAuthenticatedProcessingFilter.class);

        return http.build();
    }

    /**
     * Returns a simple JSON response when access is denied (403)
     */
    @Bean
    public AccessDeniedHandler customAccessDeniedHandler() {
        return (request, response, accessDeniedException) -> {
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
     * Logs HTTP method, URI, and user details if authenticated.
     */
    private void logRequestDetails(HttpServletRequest request) {
        String method = request.getMethod();
        String uri = request.getRequestURI();
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();

        if (auth != null && auth.isAuthenticated()) {
            log.info("Processing {} {} | user: {} | authorities: {}", method, uri, auth.getName(), auth.getAuthorities());
        } else {
            log.info("Processing {} {} | unauthenticated request", method, uri);
        }
    }
}
