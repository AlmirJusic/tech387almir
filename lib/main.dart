import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tech387almir/providers/auth_provider.dart';
import 'package:tech387almir/screens/auth_screen.dart';
import 'package:tech387almir/screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const String title = 'Tech387 App';

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => AuthProvider(),
        ),
      ],
      child: Consumer<AuthProvider>(
          builder: (ctx, auth, _) => MaterialApp(
                title: title,
                theme: ThemeData(
                  colorScheme:
                      ColorScheme.fromSwatch(primarySwatch: Colors.green)
                          .copyWith(secondary: Colors.white70),
                  scaffoldBackgroundColor: Colors.white,
                ),
                home: auth.isAuth ? HomeScreen() : const AuthScreen(),
              )),
    );
  }
}
