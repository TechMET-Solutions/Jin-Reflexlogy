# First-Time Welcome Dialog - Testing Guide

## 🧪 Quick Testing Steps

### Method 1: Fresh Install (Recommended)

```bash
# 1. Uninstall app completely
flutter clean

# 2. Rebuild and install
flutter run

# 3. App will open → Splash screen → Home → Welcome Dialog ✅
```

---

### Method 2: Clear App Data (Android)

**On Device:**
1. Go to Settings → Apps
2. Find "JIN Reflexology"
3. Tap "Storage"
4. Tap "Clear Data" (not just cache)
5. Open app again
6. Welcome dialog appears ✅

**Via ADB:**
```bash
adb shell pm clear com.your.package.name
```

---

### Method 3: Reset via Code (For Development)

Add this temporary button to your home screen:

```dart
// In main_home_dashoabrd_screen.dart or any screen
import 'package:jin_reflex_new/services/first_time_service.dart';

// Add this button somewhere visible
FloatingActionButton(
  onPressed: () async {
    await FirstTimeService.resetFirstTime();
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("✅ Reset! Close and reopen app to see dialog."),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 3),
      ),
    );
  },
  child: Icon(Icons.refresh),
  tooltip: "Reset First Time (Testing Only)",
)
```

**Steps:**
1. Tap the reset button
2. Close app completely (swipe away from recent apps)
3. Open app again
4. Welcome dialog appears ✅

---

### Method 4: Manual SharedPreferences Clear

Add this debug function:

```dart
// In any screen
Future<void> _debugResetFirstTime() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.clear(); // Clears ALL preferences
  
  print("✅ All preferences cleared!");
  
  // Or clear specific keys only:
  // await prefs.remove('is_first_time_user');
  // await prefs.remove('welcome_dialog_shown');
}
```

---

## ✅ Expected Behavior

### First Launch:
```
1. Splash Screen (5 seconds)
   ↓
2. Home Screen appears
   ↓
3. Wait 0.5 seconds
   ↓
4. Welcome Dialog pops up ✨
   ↓
5. User taps "GET STARTED"
   ↓
6. Dialog closes
   ↓
7. User can use app normally
```

### Second Launch:
```
1. Splash Screen (5 seconds)
   ↓
2. Home Screen appears
   ↓
3. No dialog (already shown) ✅
```

---

## 🔍 Debug Logging

Add these logs to verify behavior:

### In splash_screen.dart:

```dart
Future.delayed(const Duration(seconds: 5), () async {
  if (!mounted) return;
  
  print("🔍 Checking first-time status...");
  
  final isFirstTime = await FirstTimeService.isFirstTime();
  final welcomeShown = await FirstTimeService.hasWelcomeBeenShown();
  
  print("📊 Is first time: $isFirstTime");
  print("📊 Welcome shown: $welcomeShown");
  
  await Navigator.pushReplacement(...);
  
  if (!mounted) return;
  
  if (isFirstTime && !welcomeShown) {
    print("✅ Showing welcome dialog...");
    Future.delayed(const Duration(milliseconds: 500), () {
      if (!mounted) return;
      WelcomeDialog.show(context);
    });
  } else {
    print("⏭️ Skipping welcome dialog (already shown)");
  }
});
```

### In welcome_dialog.dart:

```dart
void _handleGetStarted() async {
  print("🎯 User tapped Get Started");
  
  await FirstTimeService.setWelcomeShown();
  await FirstTimeService.setNotFirstTime();
  
  print("✅ First-time status saved");
  
  if (!mounted) return;
  Navigator.of(context).pop();
  
  widget.onGetStarted?.call();
}
```

---

## 📊 Console Output Examples

### First Launch (Dialog Shows):
```
🔍 Checking first-time status...
📊 Is first time: true
📊 Welcome shown: false
✅ Showing welcome dialog...
🎯 User tapped Get Started
✅ First-time status saved
```

### Second Launch (No Dialog):
```
🔍 Checking first-time status...
📊 Is first time: false
📊 Welcome shown: true
⏭️ Skipping welcome dialog (already shown)
```

---

## 🐛 Troubleshooting

### Problem: Dialog doesn't show on first launch

**Check 1: Verify SharedPreferences**
```dart
final prefs = await SharedPreferences.getInstance();
print("is_first_time_user: ${prefs.getBool('is_first_time_user')}");
print("welcome_dialog_shown: ${prefs.getBool('welcome_dialog_shown')}");
```

Expected on first launch:
- `is_first_time_user: null` (or `true`)
- `welcome_dialog_shown: null` (or `false`)

