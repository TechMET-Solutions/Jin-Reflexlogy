import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jin_reflex_new/api_service/auth/login_notifier.dart';
import 'package:jin_reflex_new/api_service/auth/sign_up_screen.dart';

class JinLoginScreen extends ConsumerStatefulWidget {
  const JinLoginScreen({
    super.key,
    required this.onTab,
    required this.text,
    this.type,
  });

  final VoidCallback onTab;
  final text;
  final type;

  @override
  ConsumerState<JinLoginScreen> createState() => _JinLoginScreenState();
}

class _JinLoginScreenState extends ConsumerState<JinLoginScreen> {
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _rememberMe = false;

  @override
  void initState() {
    super.initState();
    print("🟢 JinLoginScreen initState");
  }

  @override
  void dispose() {
    print("🟠 JinLoginScreen dispose");
    _idController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loginState = ref.watch(loginProvider);
    final size = MediaQuery.of(context).size;

    print("🔵 JinLoginScreen build()");
    print("➡️ Login State: $loginState");
    print("➡️ Screen text: ${widget.text}");
    print("➡️ Login type: ${widget.type}");

    return SingleChildScrollView(
      child: Material(
        child: SizedBox(
          height: size.height,
          child: Stack(
            children: [
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: ClipPath(
                  clipper: TopWaveClipper(),
                  child: Container(
                    height: size.height * 0.4,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color.fromARGB(255, 19, 4, 66),
                          Color.fromARGB(255, 88, 72, 137),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                  ),
                ),
              ),

              Positioned(
                top: size.height * 0.12,
                left: 0,
                right: 0,
                child: Column(
                  children: const [
                    Text(
                      "JIN REFLEXOLOGY",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1.5,
                      ),
                    ),
                    SizedBox(height: 8),
                  ],
                ),
              ),

              Positioned(
                top: size.height * 0.25,
                left: 20,
                right: 20,
                child: Container(
                  padding: const EdgeInsets.all(30),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 30),

                      /// ID FIELD
                      TextField(
                        controller: _idController,
                        onChanged: (value) {
                          print("✏️ ID changed: $value");
                        },
                        decoration: const InputDecoration(
                          hintText: "ID",
                        ),
                      ),

                      const SizedBox(height: 20),

                      /// PASSWORD FIELD
                      TextField(
                        controller: _passwordController,
                        obscureText: !_isPasswordVisible,
                        onChanged: (value) {
                          print("✏️ Password changed (length): ${value.length}");
                        },
                        decoration: InputDecoration(
                          hintText: "Password",
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                _isPasswordVisible = !_isPasswordVisible;
                                print(
                                  "👁 Password visibility: $_isPasswordVisible",
                                );
                              });
                            },
                          ),
                        ),
                      ),

                      const SizedBox(height: 30),

                      /// LOGIN BUTTON
                      InkWell(
                        onTap: loginState.isLoading
                            ? null
                            : () async {
                                print("🟣 LOGIN BUTTON TAPPED");

                                final username =
                                    _idController.text.trim();
                                final password =
                                    _passwordController.text.trim();

                                print("➡️ Username: $username");
                                print(
                                    "➡️ Password length: ${password.length}");

                                if (username.isEmpty ||
                                    password.isEmpty) {
                                  print("❌ Validation failed: Empty fields");
                                  return;
                                }

                                print("🚀 Calling loginProvider.login()");
                                await ref
                                    .read(loginProvider.notifier)
                                    .login(
                                      context,
                                      widget.onTab,
                                      widget.text,
                                      widget.type,
                                      username,
                                      password,
                                    );
                              },
                        child: Container(
                          height: 56,
                          alignment: Alignment.center,
                          child: loginState.maybeWhen(
                            loading: () {
                              print("⏳ Login loading...");
                              return const CircularProgressIndicator();
                            },
                            orElse: () => const Text("LOG IN"),
                          ),
                        ),
                      ),

                      const SizedBox(height: 30),

                      /// SIGN UP
                      Center(
                        child: GestureDetector(
                          onTap: () {
                            print("➡️ Navigate to SignUpScreen");
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) => SignUpScreen(),
                              ),
                            );
                          },
                          child: const Text("Sign Up"),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// TOP WAVE CLIPPER
class TopWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    print("🎨 TopWaveClipper getClip()");
    final path = Path();
    path.lineTo(0, size.height * 0.8);
    path.quadraticBezierTo(
      size.width * 0.25,
      size.height * 0.9,
      size.width * 0.5,
      size.height * 0.8,
    );
    path.quadraticBezierTo(
      size.width * 0.75,
      size.height * 0.7,
      size.width,
      size.height * 0.85,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
