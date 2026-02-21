---
name: flutter-control-and-screenshot
description: Guide on how to control a Flutter app using flutter_driver via MCP and capture screenshots
---

# Flutter Driver Control & Screenshot

This skill outlines the process of adding `flutter_driver` support to a Flutter application, launching it via the Dart MCP server, controlling it (tapping, finding widgets), and capturing screenshots (handling Web/Desktop specific constraints).

## Prerequisites

1. **Dart MCP Server**: Ensure the `dart-mcp-server` is active and configured
2. **Flutter Project**: You need a working Flutter project with proper structure
3. **MCP Tools Access**: Agent must have access to `launch_app`, `connect_dart_tooling_daemon`, `flutter_driver_command` MCP tools

## Step 1: Add Dependency

Add `flutter_driver` to the `dev_dependencies` in your `pubspec.yaml`.

```yaml
dev_dependencies:
  flutter_driver:
    sdk: flutter
```

Run `flutter pub get` or use the MCP `pub` tool.

## Step 2: Create Driver Entry Point

Create a separate entry point, typically `test_driver/app.dart`, to enable the driver extension without polluting `main.dart`.

> **Important:** Replace `your_app_package_name` with the actual name of your package as defined in `pubspec.yaml`.

```dart
// test_driver/app.dart
import 'package:flutter_driver/driver_extension.dart';
import 'package:your_app_package_name/main.dart' as app;

void main() {
  // Enable the driver extension
  enableFlutterDriverExtension();

  // Run the app
  app.main();
}
```

## Step 3: Launch App via MCP

Use the MCP `launch_app` tool with parameters:
- `target`: `test_driver/app.dart`
- `device`: `chrome` (or `macos`, `linux`, `windows` for desktop)
- `root`: Absolute path to your project root

**Note**: The tool returns a **DTD URI** (Dart Tooling Daemon) and a **PID**. Save these for later use.

Example output:
```
DTD URI: ws://127.0.0.1:12345/abcdef123456
PID: 1234
```

## Step 4: Connect to DTD

Use MCP `connect_dart_tooling_daemon` with the URI returned from Step 3.

```json
{
  "uri": "ws://127.0.0.1:12345/abcdef123456"
}
```

This establishes a real-time connection to the running app.

## Step 5: Get Widget Tree

Before controlling the app, inspect the widget hierarchy to find widgets to interact with:

Use MCP `get_widget_tree` to retrieve the current widget tree. Look for:
- Widget types (Text, ElevatedButton, etc.)
- Widget keys (if specified)
- Widget properties

Example response highlights:
```
ElevatedButton(key: 'submit-btn', text: 'Submit')
TextField(key: 'email-input')
Text('Welcome Message')
```

## Step 6: Web Screenshot Strategy (Browser Subagent)

If running on **Web (Chrome)**, `flutter_driver`'s screenshot command may not work or may not be fully supported. A robust fallback is to use the browser subagent:

1. **Get App URL**: Use MCP `get_app_logs` with the app's PID. Look for lines like:
   ```
   A Dart VM Service on Chrome is available at: http://127.0.0.1:54321
   ```

2. **Navigate & Snapshot**: Call a browser subagent with task:
   > "Navigate to `http://127.0.0.1:54321`. Wait for render. Take a screenshot."

3. **Save Screenshot**: The browser subagent will provide the screenshot for documentation.

## Step 7: Control the App (Flutter Driver)

Use MCP `flutter_driver_command` to interact with the app:

### Getting Widget Information
```json
{
  "command": "getWidgetDiagnostics",
  "finderType": "ByText",
  "text": "Settings"
}
```

### Tapping a Widget
```json
{
  "command": "tap",
  "finderType": "ByText",
  "text": "Settings"
}
```

### Entering Text
```json
{
  "command": "enterText",
  "finderType": "ByKey",
  "key": "email-input",
  "text": "user@example.com"
}
```

