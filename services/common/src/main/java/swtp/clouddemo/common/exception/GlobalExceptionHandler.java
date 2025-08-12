package swtp.clouddemo.common.exception;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.*;
import org.springframework.web.bind.annotation.*;

@ControllerAdvice
public class GlobalExceptionHandler {

    private static final Logger logger = LoggerFactory.getLogger(GlobalExceptionHandler.class);

    @ExceptionHandler(Exception.class)
    public ResponseEntity<String> handleAllExceptions(Exception ex) {
        // Build limited stacktrace string (only first 2 lines)
        StackTraceElement[] stack = ex.getStackTrace();
        StringBuilder limitedStacktrace = new StringBuilder(ex.toString()).append("\n");
        int linesToShow = Math.min(stack.length, 2);
        for (int i = 0; i < linesToShow; i++) {
            limitedStacktrace.append("\tat ").append(stack[i].toString()).append("\n");
        }

        // Log the limited stacktrace
        logger.error(limitedStacktrace.toString());

        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                             .body("An unexpected error occurred");
    }
}
