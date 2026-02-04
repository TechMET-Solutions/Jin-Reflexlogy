// ============================================
// LOGIN & TOKEN PERSISTENCE - CODE EXAMPLES
// ============================================

import 'package:flutter/material.dart';
import 'package:jin_reflex_new/api_service/prefs/PreferencesKey.dart';
import 'package:jin_reflex_new/prefs/app_preference.dart';
import 'package:jin_reflex_new/services/auth_service.dart';
import 'package:jin_reflex_new/dashbord_forlder/freddback_list.dart';
import 'package:jin_reflex_new/login_screen.dart';

// ============================================
// 1. HOW TO SAVE TOKEN ON LOGIN
// ============================================

Future<void> saveLoginData({
  required String userId,
  required String token,
  required String type,
  String name = "",
  String email = "",
  String mobile = "",
}) async {
  // Save all user data
  await AppPreference().setString(PreferencesKey.userId, userId);
  await AppPreference().setString(PreferencesKey.token, token);
  await AppPreference().setString(PreferencesKey.type, type);
  await AppPreference().setString(PreferencesKey.name, name);
  await AppPreference().setString(PreferencesKey.email, email);
  await AppPreference().setString(PreferencesKey.contactNumber, mobile);
  
  // Reload preferences to ensure data is available
  await AppPreference().initialAppPreference();
  
  debugPrint("✅ Login data saved successfully");
}

// ============================================
// 2. HOW TO CHECK LOGIN STATUS
// ============================================

// Method 1: Using AuthService (Recommended)
bool checkLoginWithAuthService() {
  return AuthService().isLoggedIn();
}

bool checkPatientLoginWithAuthService() {
  return AuthService().isPatientLoggedIn();
}

// Method 2: Manual check
bool checkLoginManually() {
  final token = AppPreference().getString(PreferencesKey.token);
  final userId = AppPreference().getString(PreferencesKey.userId);
  
  return token.isNotEmpty && userId.isNotEmpty;
}

bool checkPatientLoginManually() {
  final token = AppPreference().getString(PreferencesKey.token);
  final userId = AppPreference().getString(PreferencesKey.userId);
  final type = AppPreference().getString(PreferencesKey.type);
  
  return token.isNotEmpty && userId.isNotEmpty && type == "patient";
}

// ============================================
// 3. HOW TO NAVIGATE TO BODYPARTSCREEN
// ============================================

// After successful login - skip login check
void navigateToBodyPartScreenAfterLogin(BuildContext context, String userId) {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (_) => BodyPartScreen(
        pId: userId,
        dId: null,
        day: "last",
        isShow: false, // ✅ Skip login check
      ),
    ),
  );
}

// From home screen - check login first
void navigateToBodyPartScreenFromHome(BuildContext context, String patientId) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => BodyPartScreen(
        pId: patientId,
        dId: null,
        day: "last",
        isShow: true, // ✅ Check login status
      ),
    ),
  );
}

// ============================================
// 4. HOW TO AVOID REDIRECT LOOP
// ============================================

// ❌ WRONG - Creates loop
void wrongNavigation(BuildContext context) {
  Navigator.push( // Using push instead of pushReplacement
    context,
    MaterialPageRoute(
      builder: (_) => BodyPartScreen(
        pId: "123",
        dId: null,
        day: "last",
        isShow: true, // Still checking login after login
      ),
    ),
  );
}

// ✅ CORRECT - No loop
void correctNavigation(BuildContext context) {
  Navigator.pushReplacement( // Using pushReplacement
    context,
    MaterialPageRoute(
      builder: (_) => BodyPartScreen(
        pId: "123",
        dId: null,
        day: "last",
        isShow: false, // Skip login check after login
      ),
    ),
  );
}

// ============================================
// 5. COMPLETE LOGIN WIDGET EXAMPLE
// ============================================

class MyLoginScreen extends StatefulWidget {
  const MyLoginScreen({super.key});

  @override
  State<MyLoginScreen> createState() => _MyLoginScreenState();
}

class _MyLoginScreenState extends State<MyLoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _handleLogin() async {
    setState(() => _isLoading = true);

