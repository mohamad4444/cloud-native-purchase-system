package swtp.clouddemo.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Import;

@Configuration
@Import({JmsConfig.class, CorsConfig.class, OpenApiConfig.class})
public class CommonConfig {
}
