# Use the official Dart image
FROM dart:stable AS build

# Set working directory
WORKDIR /app

# Copy the pubspec files
COPY pubspec.* ./

# Get dependencies
RUN dart pub get

# Copy the rest of the application
COPY . .

# Resolve dependencies again to ensure everything is available
RUN dart pub get

# Compile the Dart code to a binary (makes it super fast)
RUN dart compile exe server.dart -o server

# --- Minimal Runtime Image ---
# We need a minimal Alpine image (not scratch) for the compiled executable
FROM alpine:latest
RUN apk add --no-cache libc6-compat
COPY --from=build /app/server /app/bin/server

# Open port 8080
EXPOSE 8080

# Run the binary
CMD ["/app/bin/server"]