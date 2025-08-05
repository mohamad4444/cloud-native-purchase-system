package swtp.clouddemo.inventory.messaging;

import org.springframework.jms.annotation.JmsListener;
import org.springframework.stereotype.Component;
import swtp.clouddemo.common.events.PurchaseRequestedEvent;
import swtp.clouddemo.common.events.PurchaseResultEvent;
import swtp.clouddemo.common.messaging.MessageProducer;
import swtp.clouddemo.common.messaging.QueueNames;

@Component
public class PurchaseRequestedListener {

    private final MessageProducer messageProducer;

    public PurchaseRequestedListener(MessageProducer messageProducer) {
        this.messageProducer = messageProducer;
    }

    @JmsListener(destination = QueueNames.PURCHASE_REQUESTED)
    public void handlePurchaseRequested(PurchaseRequestedEvent event) {
        System.out.println("Processing purchase: " + event.getRequestId());

        // TODO: Replace this with real inventory logic
        boolean inventoryAvailable = checkInventory(event.getProduct(), event.getQuantity());

        String message = inventoryAvailable ? "Inventory reserved successfully"
                                            : "Inventory out of stock";

        PurchaseResultEvent resultEvent = new PurchaseResultEvent(
            event.getRequestId(),
            inventoryAvailable,
            message
        );

        // Send back to another queue (purchase service listens to this)
        messageProducer.sendMessage(QueueNames.PURCHASE_RESULT, resultEvent);
    }

    private boolean checkInventory(String product, int quantity) {
        // Stub logic — always accepts
        return true;
    }
}
