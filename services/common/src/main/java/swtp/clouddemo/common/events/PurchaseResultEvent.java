package swtp.clouddemo.common.events;

import lombok.Data;

import java.io.Serializable;

public class PurchaseResultEvent  extends BaseEvent {
    private String requestId;
    private boolean success;
    private String message;

    public PurchaseResultEvent() {
        super("PurchaseResult");
    }

    public PurchaseResultEvent(String requestId, boolean success, String message) {
        super("PurchaseResult");
        this.requestId = requestId;
        this.success = success;
        this.message = message;
    }

    public String getRequestId() {
        return requestId;
    }

    public void setRequestId(String requestId) {
        this.requestId = requestId;
    }

    public boolean isSuccess() {
        return success;
    }

    public void setSuccess(boolean success) {
        this.success = success;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }
}
