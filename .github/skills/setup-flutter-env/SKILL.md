---
name: setup-flutter-env
description: "Intelligent Flutter environment setup. Agent asks critical questions about development preferences (dev container vs local, emulator vs physical device), evaluates compatibility, presents pros/cons, and guides developers through setup."
---

# Intelligent Flutter Environment Setup

This skill guides you through setting up a Flutter development environment with **critical thinking** about trade-offs and compatibility. The agent will ask key questions, evaluate options, and help you choose the best setup for your needs.

---

## Phase 1: Pre-Setup Discovery & Analysis

### Step 1: Understand Your Preferences

The agent will ask you these questions:

**Q1: Development Environment Preference**
> "Do you prefer a **dev container** (isolated, reproducible, containerized) or a **local setup** (direct system installation)?"

**Options:**
- 🐳 **Dev Container** - Docker-based, isolated, reproducible, better team collaboration
- 💻 **Local Setup** - Direct installation, potentially faster for single developer

---

**Q2: Testing Platform**
> "How will you test your Flutter app?"

**Options:**
- ✱ **Emulator/Simulator** - Virtual device, great for testing, no hardware needed
  - Follow-up: Android or iOS?
- 📱 **Physical Device** - Real hardware, better for performance testing, requires device
  - Follow-up: Android or iOS?
- 🌐 **Web** - Browser-based testing (fastest iteration, limited mobile features)
- 🖥️ **Desktop** - macOS/Windows/Linux (platform-specific)

---

**Q3: Specific Constraints**
> "Any specific constraints I should know about?"

- Team collaboration needs?
- CI/CD pipeline requirements?
- Performance limitations?
- Multiple project management?
- Specific OS versions needed?

---

## Phase 2: Critical Analysis & Compatibility Assessment

Based on your answers, the agent will:

### 1. Analyze Compatibility

The agent will **search the internet** for relevant information if uncommon combinations are requested, such as:
- Emulator + Dev Container compatibility
- iOS simulator in dev container
- Android emulator in dev container
- Physical device debugging in dev container

### 2. Identify Challenges & Constraints

Common concerns:
- **Dev Container + Android Emulator**: May have GPU/display limitations
- **Dev Container + iOS Simulator**: macOS-only, containerization challenges
- **Dev Container + Physical Phone**: USB pass-through issues
- **Web + Dev Container**: Network configuration needed

### 3. Present Pros & Cons Matrix

For each viable approach:

#### ✅ Option 1: Local Setup + Physical Phone (Android/iOS)
**Pros:**
- No extra tooling complexity
- Full USB debugging support
- Excellent development experience
- Hot reload works perfectly
- Good for realistic testing

**Cons:**
- Need physical device hardware
- Manual driver installation
- Device must stay connected
- Limited to one device at a time
- Team needs same devices

---

#### ✅ Option 2: Local Setup + Emulator (Android)
**Pros:**
- No hardware costs
- Multiple instances possible
- Easy to test different OS versions
- Good for CI/CD integration
- Full hot reload support

**Cons:**
- GPU-intensive (needs good machine)
- Slower than physical device
- Requires specific system features (Hyper-V on Windows, KVM on Linux)
- More disk space needed

---

#### ✅ Option 3: Dev Container + Physical Phone
**Pros:**
- Isolated development environment
- Consistent setup across team
- Easy onboarding (clone repo, open dev container)
- Better machine isolation
- Reproducible runtime

**Cons:**
- USB pass-through complexity
- Docker setup overhead
- Slower debugging if network-based
- Learning curve for team
- May need special Docker configurations

---

#### ⚠️ Option 4: Dev Container + Emulator (Android)
**Pros:**
- Fully isolated environment
- No local Android SDK needed
- Great for team standardization
- Clean machine after project

**Cons:**
- Nested virtualization (complex architecture)
- Performance overhead (emulator in container)
- Display/GPU acceleration challenging
- Requires Docker Desktop Pro / special config
- Slower hot reload iteration

