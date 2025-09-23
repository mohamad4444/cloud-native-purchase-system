package swtp.clouddemo.common.config;

import org.springframework.boot.context.event.ApplicationReadyEvent;
import org.springframework.context.ApplicationListener;
import org.springframework.core.env.ConfigurableEnvironment;
import org.springframework.core.env.PropertySource;
import org.springframework.stereotype.Component;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import java.util.Arrays;

@Component
public class PropertyLogger implements ApplicationListener<ApplicationReadyEvent> {

    private static final Logger logger = LoggerFactory.getLogger(PropertyLogger.class);

    @Override
    public void onApplicationEvent(ApplicationReadyEvent event) {
        ConfigurableEnvironment env = event.getApplicationContext().getEnvironment();
        
        logger.info("======= APPLICATION PROPERTIES =======");
        logger.info("Active profiles: {}", Arrays.toString(env.getActiveProfiles()));
        
        for (PropertySource<?> propertySource : env.getPropertySources()) {
            logger.info("--- Property Source: {} ---", propertySource.getName());
            if (propertySource.getSource() instanceof java.util.Map) {
                @SuppressWarnings("unchecked")
                java.util.Map<String, Object> sourceMap = (java.util.Map<String, Object>) propertySource.getSource();
                sourceMap.forEach((key, value) -> {
                    if (key.toLowerCase().contains("password")) {
                        logger.info("{} = ****** (masked)", key);
                    } else {
                        logger.info("{} = {}", key, value);
                    }
                });
            }
        }
        logger.info("======================================");
        
        // Also log the specific environment variables you're debugging
        logSpecificProperties(env);
    }

    private void logSpecificProperties(ConfigurableEnvironment env) {
        logger.info("======= DEBUG ENV VARIABLES =======");
        String[] debugVars = {
            "DATASOURCE_URL", "DATASOURCE_USERNAME", "DATASOURCE_PASSWORD",
            "SERVER_PORT", "SPRING_PROFILES_ACTIVE", "APP_NAME",
            "ARTEMIS_BROKER_URL", "ARTEMIS_USER", "ARTEMIS_PASSWORD",
            "KEYCLOAK_ISSUER_URI", "KEYCLOAK_JWK_SET_URI",
            "SPRING_SECURITY_LOG_LEVEL", "APP_QUEUE_NAME"
        };
        
        for (String var : debugVars) {
            String value = env.getProperty(var);
            if (value != null) {
                // if (var.contains("PASSWORD")) {
                //     logger.info("{} = ******", var);
                // } else {
                    logger.info("{} = {}", var, value);
                // }
            } else {
                logger.info("{} = (not set)", var);
            }
        }
        logger.info("====================================");
    }
}