#!/bin/bash

# Script to build Flutter app without NDK requirements
echo "Starting Flutter build with NDK workaround..."

# Clean the project first
flutter clean

# Get dependencies
flutter pub get

# Create a backup of the original build.gradle.kts
cp -f android/app/build.gradle.kts android/app/build.gradle.kts.bak

# Modify the build.gradle.kts to skip native builds
sed -i '' 's/ndkVersion = ".*"/\/\/ ndkVersion disabled/' android/app/build.gradle.kts

# Build the APK
flutter build apk --debug --no-tree-shake-icons

# Restore the original build.gradle.kts
cp -f android/app/build.gradle.kts.bak android/app/build.gradle.kts

echo "Build completed!"
