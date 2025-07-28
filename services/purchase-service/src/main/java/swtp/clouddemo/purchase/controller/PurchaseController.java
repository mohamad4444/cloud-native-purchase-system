package swtp.clouddemo.purchase.controller;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import swtp.clouddemo.purchase.dto.PurchaseDtoIn;
import swtp.clouddemo.purchase.dto.PurchaseDtoOut;
import swtp.clouddemo.purchase.entity.Purchase;
import swtp.clouddemo.purchase.mapper.PurchaseMapper;
import swtp.clouddemo.purchase.repository.PurchaseRepository;
import swtp.clouddemo.purchase.service.PurchaseService;
import swtp.clouddemo.purchase.service.PurchaseServiceImpl;

import java.util.List;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/purchases")
public class PurchaseController {

    private final PurchaseRepository purchaseRepository;

    private final PurchaseService purchaseService;

    public PurchaseController(PurchaseRepository purchaseRepository, PurchaseService purchaseService) {
        this.purchaseRepository = purchaseRepository;
        this.purchaseService = purchaseService;
    }

    @GetMapping
    public List<PurchaseDtoOut> getAllPurchases() {
        return purchaseRepository.findAll()
                .stream()
                .map(PurchaseMapper::toDto)
                .collect(Collectors.toList());
    }

    @GetMapping("/search")
    public List<PurchaseDtoOut> searchByProduct(@RequestParam String product) {
        return purchaseRepository.findByProductName(product)
                .stream()
                .map(PurchaseMapper::toDto)
                .collect(Collectors.toList());
    }

    @GetMapping("/large")
    public List<PurchaseDtoOut> getLargeOrders(@RequestParam(defaultValue = "10") int minQty) {
        return purchaseRepository.findLargeOrders(minQty)
                .stream()
                .map(PurchaseMapper::toDto)
                .collect(Collectors.toList());
    }

    @PostMapping
    public ResponseEntity<PurchaseDtoOut> createPurchase(@RequestBody PurchaseDtoIn dtoIn) {
        Purchase saved = purchaseRepository.save(PurchaseMapper.toEntity(dtoIn));
        return ResponseEntity.ok(PurchaseMapper.toDto(saved));
    }


    @GetMapping("/fetch-inventory")
    public String fetchInventory() {
        purchaseService.fetchInventory();
        return "Fetch request sent to Inventory Service!";
    }
}
