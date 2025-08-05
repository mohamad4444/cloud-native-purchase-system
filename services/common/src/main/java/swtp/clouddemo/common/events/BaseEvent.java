package swtp.clouddemo.common.events;

import com.fasterxml.jackson.annotation.JsonSubTypes;
import com.fasterxml.jackson.annotation.JsonTypeInfo;
import lombok.Data;

import java.time.Instant;

@Data
@JsonTypeInfo(
        use = JsonTypeInfo.Id.NAME,
        include = JsonTypeInfo.As.PROPERTY,
        property = "_type"  // Must match what MappingJackson2MessageConverter expects
)
@JsonSubTypes({
        @JsonSubTypes.Type(value = PurchaseRequestedEvent.class, name = "PurchaseRequested"),
        @JsonSubTypes.Type(value = PurchaseResultEvent.class, name = "PurchaseResult")
})
public abstract class BaseEvent {
    private String eventId;
    private Instant eventTimestamp;
    private String eventType;



    public BaseEvent(String eventType) {
        this.eventId = java.util.UUID.randomUUID().toString();
        this.eventTimestamp = Instant.now();
        this.eventType = eventType;
    }
}
