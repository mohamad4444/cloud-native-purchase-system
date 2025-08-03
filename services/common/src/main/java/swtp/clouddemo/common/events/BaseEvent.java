package swtp.clouddemo.common.events;

import lombok.Data;

import java.time.Instant;

@Data
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
