package swtp.clouddemo.purchase.repository;

import swtp.clouddemo.purchase.entity.Purchase;
import swtp.clouddemo.purchase.entity.PurchaseStatus;

import java.util.List;

public interface PurchaseRepositoryCustom {
    List<Purchase> findByStatusAndUserId(PurchaseStatus status, String userId);
}