    try {
      // Call your login API
      final response = await _callLoginAPI(
        _usernameController.text,
        _passwordController.text,
      );

      if (response['success'] == 1) {
        // Extract data
        final userId = response['id']?.toString() ?? "";
        final token = response['token']?.toString() ?? "";
        final type = response['type']?.toString() ?? "patient";
        final name = response['name']?.toString() ?? "";
        final email = response['email']?.toString() ?? "";
        final mobile = response['mobile']?.toString() ?? "";

        // Save to SharedPreferences
        await saveLoginData(
          userId: userId,
          token: token,
          type: type,
          name: name,
          email: email,
          mobile: mobile,
        );

        // Navigate to BodyPartScreen
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => BodyPartScreen(
                pId: userId,
                dId: null,
                day: "last",
                isShow: false, // Skip login check
              ),
            ),
          );
        }
      } else {
        // Show error
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Invalid credentials')),
          );
        }
      }
    } catch (e) {
      debugPrint("Login error: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<Map<String, dynamic>> _callLoginAPI(
    String username,
    String password,
  ) async {
    // Your API call here
    // This is just a placeholder
    return {
      'success': 1,
      'id': '123',
      'token': 'abc123',
      'type': 'patient',
      'name': 'John Doe',
      'email': 'john@example.com',
      'mobile': '1234567890',
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: 'Username'),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _isLoading ? null : _handleLogin,
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================
// 6. PROTECTED SCREEN EXAMPLE
// ============================================

class ProtectedScreen extends StatelessWidget {
  const ProtectedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Check if user is logged in
    if (!AuthService().isPatientLoggedIn()) {
      // Not logged in - show login screen
      return JinLoginScreen(
        text: "ProtectedScreen",
        type: "patient",
        registershow: false,
        onTab: () {
          // After login, navigate back to this screen
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const ProtectedScreen()),
          );
        },
      );
    }

    // Logged in - show protected content
    return Scaffold(
      appBar: AppBar(title: const Text('Protected Screen')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Welcome ${AuthService().getUserName()}!'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await AuthService().logout();
                if (context.mounted) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ProtectedScreen(),
                    ),
                  );
                }
              },
              child: const Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================
// 7. APP START FLOW EXAMPLE
// ============================================

class MyAppStartScreen extends StatefulWidget {
  const MyAppStartScreen({super.key});

  @override
  State<MyAppStartScreen> createState() => _MyAppStartScreenState();
}

class _MyAppStartScreenState extends State<MyAppStartScreen> {
  @override
  void initState() {
    super.initState();
    _checkLoginAndNavigate();
  }

  Future<void> _checkLoginAndNavigate() async {
    // Wait for splash animation
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    // Check if user is logged in
    if (AuthService().isPatientLoggedIn()) {
      // Logged in - go to BodyPartScreen
      final userId = AuthService().getUserId();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => BodyPartScreen(
            pId: userId,
            dId: null,
            day: "last",
            isShow: false, // Already logged in
          ),
        ),
      );
    } else {
      // Not logged in - go to home screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const MyHomeScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

class MyHomeScreen extends StatelessWidget {
  const MyHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: const Center(child: Text('Home Screen')),
    );
  }
}

// ============================================
// 8. LOGOUT EXAMPLE
// ============================================

Future<void> handleLogout(BuildContext context) async {
  // Show confirmation dialog
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Logout'),
      content: const Text('Are you sure you want to logout?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          child: const Text('Logout'),
        ),
      ],
    ),
  );

  if (confirmed == true) {
    // Clear all user data
    await AuthService().logout();

    // Navigate to login screen
    if (context.mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => JinLoginScreen(
            text: "Home",
            type: "",
            registershow: true,
            onTab: () {},
          ),
        ),
        (route) => false, // Remove all previous routes
      );
    }
  }
}

// ============================================
// 9. DEBUG HELPER
// ============================================

void debugAuthStatus() {
  debugPrint("===== AUTH DEBUG =====");
  debugPrint("Is Logged In: ${AuthService().isLoggedIn()}");
  debugPrint("Is Patient: ${AuthService().isPatientLoggedIn()}");
  debugPrint("User ID: ${AuthService().getUserId()}");
  debugPrint("User Type: ${AuthService().getUserType()}");
  debugPrint("Token: ${AuthService().getToken()}");
  debugPrint("Name: ${AuthService().getUserName()}");
  debugPrint("=====================");
}

// ============================================
// 10. USAGE IN MAIN.DART
// ============================================

/*
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // ✅ Initialize SharedPreferences
  await AppPreference().initialAppPreference();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'JIN Reflexology',
      home: MyAppStartScreen(), // Check login on start
    );
  }
}
*/
