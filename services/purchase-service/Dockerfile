# Use pre-built builder image with common dependencies
ARG REGISTRY=localhost:5000/
ARG JRE_VERSION=latest
FROM ${REGISTRY}builder-common:latest AS builder-base
# # ---------- BUILD STAGE ----------
# FROM maven:3.9.9-eclipse-temurin-21 AS builder

# # Copy pre-downloaded dependencies from builder-base to leverage cache
# COPY --from=builder-base /root/.m2/repository /root/.m2/repository

WORKDIR /app

# Copy this service's specific files
COPY pom.xml .
COPY src ./src

# Build only this service (dependencies are already cached)
RUN mvn clean package -DskipTests

# ---------- RUNTIME STAGE ----------
ARG JRE_VERSION
FROM eclipse-temurin:${JRE_VERSION}

WORKDIR /app

# Copy the built jar from the builder stage
COPY --from=builder-base /app/target/*.jar app.jar

EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]
