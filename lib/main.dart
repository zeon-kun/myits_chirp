import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:wave/controllers/Authentication/auth_screen_controller.dart';
import 'package:wave/controllers/Authentication/user_controller.dart';
import 'package:wave/controllers/HomeNavController/home_nav_controller.dart';
import 'package:wave/controllers/PostController/create_post_controller.dart';
import 'package:wave/controllers/PostController/feed_post_controller.dart';
import 'package:wave/data/feed_provider.dart';
import 'package:wave/services/space_services.dart';
import 'package:wave/utils/routing.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

// Background message handler
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  "Handling a background message: ${message.messageId}".printInfo();
  if (message.notification != null) {
    'Message also contained a notification: ${message.notification}'
        .printError();
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  runApp(Wave());
}

class Wave extends StatelessWidget {
  const Wave({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AuthScreenController(),
        ),
        ChangeNotifierProvider(
          create: (context) => UserDataController(),
        ),
        ChangeNotifierProvider(
          create: (context) => HomeNavController(),
        ),
        ChangeNotifierProvider(
          create: (context) => CreatePostController(),
        ),
        ChangeNotifierProvider(
          create: (context) => FeedPostController(),
        ),
        ChangeNotifierProvider(
          create: (context) => StoryProvider(),
        ),
        Provider<SpaceService>(create: (_) => SpaceService()),
      ],
      child: GetMaterialApp(
        getPages: AppRoutes.routes,
        initialRoute: AppRoutes.splashScreen,
      ),
    );
  }
}
