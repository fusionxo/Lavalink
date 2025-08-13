# -------- Stage 1: Build Lavalink --------
FROM eclipse-temurin:17-jdk AS build

WORKDIR /app

# Copy Gradle files first (better caching)
COPY build.gradle.kts settings.gradle.kts gradlew gradlew.bat ./
COPY gradle ./gradle

# Give gradlew execute permission
RUN chmod +x ./gradlew

# Download dependencies
RUN ./gradlew --no-daemon dependencies

# Copy the rest of the source
COPY . .

# Build Lavalink JAR without running tests
RUN ./gradlew build -x test --no-daemon

# -------- Stage 2: Run Lavalink --------
FROM eclipse-temurin:17-jre

WORKDIR /app

# Copy the built JAR from the build stage
COPY --from=build /app/LavalinkServer/build/libs/Lavalink*.jar Lavalink.jar
COPY application.yml .

EXPOSE 2333

CMD ["java", "-Xmx350m", "-jar", "Lavalink.jar"]
