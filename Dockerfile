
# Stage 1: Build the JAR with Maven
FROM maven:3.9.4-eclipse-temurin-17 AS builder
WORKDIR /app

# Copy pom.xml and download dependencies
COPY pom.xml .
RUN mvn dependency:go-offline

# Copy project source and build
COPY src ./src
RUN mvn clean package -DskipTests
# Stage 2: Run the JAR
FROM eclipse-temurin:17-jdk

# Create a working directory
WORKDIR /app
COPY --from=builder /app/target/*.jar app.jar

# Expose the app port (change if needed)
EXPOSE 8080

# Run the app
ENTRYPOINT ["java", "-jar", "app.jar"]
