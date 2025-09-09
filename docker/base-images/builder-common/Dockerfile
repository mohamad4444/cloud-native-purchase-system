FROM maven:3.9.9-eclipse-temurin-21 AS builder-common
WORKDIR /app

# Copy from project root relative to build context
COPY poms/swtp-base-pom/pom.xml ./swtp-base-pom/
COPY libraries/common/pom.xml ./common/
COPY libraries/common/src ./common/src/
COPY poms/swtp-parent-pom/pom.xml ./swtp-parent-pom/

RUN mvn -f swtp-base-pom/pom.xml clean install -DskipTests 
RUN mvn -f common/pom.xml clean install -DskipTests 
RUN mvn -f swtp-parent-pom/pom.xml clean install -DskipTests