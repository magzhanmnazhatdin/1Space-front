import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'register_page.dart';
import 'reset_password_page.dart';
import '../components/my_textfield.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      await authService.value.signIn(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      Navigator.pushReplacementNamed(context, '/home');
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? 'Ошибка входа')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Log In',
          style: TextStyle(
              color: Color(0xFFE2F163),
              fontFamily: 'Poppins',
              fontWeight: FontWeight.bold),
        ),
      ),
      backgroundColor: Color(0xFF141414),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 50),

              Text(
                'Welcome!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),

              Text(
                'Please log in to continue.',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontFamily: 'LeagueSpartan',
                  fontWeight: FontWeight.normal,
                ),
              ),

              const SizedBox(height: 20),

              // email textfield
              MyTextField(
                controller: _emailController,
                hintText: 'Email',
                keyboardType: TextInputType.emailAddress,
                validator: (value) => value?.isEmpty ?? true ? 'Введите email' : null,
              ),

              const SizedBox(height: 20),

              // pass textfield
              MyTextField(
                controller: _passwordController,
                hintText: 'Password',
                obscureText: true,
                validator: (value) => value?.isEmpty ?? true ? 'Введите пароль' : null,
              ),

              const SizedBox(height: 50),

              _isLoading
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                onPressed: _login,
                child: Text('Log In'),
              ),

              const SizedBox(height: 10),

              TextButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegisterPage()),
                ),
                child: Text('Sign Up'),
              ),

              TextButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ResetPasswordPage()),
                ),
                child: Text('Forgot password?'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}