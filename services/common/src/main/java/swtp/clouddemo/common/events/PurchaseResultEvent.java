package swtp.clouddemo.common.events;

import lombok.Data;
import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;

@Getter
@Setter
public class PurchaseResultEvent  extends BaseEvent {
    private Integer purchaseId;
    private boolean success;
    private String message;

    public PurchaseResultEvent() {
        super("PurchaseResult");
    }

    public PurchaseResultEvent(Integer purchaseId, boolean success, String message) {
        super("PurchaseResult");
        this.purchaseId = purchaseId;
        this.success = success;
        this.message = message;
    }


}