### Scrolling
```json
{
  "command": "scroll",
  "finderType": "ByType",
  "type": "ListView",
  "dx": 0,
  "dy": -200,
  "steps": 5
}
```

### Waiting for Widget
```json
{
  "command": "waitFor",
  "finderType": "ByText",
  "text": "Loading Complete"
}
```

## Step 8: Capturing App Screenshots

### For Mobile/Desktop Apps
Use MCP `flutter_driver_command` with screenshot:
```json
{
  "command": "screenshot",
  "path": "/tmp/app_screenshot.png"
}
```

### For Web Apps
Use the browser subagent (as described in Step 6) to capture screenshots.

## Step 9: Cleanup

Always stop the app when done to free up ports and resources.

Use MCP `stop_app` with the **PID** from Step 3:
```json
{
  "pid": 1234
}
```

## Example Workflow: E2E Test Screenshots

Typical workflow to capture screenshots of different screens:

1. **Launch** `test_driver/app.dart` with device `chrome`
   - Receive: DTD URI and PID
   - Get local URL from logs

2. **Connect** DTD using the URI

3. **Screenshot Home/Dashboard**
   - Browser subagent: Navigate to app URL, screenshot
   - Tap or navigate if needed using `flutter_driver_command`

4. **Tap "Tasks" tab**
   - `flutter_driver_command`: tap by text "Tasks"

5. **Screenshot Tasks Screen**
   - Browser subagent: screenshot

6. **Tap "Settings" tab**
   - `flutter_driver_command`: tap by text "Settings"

7. **Screenshot Settings Screen**
   - Browser subagent: screenshot

8. **Stop App**
   - `stop_app` with PID

## Finder Types

Common finder types for locating widgets:

| Finder Type | Example | Description |
|-------------|---------|-------------|
| `ByText` | `"Settings"` | Find by displayed text |
| `ByKey` | `"submit-btn"` | Find by widget key |
| `ByType` | `"ElevatedButton"` | Find by widget type/class |
| `BySemantics` | `"Submit Form"` | Find by semantic hint |
| `ByTooltip` | `"Help"` | Find by tooltip text |

## Common Issues & Solutions

### Issue: "Connection refused" for DTD
**Cause**: App not launched or wrong URI
**Fix**: 
- Verify app launched successfully and is running
- Check PID is still active
- Re-launch app if necessary

### Issue: Widget not found
**Cause**: Widget not rendered yet or incorrect finder
**Fix**:
- Use `get_widget_tree` to verify widget exists
- Wait for widget: `flutter_driver_command` with `waitFor`
- Check widget key/text matches exactly

### Issue: Screenshot fails on web
**Cause**: `flutter_driver` screenshot not supported in browser
**Fix**:
- Use browser subagent for web screenshots
- Verify local URL is accessible
- Check port forwarding if remote

### Issue: Port already in use
**Cause**: Previous app instance still running
**Fix**:
- Stop previous app with `stop_app` PID
- Kill process manually if necessary
- Use different device/port

## MCP Tools Used

- `launch_app` - Start Flutter app with driver support
- `connect_dart_tooling_daemon` - Connect to running app
- `get_widget_tree` - Inspect widget hierarchy
- `get_app_logs` - Get application logs and URLs
- `flutter_driver_command` - Control app and interact with widgets
- `stop_app` - Stop running Flutter process

## Use Cases

This skill is perfect for:
- **Manual Testing**: Control app and verify behavior
- **Screenshots**: Capture UI for documentation
- **Regression Testing**: Automated end-to-end tests
- **Bug Investigation**: Interact with app to reproduce issues
- **Demo Recording**: Record interactions and document features

## Resources

- [Flutter Driver Documentation](https://flutter.dev/docs/testing/integration-tests)
- [Dart MCP Server Repository](https://github.com/dart-lang/ai)
- [Flutter Testing Guide](https://docs.flutter.dev/testing)
