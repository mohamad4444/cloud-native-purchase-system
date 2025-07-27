package swtp.clouddemo.purchase.dto;

public class PurchaseDtoIn {

    private String productName;
    private int quantity;

    public PurchaseDtoIn() {}

    public PurchaseDtoIn(String productName, int quantity) {
        this.productName = productName;
        this.quantity = quantity;
    }

    public String getProductName() {
        return productName;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setProductName(String productName) {
        this.productName = productName;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }
}
