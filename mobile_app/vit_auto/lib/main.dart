import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import 'firebase_options.dart';
import 'utils/app_theme.dart';

import 'screens/splash_screen.dart';
import 'screens/signin_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/poll_screen.dart';
import 'screens/chat_screen.dart';
import 'screens/support_ai_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // ✅ Web: keep user logged-in even after refresh
  if (kIsWeb) {
    await FirebaseAuth.instance.setPersistence(Persistence.LOCAL);
  }

  runApp(const VITAutoApp());
}

class VITAutoApp extends StatelessWidget {
  const VITAutoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VIT Auto',
      theme: AppTheme.theme(),
      debugShowCheckedModeBanner: false,
      initialRoute: SplashScreen.route,
      routes: {
        SplashScreen.route: (_) => const SplashScreen(),
        SignInScreen.route: (_) => const SignInScreen(),
        ProfileScreen.route: (_) => const ProfileScreen(),
        PollScreen.route: (_) => const PollScreen(),
        ChatScreen.route: (_) => const ChatScreen(),
        SupportAiScreen.route: (_) => const SupportAiScreen(),
      },
    );
  }
}