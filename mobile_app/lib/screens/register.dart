import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../services/validation_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _register() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final String username = _usernameController.text.trim();
    final String email = _emailController.text.trim();
    final String password = _passwordController.text.trim();

    // Validate username
    if (ValidationService.validateUsername(username) != null) {
      setState(() {
        _errorMessage = "Username is incorrect!";
        _isLoading = false;
      });
      return;
    }

    // Validate email
    if (ValidationService.validateEmail(email) != null) {
      setState(() {
        _errorMessage = "Email is incorrect!";
        _isLoading = false;
      });
      return;
    }

    // Validate password
    if (ValidationService.validatePassword(password) != null) {
      setState(() {
        _errorMessage = "Password is incorrect!";
        _isLoading = false;
      });
      return;
    }

    final response = await ApiService.register(username, email, password);

    if (response["success"]) {
      print("Registration successful!");
      Navigator.pop(context); // Redirect back to login
    } else {
      setState(() {
        _errorMessage = response["error"];
      });
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Register",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: "Username",
                  prefixIcon: const Icon(Icons.person),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  errorText: _errorMessage == "username" ? ValidationService.validateUsername(_usernameController.text) : null,
                ),
                onChanged: (value) {
                  setState(() {
                    _errorMessage = ValidationService.validateUsername(value) != null ? "username" : null;
                  });
                },
              ),
              const SizedBox(height: 15),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: "Email",
                  prefixIcon: const Icon(Icons.email),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  errorText: _errorMessage == "email" ? ValidationService.validateEmail(_emailController.text) : null,
                ),
                onChanged: (value) {
                  setState(() {
                    _errorMessage = ValidationService.validateEmail(value) != null ? "email" : null;
                  });
                },
              ),
              const SizedBox(height: 15),
              TextField(
                controller: _passwordController,
                obscureText: !_isPasswordVisible,
                decoration: InputDecoration(
                  labelText: "Password",
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  errorText: _errorMessage == "password" ? ValidationService.validatePassword(_passwordController.text) : null,
                ),
                onChanged: (value) {
                  setState(() {
                    _errorMessage = ValidationService.validatePassword(value) != null ? "password" : null;
                  });
                },
              ),
              const SizedBox(height: 20),
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                onPressed: _register,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text("Register"),
              ),
              if (_errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(
                    _errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
