# Welcome Dialog Not Showing - Debug Steps

## ✅ Debug Logging Added

I've added comprehensive debug logging to help identify why the dialog isn't showing.

---

## 🔍 Step 1: Check Console Logs

After installing and running the app, look for these messages in your console:

### Expected Console Output (First Time):

```
🔍 Splash: Checking first-time status...
🔍 FirstTimeService: isFirstTime() = true
🔍 FirstTimeService: hasWelcomeBeenShown() = false
📊 Splash: Is first time: true
📊 Splash: Welcome shown: false
✅ Splash: Showing welcome dialog...
🎯 Splash: Calling WelcomeDialog.show()
🎯 WelcomeDialog: show() called
✅ WelcomeDialog: Building dialog widget
```

### If Dialog Shows and User Taps "Get Started":

```
🎯 WelcomeDialog: User tapped Get Started
📝 FirstTimeService: Setting welcome shown
✅ FirstTimeService: Welcome shown saved
📝 FirstTimeService: Setting not first time
✅ FirstTimeService: Not first time saved
✅ WelcomeDialog: Dialog closed
```

---

## 🐛 Troubleshooting Based on Console Output

### Case 1: No Logs at All

**Problem:** Code not running

**Solution:**
```bash
# Clean and rebuild
flutter clean
flutter pub get
flutter run
```

---

### Case 2: Logs Show "Skipping welcome dialog"

**Console Output:**
```
📊 Splash: Is first time: false
📊 Splash: Welcome shown: true
⏭️ Splash: Skipping welcome dialog (already shown)
```

**Problem:** App thinks it's not first time

**Solution:** Clear app data

**Android:**
```bash
# Method 1: Via ADB
adb shell pm clear com.your.package.name

# Method 2: Manually
# Settings → Apps → JIN Reflexology → Storage → Clear Data
```

**iOS:**
```bash
# Uninstall from simulator
xcrun simctl uninstall booted com.your.package.name
```

---

### Case 3: Logs Stop at "Calling WelcomeDialog.show()"

**Console Output:**
```
✅ Splash: Showing welcome dialog...
🎯 Splash: Calling WelcomeDialog.show()
(No further logs)
```

**Problem:** Dialog widget has an error

**Solution:** Check for errors in console after this line

---

### Case 4: Error About Context

**Console Output:**
```
Error: Cannot show dialog, context is invalid
```

**Problem:** Navigation context issue

**Solution:** Already fixed with increased delay (1000ms instead of 500ms)

---

## 🧪 Quick Test Methods

### Method 1: Complete Fresh Install

```bash
# 1. Stop app
Ctrl+C

# 2. Uninstall from device
adb uninstall com.your.package.name

# 3. Clean build
flutter clean

# 4. Install fresh
flutter run

# 5. Watch console for logs starting with 🔍 📊 ✅ 🎯
```

---

### Method 2: Clear Data Only

```bash
# Clear app data
adb shell pm clear com.your.package.name

# Run app again
flutter run

# Watch console
```

---

### Method 3: Add Test Button (Temporary)

Add this to your home screen for testing:

```dart
// In main_home_dashoabrd_screen.dart
import 'package:jin_reflex_new/services/first_time_service.dart';
import 'package:jin_reflex_new/widgets/welcome_dialog.dart';

// Add somewhere visible (e.g., in AppBar actions or as FAB)
FloatingActionButton(
  onPressed: () async {
    // Check current status
    final isFirstTime = await FirstTimeService.isFirstTime();
    final welcomeShown = await FirstTimeService.hasWelcomeBeenShown();
    
    print("Current Status:");
    print("  Is First Time: $isFirstTime");
    print("  Welcome Shown: $welcomeShown");
    
    // Show dialog manually
    WelcomeDialog.show(context);
  },
  child: Icon(Icons.info),
  tooltip: "Test Welcome Dialog",
)
```

---

### Method 4: Reset Button (For Testing)

```dart
FloatingActionButton(
  onPressed: () async {
    await FirstTimeService.resetFirstTime();
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("✅ Reset complete! Close and reopen app."),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 3),
      ),
    );
  },
  child: Icon(Icons.refresh),
  tooltip: "Reset First Time",
)
```

