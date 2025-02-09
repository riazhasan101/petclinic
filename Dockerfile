#FROM openjdk:17-jdk-slim
#WORKDIR /app
#COPY /target/*.jar ./java.jar
#EXPOSE 8080
#CMD ["java", "-jar", "java.jar"]

# Stage 1: Build Stage (using Maven to build the app)
FROM maven:3.8.1-openjdk-17-slim AS build

# Set the working directory
WORKDIR /usr/src/

# Copy the source code into the container
COPY . .

# Run Maven to build the JAR file (skip tests)
RUN mvn clean install -DskipTests

# Stage 2: Runtime Stage (using OpenJDK JRE to run the app)
FROM openjdk:17-jdk-slim

# Set the working directory for the runtime image
WORKDIR /app

# Copy the built JAR file from the build stage to the runtime image
COPY --from=build /usr/src/target/*.jar ./java.jar

# Expose port 8080 for the app
EXPOSE 8080

# Command to run the JAR file
CMD ["java", "-jar", "java.jar"]
