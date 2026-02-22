# 🚀 Setup Checklist - Flutter Template Repository

Use this checklist to ensure your development environment is properly configured.

## Pre-Setup (System Level)

- [ ] **Docker Desktop installed** (v4.0+)
  - Download: https://www.docker.com/products/docker-desktop
  - Windows: Ensure WSL 2 backend is selected
  
- [ ] **Git installed**
  - Windows: https://git-scm.com/download/win
  
- [ ] **VS Code installed**
  - Download: https://code.visualstudio.com/
  
- [ ] **Dev Containers extension installed** in VS Code
  - Install from Extensions: `Dev Containers` by Microsoft
  
- [ ] **Flutter/Dart extension in VS Code**
  - Install from Extensions: `Dart Code` by Dart Code

---

## Initial Setup

- [ ] **Clone repository**
  ```bash
  git clone <your-repo-url>
  cd flutter_template_repo
  ```

- [ ] **Open in VS Code**
  ```bash
  code .
  ```

- [ ] **Reopen in Dev Container**
  - Click prompt: "Reopen in Container"
  - Or press `F1` → "Dev Containers: Reopen in Container"

- [ ] **Wait for container build** (first time only)
  - Should complete in ~2 minutes
  - Watch terminal for progress

- [ ] **Verify Flutter installation**
  ```bash
  flutter doctor
  ```
  All items should show ✓ or ✓ (with some caveats)

---

## Android Device Setup (Physical Phone)

- [ ] **Enable Developer Options on Android**
  1. Settings → About Phone
  2. Tap "Build Number" 7 times
  3. Developer Options now appears in Settings

- [ ] **Enable USB Debugging**
  1. Settings → Developer Options
  2. Toggle "USB Debugging" ON

- [ ] **Connect phone via USB**
  - Use a quality USB cable
  - Select "Transfer files" or "File transfers" when prompted on device

- [ ] **Trust computer**
  - Tap "Allow" or "Trust" when prompted on device

- [ ] **Verify device connection**
  ```bash
  flutter devices
  ```
  Your phone should appear in the list

---

## Verify Complete Setup

- [ ] **Check all tools are ready**
  ```bash
  flutter doctor -v
  ```
  
- [ ] **Verify device connection**
  ```bash
  flutter devices
  ```
  Should show your Android phone

- [ ] **Create a simple test**
  ```bash
  flutter run
  ```
  App should install and run on your device

- [ ] **Verify hot reload works**
  - App is running on device
  - In terminal, press `r` to trigger hot reload
  - Should rebuild without reinstalling

---

## Daily Development

- [ ] **Morning startup**
  1. Open VS Code
  2. Container should reconnect automatically
  3. Connect Android phone via USB
  4. `flutter devices` to verify
  5. `flutter run` to start development

- [ ] **Commit workflow**
  ```bash
  dart format .
  dart analyze
  flutter test
  git add .
  git commit -m "Your message"
  ```

- [ ] **Before pushing to repo**
  ```bash
  flutter build apk --debug  # Verify build passes
  ```

---

## Troubleshooting Checklist

### Container won't start?
- [ ] Docker Desktop is running
- [ ] Enough disk space (5GB+)
- [ ] WSL 2 backend enabled on Windows
- [ ] Try: `Dev Containers: Rebuild Container`

### Device not showing in `flutter devices`?
- [ ] USB cable is connected and working
- [ ] USB Debugging enabled on device
- [ ] Device appears in file explorer
- [ ] Run: `flutter clean && flutter pub get`
- [ ] Try: Disconnect and reconnect USB cable

### Build fails?
- [ ] Run `flutter clean`
- [ ] Run `flutter pub get`
- [ ] Run `flutter doctor` to check for issues
- [ ] Check container has 4GB+ RAM allocated

### Hot reload not working?
- [ ] Quit app and restart: `flutter run`
- [ ] Rebuild container if Flutter version changed
- [ ] Try: `flutter clean && flutter run`

---

## Getting Help

1. **Check documentation**: [.devcontainer/README.md](.devcontainer/README.md)
2. **Flutter troubleshooting**: https://flutter.dev/docs/get-started/faq
3. **Check container logs**: Docker Desktop → Logs tab
4. **Google/Stack Overflow**: Include `flutter doctor -v` output

---

## Success Indicators ✨

Your setup is complete when:
- ✅ `flutter doctor` shows all tools with checkmarks
- ✅ `flutter devices` shows your Android phone
- ✅ `flutter run` successfully installs app on device
- ✅ Pressing `r` in terminal triggers hot reload
- ✅ `flutter test` runs without errors

---

**Last Updated**: February 22, 2026  
**Project**: Flutter Template Repository  
**Status**: Setup Ready for Development
