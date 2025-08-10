# ---------- BUILD STAGE ----------
FROM maven:3.9.9-eclipse-temurin-21 AS builder
WORKDIR /app


# Step 1: Build and install 'swtp-base-pom'
COPY swtp-base-pom/pom.xml swtp-base-pom/pom.xml
RUN mvn -f swtp-base-pom/pom.xml clean install -DskipTests

# Step 2: Build and install 'common'
COPY common/pom.xml common/pom.xml
COPY common/src common/src
RUN mvn -f common/pom.xml clean install -DskipTests

# Step 3: Build and install 'swtp-parent-pom'
COPY swtp-parent-pom/pom.xml swtp-parent-pom/pom.xml
RUN mvn -f swtp-parent-pom/pom.xml clean install -DskipTests


# Step 4: Build purchase-service (depends on common and swtp-base-pom)
COPY purchase-service/pom.xml purchase-service/pom.xml
COPY purchase-service/src purchase-service/src
RUN mvn -f purchase-service/pom.xml clean package -DskipTests

# ---------- RUNTIME STAGE ----------
FROM eclipse-temurin:21-jre
WORKDIR /app
COPY --from=builder /app/purchase-service/target/*.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]
