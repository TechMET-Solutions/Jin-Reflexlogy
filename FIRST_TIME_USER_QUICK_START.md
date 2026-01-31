# First-Time User Dialog - Quick Start Guide

## 🚀 5-Minute Setup

### ✅ Step 1: Files Already Created

These files have been created in your project:

```
✅ lib/services/first_time_user_service.dart
✅ lib/widgets/first_time_user_dialog.dart
✅ lib/widgets/first_time_user_checker.dart
```

### ✅ Step 2: Dependencies Already Installed

`shared_preferences: ^2.5.3` is already in your `pubspec.yaml` ✅

---

## 📝 Integration Options

### Option 1: Automatic (Easiest) ⭐ RECOMMENDED

Update your `main.dart`:

```dart
import 'package:flutter/material.dart';
import 'services/first_time_user_service.dart';
import 'widgets/first_time_user_checker.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize the service
  await FirstTimeUserService().init();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jin Reflexology',
      home: FirstTimeUserChecker(
        onDialogSubmitted: () {
          print('✅ First-time user data saved');
        },
        child: YourExistingHomeScreen(), // Replace with your home screen
      ),
    );
  }
}
```

**That's it!** The dialog will show automatically on first install.

---

### Option 2: Manual Check (More Control)

If you have a splash screen or login flow:

```dart
import 'services/first_time_user_service.dart';
import 'widgets/first_time_user_dialog.dart';

class YourSplashScreen extends StatefulWidget {
  @override
  State<YourSplashScreen> createState() => _YourSplashScreenState();
}

class _YourSplashScreenState extends State<YourSplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAndNavigate();
  }

  Future<void> _checkAndNavigate() async {
    // Initialize service
    final service = FirstTimeUserService();
    await service.init();
    
    // Check if first-time user
    final isFormSubmitted = await service.isFormSubmitted();
    
    if (!isFormSubmitted) {
      // Show dialog
      await FirstTimeUserDialog.show(context);
    }
    
    // Navigate to your home screen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => YourHomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
```

---

## 🎯 How It Works

### First App Install:
```
User opens app
    ↓
Dialog appears automatically
    ↓
User fills: Name, Email, Phone, Dealer ID
    ↓
User clicks Submit
    ↓
Data saved to SharedPreferences
    ↓
Flag set: isFormSubmitted = true
    ↓
Dialog closes
```

### Subsequent App Opens:
```
User opens app
    ↓
Check: isFormSubmitted?
    ↓
YES → Skip dialog, go to home
```

### After Logout/Login:
```
User logs out
    ↓
User logs in again
    ↓
Check: isFormSubmitted?
    ↓
YES → Skip dialog (data persists!)
```

### After Uninstall:
```
User uninstalls app
    ↓
SharedPreferences deleted
    ↓
User reinstalls app
    ↓
Check: isFormSubmitted?
    ↓
NO → Show dialog again (fresh install)
```

---

## 📱 Testing

### Test 1: First Install
1. Run app on emulator/device
2. ✅ Dialog should appear
3. Fill form and submit
4. ✅ Dialog closes

### Test 2: App Restart
1. Close app completely
2. Open app again
3. ✅ Dialog should NOT appear

### Test 3: Clear Data (Testing Only)

Add this button to your home screen for testing:

```dart
ElevatedButton(
  onPressed: () async {
    await FirstTimeUserService().clearAllData();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Data cleared! Restart app.')),
    );
  },
  child: Text('Clear Data (Testing)'),
)
```

---

## 🔍 View Saved Data

Add this to your home screen to view saved data:

```dart
ElevatedButton(
  onPressed: () async {
    final service = FirstTimeUserService();
    final userData = await service.getAllUserData();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Saved Data'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name: ${userData['name']}'),
            Text('Email: ${userData['email']}'),
            Text('Phone: ${userData['phone']}'),
            Text('Dealer ID: ${userData['dealerId']}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  },
  child: Text('View Saved Data'),
)
```

---

## 🎨 Customization

### Change Dialog Colors

Edit `lib/widgets/first_time_user_dialog.dart`:

```dart
// Line ~150: Header background
color: Colors.blue[50],  // Change to your brand color

// Line ~350: Submit button
backgroundColor: Colors.blue[700],  // Change to your brand color
```

### Change Dialog Text

```dart
// Line ~140: Title
const Text('Welcome!'),  // Change to your text

// Line ~150: Subtitle
const Text('Please provide your information'),  // Change to your text
```

### Make Fields Optional

```dart
// Remove validator to make field optional
TextFormField(
  controller: _dealerIdController,
  decoration: InputDecoration(
    labelText: 'Dealer ID (Optional)',  // Add (Optional)
  ),
  // validator: _validateDealerId,  // Comment out or remove
),
```

---

## 🐛 Troubleshooting

### Dialog Not Showing?

**Check 1:** Is service initialized?
```dart
await FirstTimeUserService().init();
```

**Check 2:** Is data already saved?
```dart
final service = FirstTimeUserService();
final isSubmitted = await service.isFormSubmitted();
print('Form submitted: $isSubmitted');  // Should be false on first install
```

**Check 3:** Clear data and try again
```dart
await FirstTimeUserService().clearAllData();
// Restart app
```

---

### Dialog Shows Every Time?

**Check:** Is data being saved?
```dart
final success = await service.saveUserData(...);
print('Save success: $success');  // Should be true
```

**Fix:** Ensure you're using `await`:
```dart
await service.saveUserData(...);  // Don't forget await!
```

---

## 📊 API Reference

### Check if form submitted:
```dart
final isSubmitted = await FirstTimeUserService().isFormSubmitted();
```

### Save data:
```dart
await FirstTimeUserService().saveUserData(
  name: 'John Doe',
  email: 'john@example.com',
  phone: '1234567890',
  dealerId: 'DEALER123',
);
```

### Get saved data:
```dart
final name = await FirstTimeUserService().getUserName();
final email = await FirstTimeUserService().getUserEmail();
final phone = await FirstTimeUserService().getUserPhone();
final dealerId = await FirstTimeUserService().getDealerId();
```

### Get all data:
```dart
final userData = await FirstTimeUserService().getAllUserData();
// Returns: Map<String, String?>
```

### Clear data (testing only):
```dart
await FirstTimeUserService().clearAllData();
```

---

## ✅ Checklist

- [ ] Files created in project
- [ ] `shared_preferences` in pubspec.yaml (already done ✅)
- [ ] Service initialized in main.dart
- [ ] `FirstTimeUserChecker` added to home screen
- [ ] Tested on fresh install
- [ ] Tested after app restart
- [ ] Tested after logout/login

---

## 🎉 You're Done!

The first-time user dialog is now ready to use!

**What happens:**
- ✅ Shows once on first install
- ✅ Collects user data
- ✅ Saves to local storage
- ✅ Never shows again (unless app uninstalled)
- ✅ Data persists across logout/login

**Need help?** Check `FIRST_TIME_USER_DIALOG_GUIDE.md` for detailed documentation.

---

**Quick Start Version:** 1.0  
**Last Updated:** January 30, 2026
