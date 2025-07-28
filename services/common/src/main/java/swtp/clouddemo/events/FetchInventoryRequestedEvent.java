package swtp.clouddemo.events;

public class FetchInventoryRequestedEvent extends BaseEvent {
    public FetchInventoryRequestedEvent() {
        super("FetchInventoryRequested");
    }
}
