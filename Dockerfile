FROM eclipse-temurin:21-jre

WORKDIR /app

COPY target/*.jar app.jar

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar"]
# Spring Boot default port
EXPOSE 8080

# Start application
ENTRYPOINT ["java", "-jar", "app.jar"]
