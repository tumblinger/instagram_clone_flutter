import 'package:flutter/material.dart';
import 'package:instagram_clone/app_routes.dart';
import 'package:instagram_clone/auth/auth_service.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthService _authService = AuthService();
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              const Text("Home Screen!!!",
                style: TextStyle(fontSize: 24),),
              ElevatedButton(onPressed: (){
                _authService.logout();
                Navigator.pushReplacementNamed(context, AppRoutes.login);
                print('Log Out');
              }, child: const Text('Logout'),),
            ],
          ),
        ),
      ),
    );
  }
}
