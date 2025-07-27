//package swtp.clouddemo.purchase.config;
//
//import org.springframework.beans.factory.annotation.Value;
//import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
//import org.springframework.context.annotation.Bean;
//import org.springframework.context.annotation.Configuration;
//import org.springframework.boot.jdbc.DataSourceBuilder;
//
//import javax.sql.DataSource;
//
//@Configuration
//public class DevDataSourceConfig {
//
//    @Value("${spring.datasource.url}")
//    private String pgUrl;
//    @Value("${spring.datasource.username}")
//    private String pgUser;
//    @Value("${spring.datasource.password}")
//    private String pgPass;
//
//    @Value("${spring.datasource.h2.url}")
//    private String h2Url;
//    @Value("${spring.datasource.h2.username}")
//    private String h2User;
//    @Value("${spring.datasource.h2.password}")
//    private String h2Pass;
//
//    @Bean
//    @ConditionalOnProperty(name = "app.dev.db", havingValue = "postgres")
//    public DataSource postgresDataSource() {
//        return DataSourceBuilder.create()
//                .url(pgUrl)
//                .username(pgUser)
//                .password(pgPass)
//                .driverClassName("org.postgresql.Driver")
//                .build();
//    }
//
//    @Bean
//    @ConditionalOnProperty(name = "app.dev.db", havingValue = "h2")
//    public DataSource h2DataSource() {
//        return DataSourceBuilder.create()
//                .url(h2Url)
//                .username(h2User)
//                .password(h2Pass)
//                .driverClassName("org.h2.Driver")
//                .build();
//    }
//}
