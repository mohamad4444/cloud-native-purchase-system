package swtp.clouddemo.purchase.config;

import io.swagger.v3.oas.models.OpenAPI;
import io.swagger.v3.oas.models.info.*;
import io.swagger.v3.oas.models.servers.Server;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import java.util.List;

@Configuration
public class OpenApiConfig {

//    @Bean
//    public OpenAPI customOpenAPI() {
//        return new OpenAPI()
//                .info(new Info()
//                        .title("Purchase Service API")
//                        .version("1.0.0")
//                        .description("API for managing purchase orders and related operations.")
//                        .termsOfService("https://example.com/terms")
//                        .contact(new Contact()
//                                .name("Support Team")
//                                .email("support@example.com")
//                                .url("https://example.com/contact"))
//                        .license(new License()
//                                .name("Apache 2.0")
//                                .url("https://www.apache.org/licenses/LICENSE-2.0.html"))
//                )
//                .servers(List.of(
//                        new Server().url("http://localhost:8080").description("Local dev server"),
//                        new Server().url("https://api.example.com").description("Production server")
//                ));
//    }
    @Bean
    public OpenAPI openAPI() {
        return new OpenAPI()
                .info(new Info()
                        .title("Minimal API")
                        .version("1.0"));
    }
}
