package swtp.clouddemo.purchase.repository;

import swtp.clouddemo.purchase.entity.Purchase;

import java.util.List;

public interface PurchaseRepositoryCustom {
    List<Purchase> findLargeOrders(int minQuantity);
}
