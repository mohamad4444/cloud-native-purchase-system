package swtp.clouddemo.inventory.service;

import org.springframework.jms.annotation.JmsListener;
import org.springframework.stereotype.Service;
import swtp.clouddemo.inventory.dtos.Product;
import swtp.clouddemo.inventory.repository.LagerItemRepository;

import java.util.List;
import java.util.stream.Collectors;
@Service
public class LagerService {

    private final LagerItemRepository productRepository;

    public LagerService(LagerItemRepository productRepository) {
        this.productRepository = productRepository;
    }
    public List<Product> fetchAvailableProducts() {
        return productRepository.findAll().stream()
                .map(p -> new Product(p.getProduct(), p.getQuantity()))
                .collect(Collectors.toList());
    }

}
