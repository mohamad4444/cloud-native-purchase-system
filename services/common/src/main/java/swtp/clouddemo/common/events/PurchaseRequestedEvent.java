package swtp.clouddemo.common.events;

import lombok.Data;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

import java.io.Serializable;
@Setter
@Getter
@ToString
public class PurchaseRequestedEvent extends BaseEvent {
    private String product;
    private int quantity;
    private String requestId;

    public PurchaseRequestedEvent() {
        super("PurchaseRequested");
    }

    public PurchaseRequestedEvent(String product, int quantity, String requestId) {
        super("PurchaseRequested");
        this.product = product;
        this.quantity = quantity;
        this.requestId = requestId;
    }

}
