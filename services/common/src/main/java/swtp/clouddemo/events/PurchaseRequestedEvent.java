package swtp.clouddemo.events;

import java.io.Serializable;

public class PurchaseRequestedEvent implements Serializable {
    private String product;
    private int quantity;
    private String requestId;

    public PurchaseRequestedEvent() {}

    public PurchaseRequestedEvent(String product, int quantity, String requestId) {
        this.product = product;
        this.quantity = quantity;
        this.requestId = requestId;
    }

    public String getProduct() {
        return product;
    }

    public void setProduct(String product) {
        this.product = product;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public String getRequestId() {
        return requestId;
    }

    public void setRequestId(String requestId) {
        this.requestId = requestId;
    }
}
