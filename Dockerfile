# Use a base image with Java 17 (or whichever version your project is using)
FROM openjdk:17-jdk-slim

# Set the working directory in the container
WORKDIR /app

# Copy the JAR file from your target folder to the container
COPY target/*.jar /app/app.jar

# Expose the port the app will run on (default for Spring Boot is 8080)
EXPOSE 8081

# Command to run the JAR file
ENTRYPOINT ["java", "-jar", "app.jar"]

