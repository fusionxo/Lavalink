# -------- Stage 1: Build Lavalink --------
FROM eclipse-temurin:17-jdk AS build

WORKDIR /app

# Copy everything (source + gradle files)
COPY . .

# Give gradlew execute permissions
RUN chmod +x ./gradlew

# Build Lavalink JAR without tests (skip daemon to save memory)
RUN ./gradlew build -x test --no-daemon

# -------- Stage 2: Run Lavalink --------
FROM eclipse-temurin:17-jre

WORKDIR /app

# Copy the built Lavalink JAR from the build stage
COPY --from=build /app/LavalinkServer/build/libs/Lavalink*.jar Lavalink.jar

# Copy the Lavalink config (can be overridden in Render via mount or env vars)
COPY application.yml .

# Expose the Lavalink port
EXPOSE 2333

# Start Lavalink with limited heap for free tier
CMD ["java", "-Xmx350m", "-jar", "Lavalink.jar"]
