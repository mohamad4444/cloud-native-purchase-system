package swtp.clouddemo.purchase.service;

import org.springframework.jms.core.JmsTemplate;
import org.springframework.stereotype.Service;
import swtp.clouddemo.purchase.entity.Purchase;
import swtp.clouddemo.purchase.event.FetchInventoryRequestedEvent;

import java.util.List;

@Service
public class PurchaseServiceImpl implements PurchaseService {
    private final JmsTemplate jmsTemplate;

    public PurchaseServiceImpl(JmsTemplate jmsTemplate) {
        this.jmsTemplate = jmsTemplate;
    }

    public List<Purchase> getRecentPurchases() {
        //TODO
        return null;
    }

    public void fetchInventory() {
        FetchInventoryRequestedEvent event = new FetchInventoryRequestedEvent();
        jmsTemplate.convertAndSend("inventory.events", event);
    }
}
