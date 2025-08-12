// package swtp.clouddemo.common.config;

// import org.springframework.context.annotation.Bean;
// import org.springframework.context.annotation.Configuration;
// import org.springframework.security.oauth2.jwt.*;
// import org.springframework.security.oauth2.core.OAuth2TokenValidatorResult;
// import org.springframework.security.oauth2.core.OAuth2Error;
// import org.springframework.security.oauth2.core.OAuth2TokenValidator;

// @Configuration
// public class JwtDecoderConfig {

//     @Bean
//     public JwtDecoder jwtDecoder() {
//         NimbusJwtDecoder jwtDecoder = NimbusJwtDecoder
//             .withJwkSetUri("http://keycloak:8080/auth/realms/purchase-service-realm/protocol/openid-connect/certs")
//             .build();

//         // Create the default validator but WITHOUT issuer validation
//         OAuth2TokenValidator<Jwt> defaultValidators = JwtValidators.createDefaultWithoutIssuer();

//         // Add custom issuer validator that accepts your specific issuer
//         OAuth2TokenValidator<Jwt> customIssuerValidator = new OAuth2TokenValidator<Jwt>() {
//             private final OAuth2Error error = new OAuth2Error("invalid_token", "The issuer is invalid", null);

//             @Override
//             public OAuth2TokenValidatorResult validate(Jwt token) {
//                 String issuer = token.getIssuer().toString();
//                 // Accept your expected issuer here (the one in your JWT)
//                 if ("http://localhost:8280/auth/realms/purchase-service-realm".equals(issuer)) {
//                     return OAuth2TokenValidatorResult.success();
//                 }
//                 return OAuth2TokenValidatorResult.failure(error);
//             }
//         };

//         // Compose the validators: first default (except issuer), then your issuer validator
//         OAuth2TokenValidator<Jwt> combinedValidators = new DelegatingOAuth2TokenValidator<>(defaultValidators, customIssuerValidator);

//         jwtDecoder.setJwtValidator(combinedValidators);

//         return jwtDecoder;
//     }
// }
