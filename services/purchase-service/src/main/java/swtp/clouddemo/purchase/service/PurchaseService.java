package swtp.clouddemo.purchase.service;

import com.fasterxml.jackson.core.JsonProcessingException;
import swtp.clouddemo.purchase.dto.PurchaseDtoIn;
import swtp.clouddemo.purchase.dto.PurchaseDtoOut;
import swtp.clouddemo.purchase.entity.Purchase;

import java.util.List;

public interface PurchaseService {
    List<PurchaseDtoOut> getAllPurchases();
    PurchaseDtoOut createPurchase(PurchaseDtoIn dtoIn) throws JsonProcessingException;
    List<PurchaseDtoOut> getPurchasesByStatus(String status);
}