**Check 2: Verify imports**
```dart
import 'package:jin_reflex_new/services/first_time_service.dart';
import 'package:jin_reflex_new/widgets/welcome_dialog.dart';
```

**Check 3: Verify file locations**
- `lib/services/first_time_service.dart` ✅
- `lib/widgets/welcome_dialog.dart` ✅

---

### Problem: Dialog shows every time

**Solution:** Check if `setNotFirstTime()` is called:

```dart
// In welcome_dialog.dart _handleGetStarted()
await FirstTimeService.setWelcomeShown();
await FirstTimeService.setNotFirstTime();  // ✅ Must be here
```

---

### Problem: Dialog appears too early

**Solution:** Increase delay:

```dart
// In splash_screen.dart
Future.delayed(const Duration(milliseconds: 1000), () {  // Increase from 500
  if (!mounted) return;
  WelcomeDialog.show(context);
});
```

---

### Problem: Animation doesn't work

**Solution:** Check `SingleTickerProviderStateMixin`:

```dart
class _WelcomeDialogState extends State<WelcomeDialog>
    with SingleTickerProviderStateMixin {  // ✅ Must have this
```

---

## 🎯 Test Scenarios

### Scenario 1: New User
- ✅ Install app
- ✅ Open app
- ✅ See splash screen
- ✅ See home screen
- ✅ See welcome dialog
- ✅ Tap "Get Started"
- ✅ Dialog closes

### Scenario 2: Returning User
- ✅ Open app (already installed)
- ✅ See splash screen
- ✅ See home screen
- ✅ No welcome dialog

### Scenario 3: Reset and Test
- ✅ Tap reset button
- ✅ Close app
- ✅ Open app
- ✅ See welcome dialog again

### Scenario 4: Clear Data
- ✅ Clear app data in settings
- ✅ Open app
- ✅ See welcome dialog

---

## 📱 Platform-Specific Testing

### Android:
```bash
# Clear app data
adb shell pm clear com.your.package.name

# Uninstall
adb uninstall com.your.package.name

# Install and run
flutter run
```

### iOS:
```bash
# Uninstall from simulator
xcrun simctl uninstall booted com.your.package.name

# Install and run
flutter run
```

---

## 🔧 Development Tools

### Add Debug Panel (Temporary)

```dart
// Add to home screen for testing
Container(
  padding: EdgeInsets.all(16),
  color: Colors.red.withOpacity(0.1),
  child: Column(
    children: [
      Text("🔧 DEBUG PANEL (Remove in production)"),
      SizedBox(height: 8),
      
      ElevatedButton(
        onPressed: () async {
          await FirstTimeService.resetFirstTime();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Reset! Restart app.")),
          );
        },
        child: Text("Reset First Time"),
      ),
      
      ElevatedButton(
        onPressed: () async {
          final isFirstTime = await FirstTimeService.isFirstTime();
          final welcomeShown = await FirstTimeService.hasWelcomeBeenShown();
          
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: Text("Status"),
              content: Text(
                "Is First Time: $isFirstTime\n"
                "Welcome Shown: $welcomeShown"
              ),
            ),
          );
        },
        child: Text("Check Status"),
      ),
      
      ElevatedButton(
        onPressed: () {
          WelcomeDialog.show(context);
        },
        child: Text("Show Dialog"),
      ),
    ],
  ),
)
```

---

## ✅ Final Checklist

Before removing debug code:

- [ ] Dialog shows on first launch
- [ ] Dialog doesn't show on second launch
- [ ] "Get Started" button works
- [ ] Animation is smooth
- [ ] All text is correct
- [ ] All icons are correct
- [ ] Colors match design
- [ ] No console errors
- [ ] Remove debug buttons
- [ ] Remove debug logs
- [ ] Test on real device
- [ ] Test on different screen sizes

---

## 🚀 Production Deployment

### Before Release:

1. **Remove Debug Code:**
   ```dart
   // Remove all debug buttons
   // Remove all print statements
   // Remove test reset functions
   ```

2. **Test on Real Devices:**
   - Android phone
   - Android tablet
   - iOS phone (if applicable)
   - iOS tablet (if applicable)

3. **Test Different Scenarios:**
   - Fresh install
   - App update
   - Clear data
   - Reinstall

4. **Verify Analytics (if added):**
   - Dialog view tracked
   - Button click tracked
   - User journey tracked

---

**Testing Guide Version:** 1.0
**Last Updated:** January 30, 2026
**Status:** ✅ Ready for Testing
