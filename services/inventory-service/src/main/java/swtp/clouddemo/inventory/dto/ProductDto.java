package swtp.clouddemo.inventory.dto;

import lombok.AllArgsConstructor;
import lombok.Data;

@Data
@AllArgsConstructor
public class ProductDto {
    private Integer id;
    private String product;
    private Integer quantity;
}
