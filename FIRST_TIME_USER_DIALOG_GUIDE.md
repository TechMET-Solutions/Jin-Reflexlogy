# First-Time User Dialog - Complete Implementation Guide

## 📋 Overview

A production-ready Flutter implementation that shows a popup form **only on first app install**. The data persists across app sessions, logins, and logouts, and is only deleted when the app is uninstalled.

---

## ✨ Features

✅ Shows popup **only once** on first app install  
✅ Collects: Name, Email, Phone, Dealer ID  
✅ **Persistent storage** using SharedPreferences  
✅ Data survives logout/login cycles  
✅ Data deleted only on app uninstall  
✅ Form validation included  
✅ Beautiful Material Design UI  
✅ Loading states and error handling  
✅ Production-ready code  

---

## 📁 File Structure

```
lib/
├── services/
│   └── first_time_user_service.dart    # Storage service (Singleton)
├── widgets/
│   ├── first_time_user_dialog.dart     # Popup dialog UI
│   └── first_time_user_checker.dart    # Auto-check widget
└── main.dart                            # Integration example
```

---

## 🚀 Quick Start

### Step 1: Add Dependencies

Add to `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  shared_preferences: ^2.2.2
```

Run:
```bash
flutter pub get
```

---

### Step 2: Copy Files

Copy these files to your project:

1. **lib/services/first_time_user_service.dart** - Storage service
2. **lib/widgets/first_time_user_dialog.dart** - Dialog UI
3. **lib/widgets/first_time_user_checker.dart** - Auto-checker widget

---

### Step 3: Update main.dart

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
      title: 'Your App',
      home: FirstTimeUserChecker(
        child: YourHomeScreen(), // Your existing home screen
      ),
    );
  }
}
```

---

## 📖 Detailed Usage

### Method 1: Automatic (Recommended)

Wrap your home screen with `FirstTimeUserChecker`:

```dart
home: FirstTimeUserChecker(
  onDialogShown: () {
    print('Dialog shown to first-time user');
  },
  onDialogSubmitted: () {
    print('User submitted the form');
  },
  child: HomeScreen(),
),
```

**How it works:**
1. Checks if form was submitted before
2. If not, shows dialog automatically
3. User fills form and submits
4. Data saved to SharedPreferences
5. Dialog never shows again

---

### Method 2: Manual Check

Check manually in your code:

```dart
class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkFirstTimeUser();
  }

  Future<void> _checkFirstTimeUser() async {
    final service = FirstTimeUserService();
    await service.init();
    
    final isFormSubmitted = await service.isFormSubmitted();
    
    if (!isFormSubmitted) {
      // Show dialog
      await FirstTimeUserDialog.show(context);
    }
    
    // Navigate to home
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => HomeScreen()),
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

### Method 3: After Login

Show dialog after successful login:

```dart
Future<void> _handleLogin() async {
  // Your login logic
  final loginSuccess = await performLogin();
  
  if (loginSuccess) {
    // Check if first-time user
    final service = FirstTimeUserService();
    final isFormSubmitted = await service.isFormSubmitted();
    
    if (!isFormSubmitted) {
      await FirstTimeUserDialog.show(context);
    }
    
    // Navigate to home
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => HomeScreen()),
    );
  }
}
```

---

## 🔧 API Reference

### FirstTimeUserService

Singleton service for managing first-time user data.

#### Methods:

**Initialize:**
```dart
await FirstTimeUserService().init();
```

**Check if form submitted:**
```dart
final isSubmitted = await service.isFormSubmitted();
// Returns: bool
```

**Save user data:**
```dart
final success = await service.saveUserData(
  name: 'John Doe',
  email: 'john@example.com',
  phone: '1234567890',
  dealerId: 'DEALER123',
);
// Returns: bool (true if saved successfully)
```

**Get saved data:**
```dart
final name = await service.getUserName();
final email = await service.getUserEmail();
final phone = await service.getUserPhone();
final dealerId = await service.getDealerId();
final submissionDate = await service.getSubmissionDate();
```

**Get all data:**
```dart
final userData = await service.getAllUserData();
// Returns: Map<String, String?>
// {
//   'name': 'John Doe',
//   'email': 'john@example.com',
//   'phone': '1234567890',
//   'dealerId': 'DEALER123',
//   'submissionDate': '2024-01-30T10:30:00.000Z'
// }
```

**Clear data (for testing only):**
```dart
await service.clearAllData();
// WARNING: This will show popup again on next launch
```

---

### FirstTimeUserDialog

Dialog widget for collecting user information.

#### Show Dialog:

```dart
await FirstTimeUserDialog.show(
  context,
  onSubmitSuccess: () {
    print('Form submitted successfully');
  },
);
```

#### Features:
- ✅ Form validation
- ✅ Email format validation
- ✅ 10-digit phone validation
- ✅ Loading state during submission
- ✅ Error handling
- ✅ Cannot be dismissed (user must fill form)
- ✅ Beautiful Material Design UI

