package swtp.clouddemo.common.aop;

import io.micrometer.core.instrument.Counter;
import io.micrometer.core.instrument.MeterRegistry;
import io.micrometer.core.instrument.Timer;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Pointcut;
import org.slf4j.MDC;
import org.springframework.stereotype.Component;

import java.util.concurrent.TimeUnit;

/**
 * LoggingAspect provides AOP-based logging and metrics for method execution.
 */
@Slf4j
@Aspect
@Component
@RequiredArgsConstructor
public class LoggingAspect {

    private final MeterRegistry meterRegistry;
    private static final long SLOW_METHOD_THRESHOLD_MS = 1000;

    @Pointcut("within(swtp.clouddemo..service..*) || " +
              "within(swtp.clouddemo..controller..*) || " +
              "within(swtp.clouddemo..repository..*)")
    public void applicationPackagePointcut() {}

    @Around("applicationPackagePointcut()")
    public Object logMethod(ProceedingJoinPoint joinPoint) throws Throwable {
        String methodName = joinPoint.getSignature().getName();
        String className = joinPoint.getSignature().getDeclaringTypeName();

        // Probably redundant as includeCallerData includes them
        MDC.put("method", methodName);
        MDC.put("class", className);

        // set earlier in filters/interceptors
        // String userId = MDC.get("userId");      
        // String username = MDC.get("username"); 

        long start = System.nanoTime();
        boolean success = false;

        log.debug("Method entry");

        try {
            Object result = joinPoint.proceed();
            success = true;

            log.debug("Method exit");
            return result;

        } catch (Exception ex) {
            recordFailureMetrics(className, methodName, ex.getClass().getSimpleName());
            log.error("Method exception: {}", ex.getMessage(), ex);
            throw ex;

        } finally {
            long duration = System.nanoTime() - start;
            long durationMs = duration / 1_000_000;

            recordExecutionMetrics(className, methodName, duration, success);

            if (durationMs > SLOW_METHOD_THRESHOLD_MS) {
                log.warn("Slow method detected ({} ms)", durationMs);
            }

            // Clean MDC (prevent leaks across threads in pools)
            MDC.remove("method");
            MDC.remove("class");
        }
    }

    private void recordExecutionMetrics(String className, String methodName,
                                        long duration, boolean success) {
        try {
            Timer.builder("app.method.execution.duration")
                    .description("Execution time of application methods")
                    .tags("class", className,
                          "method", methodName,
                          "success", Boolean.toString(success))
                    .register(meterRegistry)
                    .record(duration, TimeUnit.NANOSECONDS);

            Counter.builder("app.method.execution.count")
                    .description("Count of method executions")
                    .tags("class", className,
                          "method", methodName,
                          "success", Boolean.toString(success))
                    .register(meterRegistry)
                    .increment();
        } catch (Exception e) {
            log.warn("Failed to record execution metrics: {}", e.getMessage());
        }
    }

    private void recordFailureMetrics(String className, String methodName, String errorType) {
        try {
            Counter.builder("app.method.execution.errors")
                    .description("Count of method execution errors")
                    .tags("class", className,
                          "method", methodName,
                          "error_type", errorType)
                    .register(meterRegistry)
                    .increment();
        } catch (Exception e) {
            log.warn("Failed to record failure metrics: {}", e.getMessage());
        }
    }
}
