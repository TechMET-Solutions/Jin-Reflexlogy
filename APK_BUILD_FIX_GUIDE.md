# APK Build Fix Guide

## Problem
Build failing with Kotlin cache errors and file locking issues.

## Solution

### Step 1: Clean Build Completely
```bash
flutter clean
cd android
./gradlew clean
cd ..
```

### Step 2: Delete Gradle Cache (Windows)
```bash
# Delete .gradle folder in android directory
Remove-Item -Recurse -Force android\.gradle

# Delete build folder
Remove-Item -Recurse -Force build

# Delete .dart_tool
Remove-Item -Recurse -Force .dart_tool
```

### Step 3: Build APK
```bash
flutter build apk --release --no-tree-shake-icons
```

## Alternative: Build APK Bundle (Recommended for Play Store)
```bash
flutter build appbundle --release
```

## If Still Failing

### Option 1: Restart Computer
Sometimes files are locked by background processes. Restart and try again.

### Option 2: Close All Programs
Close Android Studio, VS Code, and any other IDEs before building.

### Option 3: Build with Gradle Directly
```bash
cd android
./gradlew assembleRelease
```

## APK Location
After successful build, APK will be at:
```
build/app/outputs/flutter-apk/app-release.apk
```

## Common Issues

### Issue 1: NDK Version Mismatch
**Solution**: Already fixed in build.gradle.kts

### Issue 2: Keystore Error
**Solution**: Already fixed in key.properties

### Issue 3: File Locked
**Solution**: Close all programs and restart

### Issue 4: Out of Memory
**Solution**: Add to android/gradle.properties:
```
org.gradle.jvmargs=-Xmx4096m
```
