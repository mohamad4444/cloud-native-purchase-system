package swtp.clouddemo.inventory.messaging;

import org.springframework.jms.annotation.JmsListener;
import org.springframework.stereotype.Component;

@Component
public class MessageConsumer {

    @JmsListener(destination = "${app.queue.name}")
    public void receiveMessage(String message) {
        System.out.println("Consumer received: " + message);
    }
}
