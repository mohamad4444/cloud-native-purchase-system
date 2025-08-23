package swtp.clouddemo.common.events;

import com.fasterxml.jackson.annotation.JsonSubTypes;
import com.fasterxml.jackson.annotation.JsonTypeInfo;
import lombok.Data;

import java.time.Instant;

/**
 * BaseEvent is the abstract parent class for all application events.
 * <p>
 * Features:
 *  - Provides common fields for all events: eventId, eventTimestamp, eventType
 *  - Automatically generates a unique eventId (UUID) and sets the eventTimestamp
 *  - Supports polymorphic JSON serialization and deserialization with Jackson
 *    so that subclasses can be sent over messaging systems (e.g., JMS) and
 *    automatically deserialized into the correct subtype.
 *
 * <p>
 * Subclasses must call the constructor with the appropriate eventType.
 */
@Data
@JsonTypeInfo(
        use = JsonTypeInfo.Id.NAME,       // Use the name of the subtype as identifier
        include = JsonTypeInfo.As.PROPERTY, // Include as a property in JSON
        property = "_type"                // Must match what MappingJackson2MessageConverter expects
)
@JsonSubTypes({
        @JsonSubTypes.Type(value = PurchaseRequestedEvent.class, name = "PurchaseRequested"),
        @JsonSubTypes.Type(value = PurchaseResultEvent.class, name = "PurchaseResult")
})
public abstract class BaseEvent {

    /**
     * Unique identifier for the event (UUID).
     */
    private String eventId;

    /**
     * Timestamp of when the event was created.
     */
    private Instant eventTimestamp;

    /**
     * Type of event (usually matches subclass type or a business identifier).
     */
    private String eventType;

    /**
     * Constructor to initialize the BaseEvent.
     * Automatically sets a unique eventId and the current timestamp.
     *
     * @param eventType a descriptive type string for the event
     */
    public BaseEvent(String eventType) {
        this.eventId = java.util.UUID.randomUUID().toString();
        this.eventTimestamp = Instant.now();
        this.eventType = eventType;
    }
}
