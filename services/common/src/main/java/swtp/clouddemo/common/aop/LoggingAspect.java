package swtp.clouddemo.common.aop;

import io.micrometer.core.instrument.MeterRegistry;
import io.micrometer.core.instrument.Timer;
import lombok.RequiredArgsConstructor;
import org.aspectj.lang.JoinPoint;
import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.*;
import org.springframework.stereotype.Component;
import lombok.extern.slf4j.Slf4j;
import java.util.Arrays;
import java.util.concurrent.TimeUnit;

@Slf4j
@Aspect
@Component
@RequiredArgsConstructor
public class LoggingAspect {

    private final MeterRegistry meterRegistry;


    @Pointcut("execution(* swtp.clouddemo..service..*(..)) " +
            "|| execution(* swtp.clouddemo..controller..*(..)) " +
            "|| execution(* swtp.clouddemo..repository..*(..))")
    public void applicationPackagePointcut() {
        // matches service, controller, and repository packages
    }


    @Before("applicationPackagePointcut()")
    public void logMethodEntry(JoinPoint joinPoint) {
        String methodName = joinPoint.getSignature().toShortString();
        Object[] args = joinPoint.getArgs();
        log.info("Entering: {} with args {}", methodName, Arrays.toString(args));
    }

    @AfterReturning(pointcut = "applicationPackagePointcut()", returning = "result")
    public void logMethodExit(JoinPoint joinPoint, Object result) {
        String methodName = joinPoint.getSignature().toShortString();
        log.info("Exiting: {} with result {}", methodName, result);
    }

    @AfterThrowing(pointcut = "applicationPackagePointcut()", throwing = "ex")
    public void logException(JoinPoint joinPoint, Throwable ex) {
        String methodName = joinPoint.getSignature().toShortString();
        log.error("Exception in {}: {}", methodName, ex.getMessage(), ex);
    }
    @Around("applicationPackagePointcut()")
    public Object logExecutionTime(ProceedingJoinPoint joinPoint) throws Throwable {
        long start = System.currentTimeMillis();
        Object result = joinPoint.proceed();
        long duration = System.currentTimeMillis() - start;
        String methodName = joinPoint.getSignature().toShortString();
        log.info("Executed {} in {} ms", methodName, duration);
        return result;
    }

    @Around("execution(* swtp.clouddemo..*.*(..))")
    public Object logAndTime(ProceedingJoinPoint joinPoint) throws Throwable {
        String method = joinPoint.getSignature().toShortString();
        long start = System.nanoTime();
        log.debug("Enter: {}", method);

        try {
            Object result = joinPoint.proceed();
            log.debug("Exit : {}", method);
            return result;
        } catch (Throwable ex) {
            log.error("Error in {}: {}", method, ex.getMessage(), ex);
            throw ex;
        } finally {
            long duration = System.nanoTime() - start;
            Timer.builder("method.execution")
                    .description("Execution time of service methods")
                    .tag("method", method)
                    .register(meterRegistry)
                    .record(duration, TimeUnit.NANOSECONDS);
        }
    }
}
