package swtp.clouddemo.common.exception;

import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;

import java.time.Instant;
import java.util.HashMap;
import java.util.Map;

/**
 * GlobalExceptionHandler handles all uncaught exceptions across the application.
 *
 * Features:
 *  - Logs exceptions with limited stack trace to avoid flooding logs
 *  - Returns a structured JSON response with timestamp, error message, and HTTP status
 */
@Slf4j
@ControllerAdvice
public class GlobalExceptionHandler {

    /**
     * Handles all uncaught exceptions.
     *
     * @param ex the exception thrown
     * @return ResponseEntity with JSON body containing error details
     */
    @ExceptionHandler(Exception.class)
    public ResponseEntity<Map<String, Object>> handleAllExceptions(Exception ex) {
        // Build limited stack trace (first 2 lines)
        StackTraceElement[] stack = ex.getStackTrace();
        StringBuilder limitedStacktrace = new StringBuilder(ex.toString()).append("\n");
        int linesToShow = Math.min(stack.length, 2);
        for (int i = 0; i < linesToShow; i++) {
            limitedStacktrace.append("\tat ").append(stack[i].toString()).append("\n");
        }

        // Log the exception with limited stacktrace
        log.error(limitedStacktrace.toString());

        // Prepare structured JSON response
        Map<String, Object> body = new HashMap<>();
        body.put("timestamp", Instant.now().toString());
        body.put("status", HttpStatus.INTERNAL_SERVER_ERROR.value());
        body.put("error", "Internal Server Error");
        body.put("message", ex.getMessage() != null ? ex.getMessage() : "Unexpected error occurred");

        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(body);
    }
}
