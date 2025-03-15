# Use an official OpenJDK runtime as a parent image
FROM openjdk:17-jdk-slim

# Set the working directory
WORKDIR /app

# Copy the built JAR file from the Maven target directory
COPY target/assignment2_bcd55-1.0-SNAPSHOT.jar app.jar

# Expose the application port (change if necessary)
EXPOSE 8080

# Run the application
CMD ["java", "-jar", "app.jar"]
