package swtp.clouddemo.purchase.service;

import com.fasterxml.jackson.core.JsonProcessingException;
import jakarta.transaction.Transactional;
import org.springframework.stereotype.Service;
import swtp.clouddemo.common.events.PurchaseRequestedEvent;
import swtp.clouddemo.common.messaging.MessageProducer;
import swtp.clouddemo.common.messaging.QueueNames;
import swtp.clouddemo.common.security.JwtService;
import swtp.clouddemo.purchase.dto.PurchaseDtoIn;
import swtp.clouddemo.purchase.dto.PurchaseDtoOut;
import swtp.clouddemo.purchase.entity.Purchase;
import swtp.clouddemo.purchase.entity.PurchaseStatus;
import swtp.clouddemo.purchase.mapper.PurchaseMapper;
import swtp.clouddemo.purchase.repository.PurchaseRepository;
import lombok.extern.slf4j.Slf4j;
import java.util.List;
import java.util.stream.Collectors;

@Service
@Slf4j
public class PurchaseServiceImpl implements PurchaseService {

    private final PurchaseRepository purchaseRepository;
    private final JwtService jwtService;
    private final MessageProducer messageProducer;
    public PurchaseServiceImpl(PurchaseRepository purchaseRepository, JwtService jwtService, MessageProducer messageProducer) {
        this.purchaseRepository = purchaseRepository;
        this.jwtService = jwtService;
        this.messageProducer = messageProducer;
    }

    @Override
    public List<PurchaseDtoOut> getAllPurchases() {
        return purchaseRepository.findAll()
                .stream()
                .map(PurchaseMapper::toDto)
                .collect(Collectors.toList());
    }

    @Override
    public PurchaseDtoOut createPurchase(PurchaseDtoIn dtoIn) throws JsonProcessingException {
        String userId = jwtService.getUserId();
        Purchase saved = purchaseRepository.save(PurchaseMapper.toEntity(dtoIn,userId));
        PurchaseRequestedEvent event = new PurchaseRequestedEvent(
                saved.getProductName(),
                saved.getQuantity(),
                saved.getId(),
                saved.getLagerItemId()
        );
        log.info("Sending event: {}",event);
        messageProducer.sendMessage(QueueNames.PURCHASE_REQUESTED, event);
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

    @Transactional
    @Override
    public PurchaseDtoOut updatePurchaseStatus(Integer purchaseId, String statusStr) {
        PurchaseStatus status;
        try {
            status = PurchaseStatus.valueOf(statusStr.toUpperCase());
        } catch (IllegalArgumentException e) {
            throw new IllegalArgumentException("Invalid purchase status: " + statusStr);
        }

        Purchase purchase = purchaseRepository.findById(purchaseId)
                .orElseThrow(() -> new IllegalArgumentException("Purchase not found with id: " + purchaseId));

        purchase.setStatus(status);
        Purchase updated = purchaseRepository.save(purchase);
        return PurchaseMapper.toDto(updated);
    }
}
