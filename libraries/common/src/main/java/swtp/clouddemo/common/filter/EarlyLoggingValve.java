package swtp.clouddemo.common.filter;

import jakarta.servlet.ServletException;
import org.apache.catalina.connector.Request;
import org.apache.catalina.connector.Response;
import org.apache.catalina.valves.ValveBase;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.boot.web.embedded.tomcat.TomcatServletWebServerFactory;
import org.springframework.boot.web.server.WebServerFactoryCustomizer;
import org.springframework.stereotype.Component;

import java.io.IOException;

/**
 * EarlyLoggingValve logs incoming HTTP requests and outgoing responses
 * at the Tomcat context level before Spring filters and controllers are invoked.
 *
 * <p>
 * This is useful for capturing raw request data early in the request lifecycle.
 */
@Component
public class EarlyLoggingValve extends ValveBase implements WebServerFactoryCustomizer<TomcatServletWebServerFactory> {

    private static final Logger log = LoggerFactory.getLogger(EarlyLoggingValve.class);

    /**
     * Called for each incoming request to log request and response information.
     *
     * @param request  Tomcat internal request object
     * @param response Tomcat internal response object
     * @throws IOException      if an I/O error occurs
     * @throws ServletException if a servlet error occurs
     */
    @Override
    public void invoke(Request request, Response response) throws IOException, ServletException {
        // Log request details before it reaches Spring
        log.info("EARLY TOMCAT Incoming Request: method={}, uri={}",
                request.getMethod(), request.getRequestURI());

        // Pass the request to the next valve in the chain (Spring, other filters)
        getNext().invoke(request, response);

        // Log response status after processing
        log.info("EARLY TOMCAT Outgoing Response: status={}", response.getStatus());
    }

    /**
     * Adds this valve to the Tomcat servlet context during server initialization.
     *
     * @param factory the TomcatServletWebServerFactory
     */
    @Override
    public void customize(TomcatServletWebServerFactory factory) {
        factory.addContextValves(this);
    }
}
