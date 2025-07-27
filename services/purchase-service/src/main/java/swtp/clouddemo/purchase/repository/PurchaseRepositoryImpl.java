package swtp.clouddemo.purchase.repository;

import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import org.springframework.stereotype.Repository;
import swtp.clouddemo.purchase.entity.Purchase;

import java.util.List;

@Repository
public class PurchaseRepositoryImpl implements PurchaseRepositoryCustom {

    @PersistenceContext
    private EntityManager em;

    @Override
    public List<Purchase> findLargeOrders(int minQuantity) {
        String jpql = "SELECT p FROM Purchase p WHERE p.quantity > :minQty";
        return em.createQuery(jpql, Purchase.class)
                .setParameter("minQty", minQuantity)
                .getResultList();
    }
}
