package swtp.clouddemo.purchase.messaging;

import org.springframework.jms.annotation.JmsListener;
import org.springframework.stereotype.Component;
import swtp.clouddemo.common.events.InventoryFetchedEvent;

@Component
public class PurchaseEventListener {

    @JmsListener(destination = "purchase.events")
    public void onInventoryFetched(InventoryFetchedEvent event) {
        System.out.println("Received inventory: " + event.getProducts());
        // Here you could update a cache, database, or notify UI
    }
}
