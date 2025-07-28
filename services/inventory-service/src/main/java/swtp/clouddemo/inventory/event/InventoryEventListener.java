package swtp.clouddemo.inventory.event;


import org.springframework.jms.annotation.JmsListener;
import org.springframework.jms.core.JmsTemplate;
import org.springframework.stereotype.Component;
import swtp.clouddemo.inventory.dtos.Product;
import swtp.clouddemo.inventory.repository.LagerItemRepository;
import swtp.clouddemo.inventory.service.LagerService;

import java.util.List;

@Component
public class InventoryEventListener {

    private final LagerService inventoryService;
    private final JmsTemplate jmsTemplate;

    public InventoryEventListener(LagerService inventoryService, JmsTemplate jmsTemplate) {
        this.inventoryService = inventoryService;
        this.jmsTemplate = jmsTemplate;
    }

    @JmsListener(destination = "inventory.events")
    public void handleInventoryRequest(FetchInventoryRequestedEvent event) {
        System.out.println("Received inventory fetch request event");

        List<Product> products = inventoryService.fetchAvailableProducts();

        InventoryFetchedEvent response = new InventoryFetchedEvent(products);
        jmsTemplate.convertAndSend("purchase.events", response);
    }
}
