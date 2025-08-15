package swtp.clouddemo.common.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.boot.web.servlet.FilterRegistrationBean;
import org.springframework.core.Ordered;

@Configuration
public class LoggingConfig {
    @Bean
    public FilterRegistrationBean<MdcJwtFilter> loggingMdcFilter() {
        FilterRegistrationBean<MdcJwtFilter> registration = new FilterRegistrationBean<>();
        registration.setFilter(new MdcJwtFilter());
        registration.setOrder(Ordered.LOWEST_PRECEDENCE - 10); // run early
        return registration;
    }
}
