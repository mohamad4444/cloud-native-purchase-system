package swtp.clouddemo.inventory.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import swtp.clouddemo.inventory.entity.ProductEntity;

public interface LagerItemRepository extends JpaRepository<ProductEntity, Long> {
}