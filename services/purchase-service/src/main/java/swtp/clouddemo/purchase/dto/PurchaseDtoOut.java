package swtp.clouddemo.purchase.dto;

public record PurchaseDtoOut(
        Integer id,
        String productName,
        int quantity,
        String timestamp
) {}
