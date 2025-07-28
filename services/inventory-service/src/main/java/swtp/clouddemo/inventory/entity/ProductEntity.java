package swtp.clouddemo.inventory.entity;

import jakarta.persistence.*;
import lombok.Data;

@Entity
@Table(name = "lager_item")
@Data
public class ProductEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;   // was Long

    private String product;
    private Integer quantity; // optional but nice to stay consistent with wrapper types
}
