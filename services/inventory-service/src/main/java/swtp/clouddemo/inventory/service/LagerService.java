package swtp.clouddemo.inventory.service;

import org.springframework.jms.annotation.JmsListener;
import org.springframework.stereotype.Service;
import swtp.clouddemo.common.dto.Product;
import swtp.clouddemo.inventory.dto.ProductDto;
import swtp.clouddemo.inventory.entity.ProductEntity;
import swtp.clouddemo.inventory.repository.LagerItemRepository;

import java.util.List;
import java.util.stream.Collectors;
@Service
public class LagerService {

    private final LagerItemRepository productRepository;

    public LagerService(LagerItemRepository productRepository) {
        this.productRepository = productRepository;
    }

    public List<ProductDto> getAllProducts() {
        return productRepository.findAll()
                .stream()
                .map(p -> new ProductDto(p.getId(), p.getProduct(), p.getQuantity()))
                .toList();
    }

}
