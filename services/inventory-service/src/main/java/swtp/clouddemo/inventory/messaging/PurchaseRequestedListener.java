package swtp.clouddemo.inventory.messaging;

import org.springframework.jms.annotation.JmsListener;
import org.springframework.stereotype.Component;
import swtp.clouddemo.common.events.PurchaseRequestedEvent;
import swtp.clouddemo.common.events.PurchaseResultEvent;
import swtp.clouddemo.common.messaging.MessageProducer;
import swtp.clouddemo.common.messaging.QueueNames;
import swtp.clouddemo.inventory.service.LagerService;

@Component
public class PurchaseRequestedListener {

    private final MessageProducer messageProducer;
    private final LagerService lagerService;
    public PurchaseRequestedListener(MessageProducer messageProducer, LagerService lagerService) {
        this.messageProducer = messageProducer;
        this.lagerService = lagerService;
    }

    @JmsListener(destination = QueueNames.PURCHASE_REQUESTED)
    public void handlePurchaseRequested(PurchaseRequestedEvent event) {
        System.out.println("Processing purchase: " + event.getPurchaseId());

        boolean inventoryAvailable = lagerService.consumeProductIfAvailable(event.getLagerItemId(),event.getQuantity());

        String message = inventoryAvailable ? "Inventory reserved successfully"
                                            : "Inventory out of stock";

        PurchaseResultEvent resultEvent = new PurchaseResultEvent(
            event.getPurchaseId(),
            inventoryAvailable,
            message
        );

        // Send back to another queue (purchase service listens to this)
        messageProducer.sendMessage(QueueNames.PURCHASE_RESULT, resultEvent);
    }
}
