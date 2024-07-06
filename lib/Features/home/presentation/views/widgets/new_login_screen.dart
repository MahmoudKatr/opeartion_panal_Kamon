// new_login_screen.dart

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'choose_based_token.dart';
import 'login_cubit.dart';

class LoginScreenNew extends StatefulWidget {
  const LoginScreenNew({super.key});

  @override
  _LoginScreenNewState createState() => _LoginScreenNewState();
}

class _LoginScreenNewState extends State<LoginScreenNew> {
  bool _obscureText = true;
  bool _rememberMe = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double topPadding = MediaQuery.of(context).padding.top;

    // Define color constants for better theme management
    const Color primaryColor =
        Color.fromARGB(255, 66, 84, 147); // A soothing purple
    const Color secondaryColor =
        Color(0xFFf4f4f4); // Light grey for backgrounds
    const Color accentColor = Color(0xFF4caf50); // A fresh green for accents

    return BlocProvider(
      create: (context) => LoginCubit(Dio()),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: secondaryColor, // Use secondary color for background
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              constraints: BoxConstraints(minHeight: screenHeight - topPadding),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Welcome 👋',
                    style: TextStyle(
                      fontSize: 32.0,
                      fontWeight: FontWeight.bold,
                      color: primaryColor, // Use primary color for headings
                    ),
                    textAlign: TextAlign.left,
                  ),
                  const SizedBox(height: 10.0),
                  Text(
                    'Please enter your account details provided by HR',
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.grey[600], // Use a dark grey for subtitles
                    ),
                    textAlign: TextAlign.left,
                  ),
                  const SizedBox(height: 20.0),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'example@kamon.com',
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide: BorderSide(color: primaryColor),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide: BorderSide(color: primaryColor, width: 2.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide: BorderSide(color: primaryColor, width: 2.5),
                      ),
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 20.0),
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide: BorderSide(color: primaryColor),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide: BorderSide(color: primaryColor, width: 2.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide: BorderSide(color: primaryColor, width: 2.5),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(_obscureText
                            ? Icons.visibility_off
                            : Icons.visibility),
                        onPressed: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                      ),
                    ),
                    obscureText: _obscureText,
                  ),
                  const SizedBox(height: 8.0),
                  Row(
                    children: [
                      Checkbox(
                        value: _rememberMe,
                        onChanged: (bool? newValue) {
                          setState(() {
                            _rememberMe = newValue ?? false;
                          });
                        },
                        activeColor: accentColor,
                      ),
                      const Text('Remember Me'),
                      const Spacer(),
                      TextButton(
                        onPressed: () {},
                        child: const Text('Forgot Password?'),
                        style: TextButton.styleFrom(
                          foregroundColor: primaryColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  BlocConsumer<LoginCubit, LoginState>(
                    listener: (context, state) {
                      if (state is LoginSuccess) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => HomeBody()),
                        );
                      } else if (state is LoginFailure) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(state.failure.message)),
                        );
                      }
                    },
                    builder: (context, state) {
                      if (state is LoginLoading) {
                        return Center(child: CircularProgressIndicator());
                      }
                      return ElevatedButton(
                        onPressed: () {
                          final email = _emailController.text;
                          final password = _passwordController.text;
                          context.read<LoginCubit>().login(email, password);
                        },
                        child: const Text('Login'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          foregroundColor:
                              Colors.white, // Use white color for button text
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          minimumSize: const Size(
                              double.infinity, 50), // Full width button
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
