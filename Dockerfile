/*
FROM eclipse-temurin:21-jdk

WORKDIR /app

COPY . .

RUN ./mvnw clean package -DskipTests -Dcheckstyle.skip=true

EXPOSE 8080

CMD ["java", "-jar", "target/*.jar"]


*/
# ==========================================
# Stage 1: Build the Spring Boot application
# ==========================================
FROM maven:3.9-eclipse-temurin-21 AS builder

WORKDIR /app

# Copy Maven configuration first
# Helps Docker cache dependencies
COPY pom.xml .

# Download dependencies
RUN mvn dependency:go-offline -Dcheckstyle.skip=true

# Copy application source
COPY src ./src

# Run tests and build the JAR
RUN mvn clean package -Dcheckstyle.skip=true

# ==========================================
# Stage 2: Run the application
# ==========================================
FROM eclipse-temurin:21-jre

WORKDIR /app

# Copy the generated JAR from builder stage
COPY --from=builder /app/target/*.jar app.jar

# Spring Boot default port
EXPOSE 8080

# Start application
ENTRYPOINT ["java", "-jar", "app.jar"]
