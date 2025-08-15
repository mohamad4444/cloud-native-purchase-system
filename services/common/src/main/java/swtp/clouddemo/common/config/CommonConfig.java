package swtp.clouddemo.common.config;

import lombok.extern.slf4j.Slf4j;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Import;
import swtp.clouddemo.common.aop.LoggingAspect;
import swtp.clouddemo.common.exception.GlobalExceptionHandler;
import swtp.clouddemo.common.filter.EarlyLoggingValve;
import swtp.clouddemo.common.messaging.JmsConfig;
import swtp.clouddemo.common.messaging.MessageProducer;

@Configuration
@Slf4j
@ComponentScan(basePackages = "swtp.clouddemo.common")
//@Import({JmsConfig.class, CorsConfig.class, OpenApiConfig.class,SecurityConfig.class, LoggingAspect.class
//, GlobalExceptionHandler.class, EarlyLoggingValve.class, JwtService.class, MessageProducer.class,LoggingConfig.class})
public class CommonConfig {
    public CommonConfig() {
        log.info("CommonConfig loaded");
    }
    @Bean
    public JwtAuthConverter jwtAuthConverter() {
        return new JwtAuthConverter();
    }
}
