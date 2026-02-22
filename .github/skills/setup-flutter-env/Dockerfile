FROM ghcr.io/cirruslabs/flutter:latest

# Install additional development tools not present in the base image
# (git and curl are already included in the Cirrus Flutter base)
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    wget \
    zip \
    unzip \
    openssh-client \
    && rm -rf /var/lib/apt/lists/*

# Use prebuilt Dart SDK bundled with Flutter (faster, no separate download)
ENV FLUTTER_PREBUILT_DART_SDK=true

# Configure git to trust the pre-installed Flutter SDK directory and disable analytics
# Do NOT run `flutter channel stable` here — the base image ships on stable already
# and doing a channel switch triggers a slow git fetch that can fail in offline builds.
RUN git config --global --add safe.directory /sdks/flutter && \
    flutter config --no-analytics

WORKDIR /workspace
