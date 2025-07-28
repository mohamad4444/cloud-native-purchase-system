package swtp.clouddemo.inventory.dtos;

import lombok.Data;

@Data
public class Product {
    private String productName;
    private int quantity;

    public Product(String product, Integer quantity) {
        this.productName = product;
        this.quantity = quantity;
    }

    // Constructors, getters, setters
}
