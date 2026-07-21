FROM eclipse-temurin:21-jdk

WORKDIR /app

COPY . .

RUN ./mvnw clean package -DskipTests -Dcheckstyle.skip=true

EXPOSE 8080

CMD ["java", "-jar", "target/*.jar"]
