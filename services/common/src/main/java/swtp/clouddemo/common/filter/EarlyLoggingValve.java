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

@Component
public class EarlyLoggingValve extends ValveBase implements WebServerFactoryCustomizer<TomcatServletWebServerFactory> {

    private static final Logger log = LoggerFactory.getLogger(EarlyLoggingValve.class);

    @Override
    public void invoke(Request request, Response response) throws IOException, ServletException {
        log.info("EARLY TOMCAT Incoming Request: method={}, uri={}",
                request.getMethod(), request.getRequestURI());

        getNext().invoke(request, response);

        // Optionally log response status here, but beware Tomcat internals
        log.info("EARLY TOMCAT Outgoing Response: status={}", response.getStatus());
    }

    @Override
    public void customize(TomcatServletWebServerFactory factory) {
        factory.addContextValves(this);
    }
}
