package swtp.clouddemo.purchase.controller;

import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;
import swtp.clouddemo.purchase.dto.PurchaseDtoIn;
import swtp.clouddemo.purchase.dto.PurchaseDtoOut;
import swtp.clouddemo.purchase.entity.PurchaseStatus;
import swtp.clouddemo.purchase.service.PurchaseService;

import java.util.List;

@RestController
@PreAuthorize("hasRole('USER')")
@RequestMapping("/purchases")
public class PurchaseController {

    private final PurchaseService purchaseService;

    public PurchaseController(PurchaseService purchaseService) {
        this.purchaseService = purchaseService;
    }
    @GetMapping("/search")
    public ResponseEntity<List<PurchaseDtoOut>> searchByProduct(@RequestParam String product) {
        return ResponseEntity.ok(purchaseService.searchByProduct(product));
    }


    @PostMapping
    public ResponseEntity<PurchaseDtoOut> createPurchase(@RequestBody PurchaseDtoIn dtoIn) {
        return ResponseEntity.ok(purchaseService.createPurchase(dtoIn));
    }
    @GetMapping
    public ResponseEntity<List<PurchaseDtoOut>> getPurchases(@RequestParam(required = false) String status) {
        if (status == null || status.equalsIgnoreCase("ALL")) {
            return ResponseEntity.ok(purchaseService.getAllPurchases());
        } else {
            return ResponseEntity.ok(purchaseService.getPurchasesByStatus(status.toUpperCase()));
        }
    }

}
