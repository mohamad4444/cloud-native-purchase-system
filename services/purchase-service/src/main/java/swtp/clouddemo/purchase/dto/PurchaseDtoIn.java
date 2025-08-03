package swtp.clouddemo.purchase.dto;

public record PurchaseDtoIn(
        Long lagerItemId,
        String productName,
        int quantity,
        String userId
) {}
