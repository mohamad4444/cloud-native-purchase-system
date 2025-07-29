package swtp.clouddemo.inventory.aspects;

import lombok.extern.log4j.Log4j2;
import lombok.extern.slf4j.Slf4j;
import org.aspectj.lang.*;
import org.aspectj.lang.annotation.*;
import org.aspectj.lang.reflect.MethodSignature;
import org.springframework.stereotype.Component;

import java.util.Arrays;

@Log4j2
@Aspect
@Component
public class LoggingAspect {

    @Pointcut("execution(* swtp.clouddemo..service..*(..)) || execution(* swtp.clouddemo..controller..*(..))")
    public void applicationPackagePointcut() {
        // matches service and controller packages
    }

    @Before("applicationPackagePointcut()")
    public void logMethodEntry(JoinPoint joinPoint) {
        String methodName = joinPoint.getSignature().toShortString();
        Object[] args = joinPoint.getArgs();
        log.info("→ Entering: {} with args {}", methodName, Arrays.toString(args));
    }

    @AfterReturning(pointcut = "applicationPackagePointcut()", returning = "result")
    public void logMethodExit(JoinPoint joinPoint, Object result) {
        String methodName = joinPoint.getSignature().toShortString();
        log.info("← Exiting: {} with result {}", methodName, result);
    }

    @AfterThrowing(pointcut = "applicationPackagePointcut()", throwing = "ex")
    public void logException(JoinPoint joinPoint, Throwable ex) {
        String methodName = joinPoint.getSignature().toShortString();
        log.error("‼ Exception in {}: {}", methodName, ex.getMessage(), ex);
    }
    @Around("applicationPackagePointcut()")
    public Object logExecutionTime(ProceedingJoinPoint joinPoint) throws Throwable {
        long start = System.currentTimeMillis();
        Object result = joinPoint.proceed();
        long duration = System.currentTimeMillis() - start;
        String methodName = joinPoint.getSignature().toShortString();
        log.info("⏱ Executed {} in {} ms", methodName, duration);
        return result;
    }

}