**Feasibility:** Possible but complex. Requires:
- Docker Desktop with nested virtualization enabled
- GPU passthrough configuration
- Extra system resources
- More setup overhead

---

#### ⚠️ Option 5: Dev Container + iOS Simulator (macOS only)
**Pros:**
- Fully isolated build environment
- Reproducible team setup
- Easy dependency management

**Cons:**
- macOS limitation (can't run iOS simulator on Linux/Windows)
- Device frame rendering in container is complex
- X11 forwarding needed for visual display
- Still requires local iOS SDK license
- Significant complexity

**Feasibility:** Technically possible but not recommended due to complexity.

---

#### ✅ Option 6: Dev Container + Web
**Pros:**
- Works on any OS (Linux/Windows/macOS)
- Great for rapid iteration
- No device/emulator needed
- Excellent for CI/CD
- Chrome DevTools debugging

**Cons:**
- Mobile-specific features not available in preview
- Not true mobile testing
- Network configuration needed
- Some Flutter APIs unavailable

---

## Phase 3: Recommendation & Decision

Based on your answers, the agent will **recommend the optimal setup** and explain:

1. **Why this choice is optimal** for your situation
2. **Trade-offs you're accepting**
3. **Alternative options if constraints change**
4. **Risk areas to watch**

### Decision Framework

```
IF beginner OR learning
  → Recommend: Local Setup + Emulator (Android)
    Reason: Simple, good learning, no hardware costs
    
IF team collaboration needed
  → Recommend: Dev Container + (Emulator or Physical)
    Reason: Reproducible, onboarding is easy
    
IF performance critical
  → Recommend: Local Setup + Physical Device
    Reason: Best real-world testing conditions
    
IF multiple OSes OR complex setup
  → Recommend: Dev Container (choose testing platform)
    Reason: Isolation, consistency, easier maintenance
    
IF uncertain between options
  → Ask user: "What's your top priority: 
      1) Speed of iteration
      2) Consistency/team collaboration
      3) Ease of setup
      4) Realistic testing"
```

---

## Phase 4: Implementation Setup

Once you've decided on your approach, the agent will guide you through setup:

### Path A: Local Setup (Choose: Android, iOS, or Web)

**Prerequisites Check:**
```
✓ Install Dart SDK 3.9+
✓ Install Flutter SDK 3.35+
✓ Install VS Code + Dart extension v3.116+
✓ Configure dart.mcpServer: true in settings
```

**For Android:**
- Install Android SDK
- Create/configure emulator OR connect physical device
- Set up USB debugging
- Run `flutter devices` to verify

**For iOS (macOS only):**
- Install Xcode
- Create/configure iOS simulator OR connect physical device
- Run `flutter devices` to verify
- May need to accept Xcode license: `sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer`

**For Web:**
- Install Chrome/Firefox
- Run `flutter run -d chrome` to start

---

### Path B: Dev Container Setup

**Create `.devcontainer/devcontainer.json`:**

```json
{
  "name": "Flutter Dev",
  "image": "ghcr.io/cirruslabs/flutter:latest",
  "customizations": {
    "vscode": {
      "extensions": [
        "Dart-Code.dart-code",
        "Dart-Code.flutter"
      ],
      "settings": {
        "dart.mcpServer": true,
        "dart.sdkPath": "/opt/flutter/bin",
        "dart.flutterSdkPath": "/opt/flutter"
      }
    }
  },
  "postCreateCommand": "flutter pub get && dart pub global activate build_runner",
  "remoteUser": "root"
}
```

**For Dev Container + Physical Phone:**

Add USB host device mapping to `docker-compose.yml`:
```yaml
services:
  flutter-dev:
    # ... other config ...
    devices:
      - /dev/bus/usb:/dev/bus/usb
    # For Linux: allow adb to access USB
    extra_hosts:
      - "host.docker.internal:host-gateway"
```

**For Dev Container + Android Emulator (Advanced):**

Enable nested virtualization and GPU passthrough (complex, requires:
- Docker Desktop Pro
- Nested virtualization enabled in hypervisor
- GPU passthrough configured
- Extra Docker Desktop settings

This is **not recommended for beginners**.

---

### Create Project Structure

```
my_flutter_app
├── .devcontainer/          # (if using dev container)
│   ├── devcontainer.json
│   ├── Dockerfile
│   └── setup.sh
├── lib/
│   ├── main.dart
│   ├── config/
│   │   ├── router.dart
│   │   └── theme.dart
│   ├── features/
│   ├── domain/
│   ├── data/
│   └── core/
├── test/
│   ├── unit/
│   ├── widget/
│   └── integration/
├── pubspec.yaml
└── analysis_options.yaml
```

---

## Phase 5: Verify Setup

### Verification Checklist

**All Setups:**
- [ ] `dart --version` shows 3.9+
- [ ] `flutter --version` shows 3.35+
- [ ] `flutter doctor` shows no critical errors
- [ ] VS Code Dart extension v3.116+
- [ ] `dart.mcpServer: true` in settings

**With Dev Container:**
- [ ] `.devcontainer/devcontainer.json` exists
- [ ] Can "Reopen in Container"
- [ ] Inside container: `dart --version` ✓
- [ ] Inside container: `flutter devices` shows devices

**With Testing Platform:**
- [ ] `flutter devices` lists your test platform
- [ ] Example:
  ```
  1 connected device:
  - Android device (mobile)    • emulator-5554  • android-x86_64 • Android 12
  ```
- [ ] Run `flutter run` successfully

**Project Setup:**
- [ ] `flutter pub get` succeeds
- [ ] `dart analyze` shows no errors
- [ ] `flutter test` passes (if tests exist)

---

## Phase 6: Getting Started

Once verified, start development:

### Create First Screen

```bash
# (or use MCP tools if in dev container)
flutter create my_app
cd my_app
flutter pub get
flutter run
```

### Use MCP Tools

```
✓ analyze_files - Check code quality
✓ pub_dev_search - Find packages
✓ pub add - Add dependencies
✓ dart_format - Format code
✓ run_tests - Execute tests
✓ hot_reload - Quick iteration
```

---

## Critical Thinking Checklist

The agent will remind you of these considerations:

**Before Setup:**
- [ ] Team size & collaboration needs assessed?
- [ ] Performance requirements discussed?
- [ ] Long-term maintenance plan clear?
- [ ] Constraints documented?
- [ ] Alternatives evaluated?

**After Setup:**
- [ ] Can you onboard a new teammate easily?
- [ ] Is iteration speed acceptable?
- [ ] Are all team members comfortable?
- [ ] Can you reproduce issues consistently?
- [ ] Is setup documented for next project?

---

## Troubleshooting & Support

| Issue | Solution |
|-------|----------|
| Device not detected | Check USB cable; try `flutter devices` |
| Emulator won't start | Check system virtualization enabled |
| MCP tools unavailable | Verify `dart.mcpServer: true` |
| Dev Container won't open | Install Dev Container extension; rebuild |
| Hot reload fails | Restart app with `flutter run` |
| Build errors | Run `flutter pub get` and `flutter clean` |

---

## Summary & Decision Record

**Document Your Choice:**

Create `.setup-record.md`:
```markdown
# Flutter Setup Decision Record

**Setup Choice:** [Dev Container / Local]
**Testing Platform:** [Android / iOS / Web / Physical]
**Date:** [Today]
**Maintainer:** [Your name]

## Why This Choice?
- [Key reason 1]
- [Key reason 2]

## Tradeoffs Accepted:
- [Tradeoff 1]
- [Tradeoff 2]

## Setup Notes:
- [Any special configuration]
- [Team-specific settings]

## Onboarding:
New team members: [steps to get started]
```

This helps document decisions for future reference!

---

## Resources

- [Flutter Official Setup](https://docs.flutter.dev/get-started/install)
- [Dev Containers Spec](https://containers.dev/)
- [Flutter Testing Guide](https://docs.flutter.dev/testing)
- [Dart Language](https://dart.dev/)
