package swtp.clouddemo.inventory.controller;

import lombok.RequiredArgsConstructor;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import swtp.clouddemo.inventory.dto.ProductDto;
import swtp.clouddemo.inventory.service.LagerService;

import java.util.List;

@RestController
@RequestMapping("inventory-api")
@RequiredArgsConstructor
public class ProductController {

    private final LagerService productService;

    @PreAuthorize("hasRole('USER')")
    @GetMapping("/inventory")
    public List<ProductDto> getAllProducts() {
        return productService.getAllProducts();
    }
}