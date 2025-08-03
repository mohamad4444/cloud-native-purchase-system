package swtp.clouddemo.purchase.entity;

import jakarta.persistence.*;
import lombok.Data;

import java.time.LocalDateTime;

@Entity
@Table(name = "purchases")
@Data
public class Purchase {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @Column(name = "lager_item_id", nullable = false)
    private Long lagerItemId;

    @Column(name = "product_name", nullable = false, length = 100)
    private String productName;

    @Column(nullable = false)
    private int quantity;

    @Column(nullable = false)
    private LocalDateTime timestamp;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private PurchaseStatus status;

    @Column(name = "user_id", nullable = false, length = 255)
    private String userId;

    public Purchase() {
        this.status = PurchaseStatus.PENDING;
    }

    public Purchase(Long lagerItemId, String productName, int quantity, String userId) {
        this.lagerItemId = lagerItemId;
        this.productName = productName;
        this.quantity = quantity;
        this.userId = userId;
        this.status = PurchaseStatus.PENDING;
    }

    @PrePersist
    protected void onCreate() {
        if (timestamp == null) {
            timestamp = LocalDateTime.now();
        }
    }
}
