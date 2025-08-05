package swtp.clouddemo.inventory.service;

import org.springframework.stereotype.Service;
import swtp.clouddemo.inventory.dto.ProductDto;
import swtp.clouddemo.inventory.entity.ProductEntity;
import swtp.clouddemo.inventory.repository.LagerItemRepository;

import java.util.List;
import java.util.Optional;

@Service
public class LagerService {

    private final LagerItemRepository productRepository;

    public LagerService(LagerItemRepository productRepository) {
        this.productRepository = productRepository;
    }

    // Only return products with quantity > 0
    public List<ProductDto> getAllProducts() {
        return productRepository.findAll()
                .stream()
                .filter(p -> p.getQuantity() > 0)
                .map(p -> new ProductDto(p.getId(), p.getProduct(), p.getQuantity()))
                .toList();
    }

    // Consume 1 quantity of the product if available
    public boolean consumeProductIfAvailable(long productId, int quantity) {
        Optional<ProductEntity> optional = productRepository.findById(productId);

        if (optional.isEmpty()) {
            return false;
        }

        ProductEntity product = optional.get();

        if (product.getQuantity() <= 0 || quantity > product.getQuantity()) {
            return false;
        }

        product.setQuantity(product.getQuantity() - quantity);
        productRepository.save(product);

        return true;
    }
}
