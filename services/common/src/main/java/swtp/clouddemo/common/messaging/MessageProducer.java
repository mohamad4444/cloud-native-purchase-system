package swtp.clouddemo.common.messaging;

import org.springframework.jms.core.JmsTemplate;
import org.springframework.stereotype.Component;

/**
 * MessageProducer is a simple wrapper around {@link JmsTemplate} for sending JMS messages.
 *
 * <p>
 * It abstracts the message sending logic, allowing other components to send
 * messages to a specific queue without dealing directly with the JMS API.
 *
 * <p>
 * Messages are automatically converted to JSON using the configured
 * {@link MappingJackson2MessageConverter} (see {@link JmsConfig}).
 */
@Component
public class MessageProducer {

    private final JmsTemplate jmsTemplate;

    public MessageProducer(JmsTemplate jmsTemplate) {
        this.jmsTemplate = jmsTemplate;
    }

    /**
     * Sends a message to the specified JMS queue.
     *
     * @param queueName the name of the target queue
     * @param message   the object to send; it will be converted to JSON
     */
    public void sendMessage(String queueName, Object message) {
        jmsTemplate.convertAndSend(queueName, message);
    }
}
