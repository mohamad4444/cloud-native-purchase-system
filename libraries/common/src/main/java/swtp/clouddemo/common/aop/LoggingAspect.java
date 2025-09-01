package swtp.clouddemo.common.aop;

import io.micrometer.core.instrument.MeterRegistry;
import io.micrometer.core.instrument.Timer;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Pointcut;
import org.springframework.stereotype.Component;
import org.slf4j.MDC;

import java.util.Arrays;
import java.util.concurrent.TimeUnit;

/**
 * LoggingAspect provides a central AOP-based logging and metrics mechanism.
 *
 * Features:
 *  - Logs method entry with parameters
 *  - Logs method exit with result
 *  - Logs exceptions
 *  - Records execution time in Micrometer with detailed tags
 *  - Includes MDC context (userId, username) in logs and metrics
 */
@Slf4j
@Aspect
@Component
@RequiredArgsConstructor
public class LoggingAspect {

    private final MeterRegistry meterRegistry;

    /**
     * Pointcut matching all methods in service, controller, and repository packages.
     *
     * Usage: applied in @Around advice to wrap method execution.
     */
    @Pointcut("within(swtp.clouddemo..service..*) || " +
            "within(swtp.clouddemo..controller..*) || " +
            "within(swtp.clouddemo..repository..*)")
    public void applicationPackagePointcut() {}

    /**
     * Around advice that wraps method execution.
     *
     * Responsibilities:
     *  - Logs method entry and parameters
     *  - Executes the actual method via joinPoint.proceed()
     *  - Logs method exit and result
     *  - Logs exceptions if thrown
     *  - Records execution time in Micrometer with tags:
     *      class, method, userId, username
     *
     * @param joinPoint the method being intercepted
     * @return the result of the target method
     * @throws Throwable if the target method throws an exception
     */
    @Around("applicationPackagePointcut()")
    public Object logMethod(ProceedingJoinPoint joinPoint) throws Throwable {
        // Extract method signature and class
        String method = joinPoint.getSignature().toShortString();
        String className = joinPoint.getSignature().getDeclaringTypeName();
        Object[] args = joinPoint.getArgs();

        // Extract user context from MDC
        String userId = MDC.get("userId");
        String username = MDC.get("username");

        // Log method entry with parameters and user context
        log.info("Entering {} with args {} | userId={} username={}",
                method, Arrays.toString(args),
                userId != null ? userId : "anonymous",
                username != null ? username : "anonymous");

        long start = System.nanoTime();
        try {
            // Execute the target method
            Object result = joinPoint.proceed();

            // Log method exit with result and user context
            log.info("Exiting {} with result {} | userId={} username={}",
                    method, result,
                    userId != null ? userId : "anonymous",
                    username != null ? username : "anonymous");

            return result;
        } catch (Throwable ex) {
            // Log any exception thrown during method execution
            log.error("Exception in {} | userId={} username={} : {}",
                    method,
                    userId != null ? userId : "anonymous",
                    username != null ? username : "anonymous",
                    ex.getMessage(), ex);
            throw ex;
        } finally {
            // Compute execution duration
            long duration = System.nanoTime() - start;

            // Record metrics in Micrometer with tags for filtering
            Timer.builder("app.method.execution")
                    .description("Execution time of application methods")
                    .tags("class", className,
                            "method", method,
                            "userId", userId != null ? userId : "anonymous",
                            "username", username != null ? username : "anonymous")
                    .register(meterRegistry)
                    .record(duration, TimeUnit.NANOSECONDS);

            // Optional: log execution time separately
            log.info("Executed {} in {} ms | userId={} username={}",
                    method, duration / 1_000_000,
                    userId != null ? userId : "anonymous",
                    username != null ? username : "anonymous");
        }
    }
}
