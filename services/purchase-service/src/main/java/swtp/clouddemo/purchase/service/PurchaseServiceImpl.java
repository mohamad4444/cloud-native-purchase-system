package swtp.clouddemo.purchase.service;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.extern.log4j.Log4j2;
import org.springframework.stereotype.Service;
import swtp.clouddemo.common.events.PurchaseRequestedEvent;
import swtp.clouddemo.common.config.JwtService;
import swtp.clouddemo.common.messaging.MessageProducer;
import swtp.clouddemo.common.messaging.QueueNames;
import swtp.clouddemo.purchase.dto.PurchaseDtoIn;
import swtp.clouddemo.purchase.dto.PurchaseDtoOut;
import swtp.clouddemo.purchase.entity.Purchase;
import swtp.clouddemo.purchase.entity.PurchaseStatus;
import swtp.clouddemo.purchase.mapper.PurchaseMapper;
import swtp.clouddemo.purchase.repository.PurchaseRepository;

import java.util.List;
import java.util.stream.Collectors;

@Service
@Log4j2
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
                String.valueOf(saved.getId())
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

}
