package swtp.clouddemo.common.events;

public class FetchInventoryRequestedEvent extends BaseEvent {
    public FetchInventoryRequestedEvent() {
        super("FetchInventoryRequested");
    }
}
