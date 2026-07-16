import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lely_robot_dashboard/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:lely_robot_dashboard/features/dashboard/presentation/dashboard_page.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        backgroundColor: Colors.red[900],
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: context.read<AuthCubit>().formKey,
          child: Column(
            children: <Widget>[
              // Logo Section
              Padding(
                padding: const EdgeInsets.only(top: 40.0, bottom: 20.0),
                child: Center(
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(40),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(40),
                      child: Image.asset(
                        'assets/gfg.png',
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            Icons.person,
                            size: 60,
                            color: Colors.red[900],
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),

              // Input Fields and Buttons
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    // Email input field
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.0),
                      child: TextFormField(
                        autofocus: true,
                        autovalidateMode: .onUserInteraction,
                        controller: context
                            .read<AuthCubit>()
                            .usernameController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please Enter Your Username";
                          }
                          return null;
                        },
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          hintText: 'Email',
                          labelText: 'Email',
                          prefixIcon: Icon(Icons.email, color: Colors.red[900]),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(9.0),
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Password input field
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.0),
                      child: TextFormField(
                        autovalidateMode: .onUserInteraction,
                        controller: context
                            .read<AuthCubit>()
                            .passwordController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please Enter Your Password";
                          }
                          return null;
                        },
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: 'Password',
                          labelText: 'Password',
                          prefixIcon: Icon(Icons.key, color: Colors.red[900]),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(9.0),
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Forgot Password link
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: null, // Disabled
                        child: Text(
                          'Forgot Password?',
                          style: TextStyle(color: Colors.red[900]),
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    // Login button
                    BlocConsumer<AuthCubit, AuthState>(
                      listener: (context, state) {
                        if (state.hasError) {
                          SnackBar snackBar = SnackBar(
                            content: Text(state.error!),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }
                        if (state.hasData) {
                          SnackBar snackBar = SnackBar(
                            content: Text("Succesfull Operation"),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const DashboardPage(),
                            ),
                          );
                        }
                      },
                      builder: (context, state) {
                        return SizedBox(
                          height: 50,
                          width: MediaQuery.of(context).size.width,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red[900],
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(9.0),
                              ),
                            ),
                            onPressed: () {
                              context.read<AuthCubit>().login();
                            }, // Empty action
                            child: state.isLoading
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(),
                                  )
                                : const Text(
                                    'Login',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
