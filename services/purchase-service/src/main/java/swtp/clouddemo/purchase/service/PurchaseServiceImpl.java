package swtp.clouddemo.purchase.service;

import org.springframework.stereotype.Service;
import swtp.clouddemo.purchase.dto.PurchaseDtoIn;
import swtp.clouddemo.purchase.dto.PurchaseDtoOut;
import swtp.clouddemo.purchase.entity.Purchase;
import swtp.clouddemo.purchase.entity.PurchaseStatus;
import swtp.clouddemo.purchase.mapper.PurchaseMapper;
import swtp.clouddemo.purchase.repository.PurchaseRepository;

import java.util.List;
import java.util.stream.Collectors;

@Service
public class PurchaseServiceImpl implements PurchaseService {

    private final PurchaseRepository purchaseRepository;

    public PurchaseServiceImpl(PurchaseRepository purchaseRepository) {
        this.purchaseRepository = purchaseRepository;
    }

    @Override
    public List<PurchaseDtoOut> getAllPurchases() {
        return purchaseRepository.findAll()
                .stream()
                .map(PurchaseMapper::toDto)
                .collect(Collectors.toList());
    }

    @Override
    public List<PurchaseDtoOut> searchByProduct(String product) {
        return purchaseRepository.findByProductName(product)
                .stream()
                .map(PurchaseMapper::toDto)
                .collect(Collectors.toList());
    }


    @Override
    public PurchaseDtoOut createPurchase(PurchaseDtoIn dtoIn) {
        Purchase saved = purchaseRepository.save(PurchaseMapper.toEntity(dtoIn));
        return PurchaseMapper.toDto(saved);
    }

    @Override
    public List<PurchaseDtoOut> getPurchasesByStatus(String status) {
        PurchaseStatus parsedStatus = PurchaseStatus.valueOf(status.toUpperCase());
        return purchaseRepository.findByStatus(parsedStatus)
                .stream()
                .map(PurchaseMapper::toDto)
                .collect(Collectors.toList());
    }
}
