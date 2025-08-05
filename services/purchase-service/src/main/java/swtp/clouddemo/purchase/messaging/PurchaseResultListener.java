package swtp.clouddemo.purchase.messaging;

import org.springframework.jms.annotation.JmsListener;
import org.springframework.stereotype.Component;
import swtp.clouddemo.common.events.PurchaseResultEvent;
import swtp.clouddemo.common.messaging.QueueNames;
import swtp.clouddemo.purchase.entity.PurchaseStatus;
import swtp.clouddemo.purchase.service.PurchaseService;

@Component
public class PurchaseResultListener {
    private final PurchaseService purchaseService;

    public PurchaseResultListener(PurchaseService purchaseService) {
        this.purchaseService = purchaseService;
    }

    @JmsListener(destination = QueueNames.PURCHASE_RESULT)
    public void handlePurchaseResult(PurchaseResultEvent event) {
        System.out.println("Received result for Purchase ID: " + event.getPurchaseId());
        System.out.println("Status: " + (event.isSuccess() ? "SUCCESS" : "FAILED"));
        System.out.println("Message: " + event.getMessage());
        purchaseService.updatePurchaseStatus(event.getPurchaseId(),event.isSuccess()? PurchaseStatus.CONFIRMED.name():PurchaseStatus.REJECTED.name());
    }
}
