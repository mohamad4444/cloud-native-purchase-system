package swtp.clouddemo.purchase.repository;

import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import org.springframework.stereotype.Repository;
import swtp.clouddemo.purchase.entity.Purchase;
import swtp.clouddemo.purchase.entity.PurchaseStatus;

import java.util.List;

@Repository
public class PurchaseRepositoryCustomImpl implements PurchaseRepositoryCustom {

    @PersistenceContext
    private EntityManager entityManager;

    @Override
    public List<Purchase> findByStatusAndUserId(PurchaseStatus status, String userId) {
        String jpql = "SELECT p FROM Purchase p WHERE p.status = :status AND p.userId = :userId";
        return entityManager.createQuery(jpql, Purchase.class)
                .setParameter("status", status)
                .setParameter("userId", userId)
                .getResultList();
    }
}