---

### FirstTimeUserChecker

Widget that automatically checks and shows dialog.

#### Usage:

```dart
FirstTimeUserChecker(
  onDialogShown: () {
    // Called when dialog is shown
  },
  onDialogSubmitted: () {
    // Called when user submits form
  },
  child: YourHomeScreen(),
)
```

---

## 🎨 UI Customization

### Customize Dialog Appearance

Edit `lib/widgets/first_time_user_dialog.dart`:

**Change colors:**
```dart
// Header background
color: Colors.blue[50],  // Change to your color

// Submit button
backgroundColor: Colors.blue[700],  // Change to your color
```

**Change text:**
```dart
const Text('Welcome!'),  // Change title
const Text('Please provide your information'),  // Change subtitle
```

**Add/Remove fields:**
```dart
// Add a new field
TextFormField(
  controller: _newFieldController,
  decoration: InputDecoration(
    labelText: 'New Field *',
    prefixIcon: const Icon(Icons.new_icon),
  ),
  validator: _validateNewField,
),
```

---

## 🔒 Data Persistence

### How Data is Stored

Data is stored using **SharedPreferences** with these keys:

```dart
'first_time_form_submitted'  // bool - true if form submitted
'first_time_user_name'       // String - user's name
'first_time_user_email'      // String - user's email
'first_time_user_phone'      // String - user's phone
'first_time_user_dealer_id'  // String - dealer ID
'first_time_submission_date' // String - ISO 8601 date
```

### Data Lifecycle

| Event | Data Status |
|-------|-------------|
| First app install | ❌ No data |
| User fills form | ✅ Data saved |
| App restart | ✅ Data persists |
| User logs out | ✅ Data persists |
| User logs in again | ✅ Data persists |
| Different user logs in | ✅ Data persists (same device) |
| App uninstall | ❌ Data deleted |
| App reinstall | ❌ No data (shows popup again) |

### Why SharedPreferences?

✅ **Persistent** - Survives app restarts  
✅ **Independent** - Not tied to user sessions  
✅ **Simple** - Easy to use and maintain  
✅ **Fast** - Synchronous read/write  
✅ **Reliable** - Built into Flutter  

---

## 🧪 Testing

### Test Scenario 1: First Install

1. Install app
2. Open app
3. ✅ Dialog should appear
4. Fill form and submit
5. ✅ Dialog closes
6. ✅ Data saved

### Test Scenario 2: Second Launch

1. Close app
2. Open app again
3. ✅ Dialog should NOT appear
4. ✅ Data still saved

### Test Scenario 3: Logout/Login

1. Logout from app
2. Login again
3. ✅ Dialog should NOT appear
4. ✅ Data still saved

### Test Scenario 4: Uninstall/Reinstall

1. Uninstall app
2. Reinstall app
3. Open app
4. ✅ Dialog should appear (fresh install)

### Test Scenario 5: Clear Data (Testing)

```dart
// Add this button for testing
ElevatedButton(
  onPressed: () async {
    await FirstTimeUserService().clearAllData();
    // Restart app to see dialog again
  },
  child: Text('Clear Data (Testing)'),
)
```

---

## 🐛 Troubleshooting

### Issue 1: Dialog Not Showing

**Symptom:** Dialog doesn't appear on first install

**Solutions:**
1. Check if service is initialized:
   ```dart
   await FirstTimeUserService().init();
   ```

2. Check if data was cleared:
   ```dart
   final isSubmitted = await service.isFormSubmitted();
   print('Form submitted: $isSubmitted');
   ```

3. Check console for errors

---

### Issue 2: Dialog Shows Every Time

**Symptom:** Dialog appears on every app launch

**Solutions:**
1. Check if data is being saved:
   ```dart
   final success = await service.saveUserData(...);
   print('Save success: $success');
   ```

2. Check SharedPreferences:
   ```dart
   final prefs = await SharedPreferences.getInstance();
   print(prefs.getBool('first_time_form_submitted'));
   ```

3. Ensure you're calling `saveUserData()` after form submission

---

### Issue 3: Data Not Persisting

**Symptom:** Data disappears after app restart

**Solutions:**
1. Ensure you're using `await`:
   ```dart
   await service.saveUserData(...);  // Don't forget await!
   ```

2. Check if save was successful:
   ```dart
   final success = await service.saveUserData(...);
   if (!success) {
     print('Failed to save data');
   }
   ```

3. Verify data after saving:
   ```dart
   final name = await service.getUserName();
   print('Saved name: $name');
   ```

---

### Issue 4: Validation Errors

**Symptom:** Form validation not working

**Solutions:**
1. Check validator functions in `first_time_user_dialog.dart`
2. Ensure form key is set: `key: _formKey`
3. Call validation: `_formKey.currentState!.validate()`

---

## 🔐 Security Considerations

### Current Implementation (SharedPreferences)

✅ **Pros:**
- Simple and fast
- Persistent across app sessions
- Independent of user login

