package swtp.clouddemo.purchase.repository;

import swtp.clouddemo.common.dto.Product;
import swtp.clouddemo.purchase.entity.Purchase;
import swtp.clouddemo.purchase.entity.PurchaseStatus;

import java.util.Collection;
import java.util.List;

public interface PurchaseRepositoryCustom {
    List<Purchase> findByStatus(PurchaseStatus parsedStatus);
}
