package swtp.clouddemo.purchase.mapper;

import swtp.clouddemo.purchase.dto.PurchaseDtoIn;
import swtp.clouddemo.purchase.dto.PurchaseDtoOut;
import swtp.clouddemo.purchase.entity.Purchase;

import java.time.format.DateTimeFormatter;

public class PurchaseMapper {

    private static final DateTimeFormatter FORMATTER = DateTimeFormatter.ISO_LOCAL_DATE_TIME;

    public static Purchase toEntity(PurchaseDtoIn dtoIn) {
        if (dtoIn == null) return null;

        Purchase purchase = new Purchase();
        purchase.setProductName(dtoIn.getProductName());
        purchase.setQuantity(dtoIn.getQuantity());
        return purchase;
    }

    public static PurchaseDtoOut toDto(Purchase purchase) {
        if (purchase == null) return null;

        return new PurchaseDtoOut(
            purchase.getId(),
            purchase.getProductName(),
            purchase.getQuantity(),
            purchase.getTimestamp() != null ? purchase.getTimestamp().format(FORMATTER) : null
        );
    }
}
