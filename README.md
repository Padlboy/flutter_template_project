# Flutter Template Repository

A beautifully organized Flutter project template with Docker Dev Container support for consistent team development and Android device testing.

## 📋 Features
- ✅ Complete Flutter project structure
- ✅ Docker dev container for reproducible environments
- ✅ Windows WSL2 compatible with USB device pass-through
- ✅ Pre-configured VS Code setup
- ✅ Android device testing support
- ✅ Multi-platform support (Android, iOS, Web, Windows, Linux, macOS)

---

## 🚀 Quick Start

### Prerequisites
- **Docker Desktop** (Windows/Mac) or Docker Engine (Linux)
- **VS Code** with Dev Containers extension
- Clone this repository

### Setup (5 minutes)
```bash
# 1. Clone the repo
git clone <your-repo-url>
cd flutter_template_repo

# 2. Open in VS Code
code .

# 3. Click "Reopen in Container" when prompted
# (Or: F1 → Dev Containers: Reopen in Container)

# 4. Wait for container to build (~2 min first time)

# 5. Connect your Android phone via USB

# 6. Verify setup
flutter doctor
flutter devices
```

### Running the App
```bash
flutter run
```

---

## 📁 Project Structure

```
.
├── .devcontainer/           # Docker dev environment
│   ├── devcontainer.json    # VS Code settings
│   ├── docker-compose.yml   # Container configuration
│   ├── Dockerfile           # Flutter image
│   └── README.md           # Detailed setup instructions
├── lib/                     # Dart/Flutter source code
│   ├── main.dart           # App entry point
│   ├── screens/            # UI screens
│   ├── models/             # Data models
│   ├── services/           # Business logic
│   └── widgets/            # Reusable UI components
├── test/                   # Unit & widget tests
├── android/                # Android configuration
├── ios/                    # iOS configuration
├── web/                    # Web configuration
├── pubspec.yaml            # Flutter dependencies
├── analysis_options.yaml   # Code quality settings
└── README.md              # This file
```

---

## 🛠️ Development

### Code Style & Quality
```bash
# Format code
dart format .

# Run analyzer
dart analyze

# Run tests
flutter test

# Fix common issues
dart fix --apply
```

### Building
```bash
# Debug build
flutter build apk

# Release build
flutter build apk --release

# Google Play distribution
flutter build appbundle --release
```

---

## 📱 Testing

Testing is performed on a **physical Android device** for accurate real-world behavior.

1. Connect your device via USB
2. Enable USB Debugging in Developer Options
3. Run: `flutter devices` to verify connection
4. Run: `flutter run` to deploy and test

### Unit Tests
```bash
flutter test
```

---

## 📚 Documentation

- **Setup Guide**: See [.devcontainer/README.md](.devcontainer/README.md)
- **Quick Reference**: See [QUICK_REFERENCE.md](QUICK_REFERENCE.md)
- **Setup Checklist**: See [SETUP_CHECKLIST.md](SETUP_CHECKLIST.md)
- **Flutter Docs**: https://flutter.dev/docs
- **Dart Docs**: https://dart.dev/guides

---

## 🤝 Team Collaboration

This project uses Docker Dev Containers to ensure all team members have identical development environments.

**Before committing:**
1. Format code: `dart format .`
2. Run analyzer: `dart analyze`
3. Run tests: `flutter test`
4. Verify build: `flutter build apk --debug`

---

## 🐛 Troubleshooting

**Device not appearing?**
- Check: `flutter doctor`
- Reconnect USB cable
- Enable USB Debugging on device
- See [.devcontainer/README.md](.devcontainer/README.md) for Windows USB fixes

**Build issues?**
- Clear cache: `flutter clean`
- Get dependencies: `flutter pub get`
- Rebuild container: Dev Containers: Rebuild Container

**Permission errors?**
- Ensure Docker Desktop has 4GB+ RAM allocated
- Restart Docker Desktop

---

## 📄 License

[Your License Here]

---

## ✨ Getting Started with Development

1. Read [QUICK_REFERENCE.md](QUICK_REFERENCE.md) for essential commands
2. Check [SETUP_CHECKLIST.md](SETUP_CHECKLIST.md) to verify everything works
3. Review [.devcontainer/README.md](.devcontainer/README.md) for detailed setup
4. Start exploring and building your Flutter app!

Happy coding! 🎉
