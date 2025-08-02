package swtp.clouddemo.purchase.repository;

import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import org.springframework.stereotype.Repository;
import swtp.clouddemo.purchase.entity.Purchase;
import swtp.clouddemo.purchase.entity.PurchaseStatus;

import java.util.List;

@Repository
public class PurchaseRepositoryImpl implements PurchaseRepositoryCustom {

    @PersistenceContext
    private EntityManager em;


    @Override
    public List<Purchase> findByStatus(PurchaseStatus parsedStatus) {
        String jpql = "SELECT p FROM Purchase p WHERE p.status = :status";
        return em.createQuery(jpql, Purchase.class)
                .setParameter("status", parsedStatus)
                .getResultList();
    }

}
