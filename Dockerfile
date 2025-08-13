# Use Java 17 base image
FROM eclipse-temurin:17-jdk

# Set working directory
WORKDIR /app

# Copy source files
COPY . .

# Build Lavalink
RUN ./gradlew build -x test

# Expose the port Render assigns
EXPOSE 2333

# Start Lavalink
CMD ["java", "-Xmx350m", "-jar", "Lavalink.jar"]
