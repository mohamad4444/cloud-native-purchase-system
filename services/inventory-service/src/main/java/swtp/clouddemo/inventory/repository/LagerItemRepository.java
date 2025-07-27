package swtp.clouddemo.inventory.repository;

import swtp.clouddemo.inventory.entity.LagerItem;
import org.springframework.data.jpa.repository.JpaRepository;

public interface LagerItemRepository extends JpaRepository<LagerItem, Long> {
}