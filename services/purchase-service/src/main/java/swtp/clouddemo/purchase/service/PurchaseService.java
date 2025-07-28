package swtp.clouddemo.purchase.service;

import swtp.clouddemo.purchase.entity.Purchase;

import java.util.List;

public interface PurchaseService {
    List<Purchase> getRecentPurchases();
    void fetchInventory();
}
