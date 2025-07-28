package swtp.clouddemo.events;

import java.io.Serializable;

public class PurchaseResultEvent implements Serializable {
    private String requestId;
    private boolean success;
    private String message;

    public PurchaseResultEvent() {}

    public PurchaseResultEvent(String requestId, boolean success, String message) {
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
