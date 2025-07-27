import org.springframework.jms.annotation.JmsListener;

//package swtp.clouddemo.inventory.messaging;
//
//import swtp.clouddemo.inventory.entity.LagerItem;
//import swtp.clouddemo.inventory.repository.LagerItemRepository;
//import org.springframework.jms.annotation.JmsListener;
//import org.springframework.stereotype.Component;
//
//@Component
//public class LagerMessageListener {
//
//    private final LagerItemRepository repository;
//
//    public LagerMessageListener(LagerItemRepository repository) {
//        this.repository = repository;
//    }
//
//    @JmsListener(destination = "lager-queue")
//    public void receiveMessage(String message) {
//        // You can parse JSON or custom messages here
//        System.out.println("Received: " + message);
//
//        // Example stub logic
//        LagerItem item = new LagerItem();
//        item.setProduct(message);
//        item.setQuantity(1);
//        repository.save(item);
//    }
//@JmsListener(destination = "purchase.to.inventory")
//public void handleOrderEvent(String message) {
//    System.out.println("Received order event: " + message);
//    // Update inventory accordingly
//}
//}
