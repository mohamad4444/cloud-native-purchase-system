package swtp.clouddemo.purchase.config;

import io.swagger.v3.oas.models.*;
import io.swagger.v3.oas.models.info.*;
import org.springdoc.core.customizers.OpenApiCustomizer;
import org.springframework.context.annotation.*;

@Configuration
public class OpenApiConfig {

    @Bean
    public OpenAPI customOpenAPI() {
        return new OpenAPI()
            .info(new Info()
                .title("Your API Title")
                .version("1.0")
                .description("API description")
                .contact(new Contact().name("Your Name").email("you@example.com")));
    }
}
