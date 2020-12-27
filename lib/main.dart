import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'home_page.dart';

Future<void> main() async {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    _initFirebaseMessage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(),
    );
  }

  Future<void> buildUISnackBar(BuildContext context, String content) {
    final snackBar = SnackBar(
      content: Text(content),
      action: SnackBarAction(
        label: 'Check',
        onPressed: () => null,
      ),
    );
    Scaffold.of(context).showSnackBar(snackBar);
  }

  Future<void> buildUIDialog(
      BuildContext context, String title, String content) {
    showDialog(
      context: context,
      useRootNavigator: true,
      useSafeArea: true,
      builder: (context) => AlertDialog(
        content: ListTile(
          title: Text(title),
          subtitle: Text(content),
        ),
        actions: [
          FlatButton(
            child: Text('OK'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
      barrierDismissible: true,
    );
  }
}

Future<void> _initFirebaseMessage() async {
  await Firebase.initializeApp();
  await _requestPermission();
  // foreground
  FirebaseMessaging.onMessage.listen(_firebaseMessagingForegroundHandler);
  // background
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
}

// Requesting permission (Apple)#
Future<void> _requestPermission() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );
  print('🔥User granted permission: ${settings.authorizationStatus}');
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("🔥Handling a background message: ${message?.messageId}");
  print('🔥Message data: ${message?.data}');
  return Future<void>.value();
}

Future<void> _firebaseMessagingForegroundHandler(RemoteMessage message) async {
  print("🔥Handling a foreground message: ${message?.messageId}");
  print('🔥Message data: ${message?.data}');
  if (message.notification != null) {
    print('Message also contained a notification: ${message?.notification}');
    //buildUISnackBar(context, message?.notification?.title);
  }
}
