package swtp.clouddemo.purchase.entity;

import jakarta.persistence.*;
import lombok.Data;
import swtp.clouddemo.purchase.util.PurchaseStatus;

import java.time.LocalDateTime;

@Entity
@Table(name = "purchases")
@Data
public class Purchase {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @Column(name = "product_name", nullable = false, length = 100)
    private String productName;

    @Column(nullable = false)
    private int quantity;

    @Column(columnDefinition = "TIMESTAMP DEFAULT CURRENT_TIMESTAMP")
    private LocalDateTime timestamp;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private PurchaseStatus status;
    // Constructors

    public Purchase() {
        this.status = PurchaseStatus.PENDING;
    }
    public Purchase(String productName, int quantity) {
        this.productName = productName;
        this.quantity = quantity;
    }

}
