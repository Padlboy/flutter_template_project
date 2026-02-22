# 📖 Quick Reference Guide - Flutter Template Repository

## 🎯 One-Minute Setup
```bash
# 1. Open folder in VS Code
code .

# 2. Click "Reopen in Container" (appears automatically)
# Wait ~2 min on first setup

# 3. Connect Android phone via USB

# 4. Run app
flutter run
```

---

## ⚡ Essential Commands

### Development
| Command | Purpose |
|---------|---------|
| `flutter run` | Run app on connected device |
| `flutter run -v` | Run with verbose output (debugging) |
| `flutter run --release` | Run optimized release build |
| `flutter run -d chrome` | Run on web browser |

### Code Quality
| Command | Purpose |
|---------|---------|
| `dart format .` | Auto-format all Dart code |
| `dart analyze` | Check for code issues |
| `dart fix --apply` | Auto-fix common issues |
| `flutter test` | Run unit/widget tests |

### Maintenance
| Command | Purpose |
|---------|---------|
| `flutter clean` | Clean build artifacts |
| `flutter pub get` | Install/update dependencies |
| `flutter doctor` | Check environment setup |
| `flutter devices` | List connected devices |

### Building
| Command | Purpose |
|---------|---------|
| `flutter build apk` | Build Android APK (debug) |
| `flutter build apk --release` | Build Android APK (release) |
| `flutter build appbundle` | Build Google Play bundle |
| `flutter build web` | Build web version |

---

## 🔄 Daily Workflow

```bash
# Morning: Start work
1. Open VS Code (container auto-connects)
2. Connect Android phone via USB
3. flutter devices          # Verify phone is listed
4. flutter run              # Start development

# During work:
# Press 'r' to hot reload
# Press 'R' for full restart
# Press 'd' for devtools

# Before committing:
5. dart format .
6. dart analyze
7. flutter test
8. git add / commit
```

---

## 📁 Project Files

| File/Folder | Purpose |
|------------|---------|
| `lib/main.dart` | App entry point |
| `lib/router.dart` | go_router navigation |
| `lib/supabase_config.dart` | Supabase credentials (use --dart-define) |
| `lib/features/` | Feature screens and notifiers |
| `lib/models/` | Data models |
| `lib/repositories/` | Data access / Supabase calls |
| `lib/widgets/` | Reusable widgets |
| `lib/design/` | Colors, spacing, theme |
| `test/` | Unit & widget tests |
| `pubspec.yaml` | Dependencies & config |
| `.devcontainer/` | Docker setup |
| `.github/agents/` | AI agent definitions |
| `.github/skills/` | Reusable agent skills |

---

## 🆘 Quick Troubleshooting

**Phone not showing in `flutter devices`?**
```bash
flutter clean
adb devices  # Check USB connection
# Disconnect and reconnect USB cable
flutter devices
```

**Build fails?**
```bash
flutter clean
flutter pub get
flutter build apk --debug
```

**Container won't start?**
- Ensure Docker Desktop is running
- Try: `Dev Containers: Rebuild Container`

**Need to check everything?**
```bash
flutter doctor -v
```

---

## 📚 Full Documentation

- **Setup Details**: [.devcontainer/README.md](.devcontainer/README.md)
- **Setup Checklist**: [SETUP_CHECKLIST.md](SETUP_CHECKLIST.md)
- **Project Info**: [README.md](README.md)
- **Flutter Guide**: https://flutter.dev/docs

---

## 💡 Pro Tips

✨ **Enable "Format on Save"** in VS Code for automatic code formatting
- Settings → "Format on Save" → Enable

✨ **Use keyboard shortcuts**
- `Cmd/Ctrl + Shift + D` = Open DevTools
- `r` = Hot reload (in running app)
- `R` = Full restart

✨ **Create feature branches** for organization
```bash
git checkout -b feature/add-new-feature
```

✨ **Commit frequently** with descriptive messages
```bash
git commit -m "feat: Add new feature description"
```

---

## ❓ Need Help?

1. Check the [Setup Checklist](SETUP_CHECKLIST.md)
2. Read [.devcontainer/README.md](.devcontainer/README.md) for detailed docs
3. Run `flutter doctor -v` to diagnose issues
4. Search Flutter docs: https://flutter.dev/docs
5. Check [Dart documentation](https://dart.dev/guides)

---

**Last Updated**: February 22, 2026  
**Status**: ✅ Ready for Development
