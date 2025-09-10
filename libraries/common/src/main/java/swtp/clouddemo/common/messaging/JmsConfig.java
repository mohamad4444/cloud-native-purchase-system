package swtp.clouddemo.common.messaging;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.jms.support.converter.MappingJackson2MessageConverter;
import org.springframework.jms.support.converter.MessageType;

/**
 * JmsConfig provides configuration for JMS message conversion using Jackson.
 *
 * <p>
 * It registers a {@link MappingJackson2MessageConverter} to automatically convert
 * Java objects to JSON and vice versa when sending/receiving JMS messages.
 * The converter also supports Java 8 date/time types via {@link JavaTimeModule}.
 *
 * <p>
 * The "_type" property in JSON messages is used to determine the target class
 * during deserialization. This is required for polymorphic events (like BaseEvent subclasses).
 */
@Configuration
public class JmsConfig {

    /**
     * Configures a Jackson-based JMS message converter.
     *
     * @return a MappingJackson2MessageConverter that converts messages to/from JSON
     */
    @Bean
    public MappingJackson2MessageConverter jacksonJmsMessageConverter() {
        ObjectMapper objectMapper = new ObjectMapper();
        // Enable support for Java 8 date/time types
        objectMapper.registerModule(new JavaTimeModule());

        MappingJackson2MessageConverter converter = new MappingJackson2MessageConverter();
        converter.setTargetType(MessageType.TEXT);      // Convert messages to TEXT format
        converter.setTypeIdPropertyName("_type");      // Use "_type" property for type mapping
        converter.setObjectMapper(objectMapper);      // Use the customized ObjectMapper

        return converter;
    }
}
