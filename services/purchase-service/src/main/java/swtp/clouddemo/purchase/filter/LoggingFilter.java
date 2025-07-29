package swtp.clouddemo.purchase.filter;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import lombok.extern.slf4j.Slf4j;
import org.apache.logging.log4j.core.config.Order;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;

import java.io.IOException;

@Slf4j
public class LoggingFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;

        log.info("Incoming Request: method={}, uri={}, params={}",
                req.getMethod(), req.getRequestURI(), req.getQueryString());

        chain.doFilter(request, response);

        log.info("Outgoing Response: status={}", res.getStatus());
    }
}
