# Dev Container Setup - Flutter Template Repository

This project uses **Docker Dev Containers** to provide a reproducible Flutter development environment for the team.

## Prerequisites

### Windows
- **Docker Desktop** (version 4.0+)
- **WSL 2** backend enabled in Docker Desktop
- **Git**
- **VS Code** with "Dev Containers" extension

### Quick Prerequisites Check
```powershell
docker --version
wsl --version
code --version
```

---

## Getting Started (5 minutes)

### 1. Clone the Repository
```bash
git clone <your-repo-url>
cd flutter_template_repo
```

### 2. Open in VS Code
```bash
code .
```

### 3. Open in Dev Container
When you open the folder, VS Code will prompt:
> "Folder contains a Dev Container configuration file. Reopen folder to develop in a container?"

Click **"Reopen in Container"** or:
- Press `F1` and run: `Dev Containers: Reopen in Container`

### 4. Wait for Container to Build
- First time: ~2 minutes (downloads base image, builds Flutter)
- Subsequent times: ~10 seconds (cached)

### 5. Connect Your Android Phone
- Enable Developer Mode: Settings → About Phone → tap Build Number 7 times
- Enable USB Debugging: Developer Options → USB Debugging
- Connect via USB cable
- Trust the computer when prompted

### 6. Verify Setup
In the VS Code terminal (inside container):
```bash
flutter doctor
flutter devices
```

You should see your physical device listed!

---

## Windows-Specific: USB Device Passthrough

### Configure Docker Desktop for USB Passthrough

1. **Open Docker Desktop Settings**
   - Click Docker icon → Settings

2. **Enable Resources**
   - Resources → WSL Integration
   - Ensure "Windows Subsystem for Linux" is toggled ON

3. **Enable USB Support** (if not automatic)
   - In Docker Desktop, go to Settings → Resources → WSL Integration
   - Restart Docker Desktop if you make changes

4. **Restart Docker Desktop**
   - Right-click Docker icon → Quit Docker Desktop
   - Wait 10 seconds, then launch it again

### Troubleshooting USB Connection

**Device not appearing in `flutter devices`?**

```bash
# Inside container, check if device is visible
adb devices

# Reconnect the device
adb disconnect
adb connect 192.168.1.X:5555  # Use device IP if USB fails

# Check device ID
adb shell getprop ro.serialno
```

**On Windows Host Machine, verify:**
```powershell
# In PowerShell (NOT in container)
adb devices

# If device shows but not in container, try:
docker exec -it flutter-template-dev adb devices
```

---

## Daily Development Workflow

### Starting Development
```bash
# Terminal opens in container automatically
# Simply start coding!

# To run the app:
flutter run

# For hot reload in the running app:
# Press 'r' in terminal or use VS Code: Debug → Restart
```

### Building & Testing
```bash
# Run tests
flutter test

# Build APK for Android
flutter build apk --release

# Build AAB (Google Play)
flutter build appbundle --release

# Analyze code
dart analyze
```

### Code Formatting & Fixing
```bash
# Format all Dart files
dart format .

# Fix common issues
dart fix --apply

# Analyze code quality
dart analyze
```

---

## Useful VS Code Commands (Inside Container)

| Command | Shortcut |
|---------|----------|
| Run app | `flutter run` |
| Run app (release) | `flutter run --release` |
| Run tests | `flutter test` |
| Hot reload | `r` (in running app) |
| Hot restart | `R` (in running app) |
| Debug mode | `d` (in running app) |
| Dart DevTools | `flutter pub global run devtools` |

---

## Project Structure

```
flutter_template_repo/
├── .devcontainer/          # Dev container configuration
│   ├── devcontainer.json   # VS Code settings
│   ├── docker-compose.yml  # Container setup with USB
│   ├── Dockerfile          # Flutter environment image
│   └── README.md          # This file
├── lib/                    # Dart/Flutter code
│   └── main.dart          # App entry point
├── test/                  # Unit & widget tests
├── android/               # Android-specific code
├── ios/                   # iOS-specific code
├── web/                   # Web-specific code
├── pubspec.yaml           # Dependencies
└── README.md             # Main project docs
```

---

## Team Collaboration Best Practices

### Before Committing Code
```bash
# Format your code
dart format .

# Run analyzer
dart analyze

# Run tests
flutter test

# Build to verify everything works
flutter build apk --debug
```

### Branch Workflow
1. Create feature branch: `git checkout -b feature/your-feature`
2. Make changes inside container
3. Test thoroughly
4. Commit with clear messages
5. Push and create PR

### Keeping Container Updated
```bash
# Rebuild container if Dockerfile or docker-compose.yml changed
# In VS Code: Dev Containers: Rebuild Container
# Or from command line:
dev container rebuild
```

---

## Troubleshooting

### Container Won't Start
```bash
# Rebuild from scratch
docker-compose down
docker-compose build --no-cache
```

### USB Device Disconnects
```bash
# Reconnect without restarting container
adb disconnect
adb devices
```

### Pub cache issues
```bash
# Clear pub cache
flutter clean
flutter pub get
```

### Permission Denied Errors
```bash
# The container should handle permissions automatically
# If issues persist, ensure Docker Desktop is running with sufficient resources:
# Docker Desktop → Settings → Resources → Memory: at least 4GB
```

---

## Useful Resources

- [Flutter Documentation](https://flutter.dev/docs)
- [Docker Dev Containers](https://containers.dev/)
- [VS Code Remote Containers](https://code.visualstudio.com/docs/remote/containers)
- [Android Debug Bridge (adb)](https://developer.android.com/studio/command-line/adb)

---

## Need Help?

- Check `flutter doctor` for environment issues
- Run `flutter run -v` for verbose debugging info
- Check Docker Desktop logs for container issues
- Restart Docker Desktop if anything seems stuck

Happy coding! 🚀
