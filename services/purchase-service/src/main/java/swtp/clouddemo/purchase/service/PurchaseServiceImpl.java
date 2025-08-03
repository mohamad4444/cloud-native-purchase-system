package swtp.clouddemo.purchase.service;

import org.springframework.stereotype.Service;
import swtp.clouddemo.common.service.JwtService;
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
    private final JwtService jwtService;
    public PurchaseServiceImpl(PurchaseRepository purchaseRepository, JwtService jwtService) {
        this.purchaseRepository = purchaseRepository;
        this.jwtService = jwtService;
    }

    @Override
    public List<PurchaseDtoOut> getAllPurchases() {
        return purchaseRepository.findAll()
                .stream()
                .map(PurchaseMapper::toDto)
                .collect(Collectors.toList());
    }

    @Override
    public PurchaseDtoOut createPurchase(PurchaseDtoIn dtoIn) {
        String userId = jwtService.getUserId();
        Purchase saved = purchaseRepository.save(PurchaseMapper.toEntity(dtoIn,userId));
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
