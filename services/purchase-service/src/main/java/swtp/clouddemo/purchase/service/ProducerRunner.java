package swtp.clouddemo.purchase.service;

import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;

@Component
public class ProducerRunner implements CommandLineRunner {

    private final MessageProducer messageProducer;

    public ProducerRunner(MessageProducer messageProducer) {
        this.messageProducer = messageProducer;
    }

    @Override
    public void run(String... args) throws Exception {
        messageProducer.sendMessage("Hello from Service A!");
        messageProducer.sendMessage("Another test message!");
    }
}
