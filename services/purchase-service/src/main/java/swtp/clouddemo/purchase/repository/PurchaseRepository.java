package swtp.clouddemo.purchase.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import swtp.clouddemo.purchase.entity.Purchase;
import swtp.clouddemo.purchase.entity.PurchaseStatus;

import java.util.List;

public interface PurchaseRepository extends JpaRepository<Purchase, Integer> {
    List<Purchase> findByStatus(PurchaseStatus parsedStatus);
    @Modifying
    @Query("UPDATE Purchase p SET p.status = :status WHERE p.id = :id")
    int updateStatusById(@Param("id") Integer id, @Param("status") PurchaseStatus status);
}