❌ **Cons:**
- Data stored in plain text
- Can be accessed by rooted devices
- Not encrypted

### For Sensitive Data

If you need to store sensitive information, use **flutter_secure_storage**:

```yaml
dependencies:
  flutter_secure_storage: ^9.0.0
```

Replace SharedPreferences with SecureStorage in `first_time_user_service.dart`:

```dart
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class FirstTimeUserService {
  final _storage = const FlutterSecureStorage();
  
  Future<bool> isFormSubmitted() async {
    final value = await _storage.read(key: 'first_time_form_submitted');
    return value == 'true';
  }
  
  Future<bool> saveUserData({...}) async {
    await _storage.write(key: 'first_time_user_name', value: name);
    await _storage.write(key: 'first_time_user_email', value: email);
    // ... etc
  }
}
```

---

## 📊 Analytics Integration

Track first-time user events:

```dart
// In FirstTimeUserDialog
Future<void> _handleSubmit() async {
  // ... existing code ...
  
  if (success) {
    // Track event
    FirebaseAnalytics.instance.logEvent(
      name: 'first_time_user_form_submitted',
      parameters: {
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }
}
```

---

## 🌐 Backend Integration

Send data to your backend:

```dart
Future<void> _handleSubmit() async {
  if (!_formKey.currentState!.validate()) return;
  
  setState(() => _isSubmitting = true);
  
  try {
    // Save locally
    final service = FirstTimeUserService();
    await service.saveUserData(...);
    
    // Send to backend
    final response = await http.post(
      Uri.parse('https://your-api.com/first-time-user'),
      body: {
        'name': _nameController.text.trim(),
        'email': _emailController.text.trim(),
        'phone': _phoneController.text.trim(),
        'dealerId': _dealerIdController.text.trim(),
      },
    );
    
    if (response.statusCode == 200) {
      // Success
      Navigator.pop(context);
    }
  } catch (e) {
    // Handle error
  } finally {
    setState(() => _isSubmitting = false);
  }
}
```

---

## 🎯 Best Practices

### 1. Initialize Early

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirstTimeUserService().init();  // Initialize early
  runApp(MyApp());
}
```

### 2. Handle Errors Gracefully

```dart
try {
  await service.saveUserData(...);
} catch (e) {
  // Show user-friendly error
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Failed to save data')),
  );
}
```

### 3. Validate Before Saving

```dart
if (_formKey.currentState!.validate()) {
  await service.saveUserData(...);
}
```

### 4. Use Callbacks

```dart
FirstTimeUserChecker(
  onDialogSubmitted: () {
    // Refresh UI, send analytics, etc.
  },
  child: HomeScreen(),
)
```

### 5. Test Thoroughly

- Test on fresh install
- Test after logout/login
- Test after app restart
- Test on different devices

---

## 📱 Platform Support

| Platform | Supported | Notes |
|----------|-----------|-------|
| Android | ✅ Yes | Fully supported |
| iOS | ✅ Yes | Fully supported |
| Web | ✅ Yes | Uses browser storage |
| Windows | ✅ Yes | Uses registry |
| macOS | ✅ Yes | Uses UserDefaults |
| Linux | ✅ Yes | Uses file storage |

---

## 🔄 Migration Guide

### From Other Storage Solutions

**From Hive:**
```dart
// Old (Hive)
final box = await Hive.openBox('userData');
box.put('name', name);

// New (SharedPreferences)
final service = FirstTimeUserService();
await service.saveUserData(name: name, ...);
```

**From SQLite:**
```dart
// Old (SQLite)
await database.insert('users', {'name': name});

// New (SharedPreferences)
final service = FirstTimeUserService();
await service.saveUserData(name: name, ...);
```

---

## 📚 Additional Resources

- [SharedPreferences Documentation](https://pub.dev/packages/shared_preferences)
- [Flutter Secure Storage](https://pub.dev/packages/flutter_secure_storage)
- [Form Validation Guide](https://docs.flutter.dev/cookbook/forms/validation)

---

## ✅ Checklist

Before deploying to production:

- [ ] Dependencies added to pubspec.yaml
- [ ] All files copied to project
- [ ] Service initialized in main.dart
- [ ] FirstTimeUserChecker integrated
- [ ] Tested on fresh install
- [ ] Tested after logout/login
- [ ] Tested after app restart
- [ ] Error handling implemented
- [ ] UI customized (optional)
- [ ] Analytics integrated (optional)
- [ ] Backend integration (optional)

---

## 🎉 Summary

You now have a complete, production-ready first-time user dialog system that:

✅ Shows only once on first install  
✅ Persists data across sessions  
✅ Survives logout/login  
✅ Beautiful Material Design UI  
✅ Form validation included  
✅ Error handling built-in  
✅ Easy to integrate  
✅ Well documented  

**Happy coding! 🚀**

---

**Version:** 1.0  
**Last Updated:** January 30, 2026  
**Status:** Production Ready ✅
