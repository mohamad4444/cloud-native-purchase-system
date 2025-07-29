package swtp.clouddemo.common.config;

import lombok.extern.log4j.Log4j2;
import lombok.extern.slf4j.Slf4j;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Import;
import swtp.clouddemo.common.aop.LoggingAspect;
import swtp.clouddemo.common.exception.GlobalExceptionHandler;

@Configuration
@Slf4j
@Import({JmsConfig.class, CorsConfig.class, OpenApiConfig.class,SecurityConfig.class, LoggingAspect.class
, GlobalExceptionHandler.class})
public class CommonConfig {
    public CommonConfig() {
        log.info("CommonConfig loaded");
    }
    @Bean
    public JwtAuthConverter jwtAuthConverter() {
        return new JwtAuthConverter();
    }
}
