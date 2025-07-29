package swtp.clouddemo.purchase.dto;

public class PurchaseDtoOut {

    private Integer id;
    private String productName;
    private int quantity;
    private String timestamp;

    public PurchaseDtoOut() {}

    public PurchaseDtoOut(Integer id, String productName, int quantity, String timestamp) {
        this.id = id;
        this.productName = productName;
        this.quantity = quantity;
        this.timestamp = timestamp;
    }

    public Integer getId() {
        return id;
    }

    public String getProductName() {
        return productName;
    }

    public int getQuantity() {
        return quantity;
    }

    public String getTimestamp() {
        return timestamp;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public void setProductName(String productName) {
        this.productName = productName;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public void setTimestamp(String timestamp) {
        this.timestamp = timestamp;
    }
}
