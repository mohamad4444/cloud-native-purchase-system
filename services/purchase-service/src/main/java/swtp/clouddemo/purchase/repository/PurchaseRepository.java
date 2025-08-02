package swtp.clouddemo.purchase.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import swtp.clouddemo.purchase.entity.Purchase;
import swtp.clouddemo.purchase.entity.PurchaseStatus;

import java.util.List;

public interface PurchaseRepository extends JpaRepository<Purchase, Long> {
    List<Purchase> findByStatus(PurchaseStatus parsedStatus);
}
