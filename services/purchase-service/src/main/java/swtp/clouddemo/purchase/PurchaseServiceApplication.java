package swtp.clouddemo.purchase;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Import;
import org.springframework.jms.annotation.EnableJms;
import swtp.clouddemo.common.config.CommonConfig;

//@SpringBootApplication(scanBasePackages = {
//		"swtp.clouddemo.purchase",
//		"swtp.clouddemo.common.config"
//})
@SpringBootApplication
@Import({CommonConfig.class})
@EnableJms
public class PurchaseServiceApplication {

	public static void main(String[] args) {
		SpringApplication.run(PurchaseServiceApplication.class, args);
	}

}
