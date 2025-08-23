package swtp.clouddemo.common.config;

import org.springframework.boot.web.servlet.FilterRegistrationBean;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.Ordered;

/**
 * LoggingConfig registers filters related to logging and MDC (Mapped Diagnostic Context).
 *
 * <p>
 * Specifically, it registers the {@link MdcJwtFilter} early in the filter chain
 * to populate MDC values such as userId and username from JWT tokens for logging purposes.
 */
@Configuration
public class LoggingConfig {

    /**
     * Registers the MdcJwtFilter as a servlet filter with high precedence (runs early).
     *
     * @return FilterRegistrationBean configured for MdcJwtFilter
     */
    @Bean
    public FilterRegistrationBean<MdcJwtFilter> loggingMdcFilter() {
        FilterRegistrationBean<MdcJwtFilter> registration = new FilterRegistrationBean<>();
        registration.setFilter(new MdcJwtFilter());
        registration.setOrder(Ordered.LOWEST_PRECEDENCE - 10); // ensures it runs early in the chain
        return registration;
    }
}
