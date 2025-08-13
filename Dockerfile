# -------- Stage 1: Build Lavalink --------
FROM eclipse-temurin:17-jdk AS build

WORKDIR /app

# Copy everything (source + gradle files)
COPY . .

# Give gradlew execute permissions
RUN chmod +x ./gradlew

# Build Lavalink JAR without tests
RUN ./gradlew build -x test --no-daemon

# -------- Stage 2: Run Lavalink --------
FROM eclipse-temurin:17-jre

WORKDIR /app

# Copy the built JAR from build stage
COPY --from=build /app/LavalinkServer/build/libs/Lavalink*.jar Lavalink.jar
COPY application.yml .

EXPOSE 2333

CMD ["java", "-Xmx350m", "-jar", "Lavalink.jar"]
