package swtp.clouddemo.common.events;

import lombok.Getter;
import lombok.Setter;
import swtp.clouddemo.common.dto.Product;

import java.util.List;
@Getter
@Setter
public class InventoryFetchedEvent extends BaseEvent {
    private List<Product> products;

    public InventoryFetchedEvent(List<Product> products) {
        super("InventoryFetched");
        this.products = products;
    }

    // Getters / setters
}
