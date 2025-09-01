FROM maven:3.9.9-eclipse-temurin-21 AS builder-common
WORKDIR /app
COPY swtp-base-pom/pom.xml swtp-base-pom/pom.xml
RUN mvn -f swtp-base-pom/pom.xml clean install -DskipTests
COPY common/pom.xml common/pom.xml
COPY common/src common/src
RUN mvn -f common/pom.xml clean install -DskipTests
COPY swtp-parent-pom/pom.xml swtp-parent-pom/pom.xml
RUN mvn -f swtp-parent-pom/pom.xml clean install -DskipTests
