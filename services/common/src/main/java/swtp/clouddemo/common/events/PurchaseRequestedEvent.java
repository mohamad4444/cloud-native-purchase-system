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
    private Integer purchaseId;
    private Long lagerItemId;


    public PurchaseRequestedEvent() {
        super("PurchaseRequested");
    }

    public PurchaseRequestedEvent(String product, int quantity, Integer purchaseId,Long lagerItemId) {
        super("PurchaseRequested");
        this.product = product;
        this.quantity = quantity;
        this.purchaseId = purchaseId;
        this.lagerItemId=lagerItemId;
    }


}