---

## 📊 What Each Log Means

| Log Message | Meaning |
|-------------|---------|
| `🔍 Splash: Checking first-time status...` | Starting first-time check |
| `🔍 FirstTimeService: isFirstTime() = true` | App detects first time |
| `🔍 FirstTimeService: hasWelcomeBeenShown() = false` | Dialog not shown yet |
| `📊 Splash: Is first time: true` | Confirmed first time |
| `✅ Splash: Showing welcome dialog...` | Will show dialog |
| `🎯 Splash: Calling WelcomeDialog.show()` | Calling show method |
| `🎯 WelcomeDialog: show() called` | Show method executed |
| `✅ WelcomeDialog: Building dialog widget` | Dialog widget building |
| `🎯 WelcomeDialog: User tapped Get Started` | User interaction |
| `📝 FirstTimeService: Setting welcome shown` | Saving status |
| `✅ FirstTimeService: Welcome shown saved` | Status saved |
| `✅ WelcomeDialog: Dialog closed` | Dialog dismissed |

---

## 🎯 Most Common Issues & Solutions

### Issue 1: SharedPreferences Not Working

**Symptom:** Logs show first time = false on fresh install

**Solution:**
```dart
// Check if SharedPreferences is initialized
// In main.dart, ensure this is present:
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppPreference().initialAppPreference();  // ✅ This initializes SharedPreferences
  runApp(ProviderScope(child: const MyApp()));
}
```

---

### Issue 2: Context Invalid After Navigation

**Symptom:** Logs stop at "Calling WelcomeDialog.show()"

**Solution:** Already fixed - increased delay to 1000ms

---

### Issue 3: Dialog Widget Error

**Symptom:** Error after "Building dialog widget"

**Solution:** Check if image asset exists:
```yaml
# In pubspec.yaml
flutter:
  assets:
    - assets/images/image 4.png  # ✅ Must exist
```

---

### Issue 4: Import Errors

**Symptom:** Red underlines or import errors

**Solution:**
```bash
flutter pub get
flutter clean
flutter run
```

---

## 🚀 Final Testing Checklist

Run through these steps:

1. **Uninstall app completely**
   ```bash
   adb uninstall com.your.package.name
   ```

2. **Clean build**
   ```bash
   flutter clean
   flutter pub get
   ```

3. **Run app**
   ```bash
   flutter run
   ```

4. **Watch console** for logs starting with:
   - 🔍 (checking)
   - 📊 (status)
   - ✅ (success)
   - 🎯 (action)

5. **Expected behavior:**
   - Splash screen (5 seconds)
   - Home screen appears
   - Wait 1 second
   - Welcome dialog pops up ✅

6. **Tap "Get Started"**
   - Dialog closes
   - Console shows save logs

7. **Close and reopen app**
   - No dialog (already shown) ✅

---

## 📱 Platform-Specific Commands

### Android:
```bash
# Check if app is installed
adb shell pm list packages | grep com.your.package

# Clear data
adb shell pm clear com.your.package.name

# Uninstall
adb uninstall com.your.package.name

# View logs
adb logcat | grep -i flutter
```

### iOS:
```bash
# List simulators
xcrun simctl list devices

# Uninstall from simulator
xcrun simctl uninstall booted com.your.package.name

# Reset simulator
xcrun simctl erase all
```

---

## 🔧 Emergency Fix: Force Show Dialog

If nothing works, add this temporary code to force show the dialog:

```dart
// In main_home_dashoabrd_screen.dart initState()
@override
void initState() {
  super.initState();
  
  // Force show dialog after 2 seconds (TEMPORARY FOR TESTING)
  Future.delayed(Duration(seconds: 2), () {
    if (mounted) {
      WelcomeDialog.show(context);
    }
  });
}
```

This will show the dialog every time you open the home screen (for testing only).

---

## 📞 Next Steps

1. **Run the app with fresh install**
2. **Check console for the emoji logs**
3. **Copy the console output**
4. **Share the logs if dialog still doesn't show**

The logs will tell us exactly where the issue is!

---

**Debug Version:** 1.0
**Last Updated:** January 30, 2026
