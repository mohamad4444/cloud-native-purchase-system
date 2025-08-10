# ---------- BUILD STAGE ----------
FROM maven:3.9.9-eclipse-temurin-21 AS builder
WORKDIR /app

# Copy Maven descriptors for caching
COPY swtp-parent-pom/pom.xml swtp-parent-pom/
COPY swtp-base-pom/pom.xml swtp-base-pom/
COPY common/pom.xml common/
COPY purchase-service/pom.xml purchase-service/
COPY pom.xml .

# Pre-download dependencies
RUN mvn dependency:go-offline

# Copy all source code
COPY swtp-parent-pom/ swtp-parent-pom/
COPY swtp-base-pom/ swtp-base-pom/
COPY common/ common/
COPY purchase-service/ purchase-service/

# Build only purchase-service (and its deps)
RUN mvn -pl purchase-service -am clean package -DskipTests

# ---------- RUNTIME STAGE ----------
FROM eclipse-temurin:21-jre
WORKDIR /app
COPY --from=builder /app/purchase-service/target/*.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]
