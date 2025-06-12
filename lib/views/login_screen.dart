import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/constants/size_config.dart';
import '../widgets/custom_app_bar.dart';
import '../provider/login_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return ChangeNotifierProvider(
      create: (_) => LoginProvider(),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: CustomAppBar(
          text: 'Giriş Yap',
          onProfileTap: null,
          showLogout: false,
          onLogout: null,
        ),
        body: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(SizeConfig.screenWidth * 0.06),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: emailController,
                    decoration: const InputDecoration(
                      labelText: 'E-posta',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'E-posta giriniz';
                      }
                      if (!value.contains('@')) {
                        return 'Geçerli bir e-posta giriniz';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: SizeConfig.screenHeight * 0.02),
                  TextFormField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Şifre',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Şifre giriniz';
                      }
                      if (value.length < 6) {
                        return 'Şifre en az 6 karakter olmalı';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: SizeConfig.screenHeight * 0.03),
                  Consumer<LoginProvider>(
                    builder: (context, loginProvider, _) {
                      return loginProvider.isLoading
                          ? const CircularProgressIndicator()
                          : ElevatedButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                final error = await loginProvider
                                    .signInWithEmail(
                                      emailController.text,
                                      passwordController.text,
                                    );
                                if (error == null) {
                                  Navigator.pushReplacementNamed(
                                    context,
                                    '/home',
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Giriş başarısız: $error'),
                                    ),
                                  );
                                }
                              }
                            },
                            child: const Text('Giriş Yap'),
                          );
                    },
                  ),
                  const SizedBox(height: 16),
                  Consumer<LoginProvider>(
                    builder: (context, loginProvider, _) {
                      return loginProvider.isLoading
                          ? const SizedBox.shrink()
                          : ElevatedButton.icon(
                            icon: Icon(Icons.login),
                            label: Text('Google ile Giriş Yap'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.redAccent,
                            ),
                            onPressed: () async {
                              final error =
                                  await loginProvider.signInWithGoogle();
                              if (error == null) {
                                Navigator.pushReplacementNamed(
                                  context,
                                  '/home',
                                );
                              } else if (error !=
                                  'Google ile giriş iptal edildi') {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Google ile giriş başarısız: $error',
                                    ),
                                  ),
                                );
                              }
                            },
                          );
                    },
                  ),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacementNamed(context, '/register');
                    },
                    child: const Text(
                      'Kayıt Ol',
                      style: TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  SizedBox(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
