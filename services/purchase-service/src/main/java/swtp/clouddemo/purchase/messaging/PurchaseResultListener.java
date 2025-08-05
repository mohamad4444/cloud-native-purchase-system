package swtp.clouddemo.purchase.messaging;

import org.springframework.jms.annotation.JmsListener;
import org.springframework.stereotype.Component;
import swtp.clouddemo.common.events.PurchaseResultEvent;
import swtp.clouddemo.common.messaging.QueueNames;

@Component
public class PurchaseResultListener {

    @JmsListener(destination = QueueNames.PURCHASE_RESULT)
    public void handlePurchaseResult(PurchaseResultEvent event) {
        System.out.println("Received result for request ID: " + event.getRequestId());
        System.out.println("Status: " + (event.isSuccess() ? "SUCCESS" : "FAILED"));
        System.out.println("Message: " + event.getMessage());

        // TODO: Update purchase record in DB
    }
}
