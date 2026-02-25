ARG MAVEN_VERSION=latest
FROM maven:${MAVEN_VERSION} AS builder-common
WORKDIR /app

# Copy from project root relative to build context
COPY services/poms/swtp-base-pom/pom.xml ./swtp-base-pom/
COPY services/common/pom.xml ./common/
COPY services/common/src ./common/src/
COPY services/poms/swtp-parent-pom/pom.xml ./swtp-parent-pom/

RUN mvn -f swtp-base-pom/pom.xml clean install -DskipTests 
RUN mvn -f common/pom.xml clean install -DskipTests 
RUN mvn -f swtp-parent-pom/pom.xml clean install -DskipTests