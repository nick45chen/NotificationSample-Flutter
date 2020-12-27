import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class MessageHandler extends StatefulWidget {
  final Widget body;

  const MessageHandler({Key key, this.body}) : super(key: key);

  @override
  _MessageHandlerState createState() => _MessageHandlerState();
}

class _MessageHandlerState extends State<MessageHandler> {
  @override
  void initState() {
    super.initState();
    _initFirebaseMessage();
  }

  @override
  Widget build(BuildContext context) {
    return widget.body;
  }

  Future<void> _initFirebaseMessage() async {
    await _requestIOSPermission();
    // foreground
    FirebaseMessaging.onMessage.listen(_firebaseMessagingForegroundHandler);
    // background
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  // Requesting permission (Apple)#
  Future<void> _requestIOSPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    print('🔥User granted permission: ${settings.authorizationStatus}');
  }

  Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    print("🔥Handling a background message: ${message?.messageId}");
    print('🔥Message data: ${message?.data}');
    return Future<void>.value();
  }

  Future<void> _firebaseMessagingForegroundHandler(
      RemoteMessage message) async {
    print("🔥Handling a foreground message: ${message?.messageId}");
    print('🔥Message data: ${message?.data}');
    if (message.notification != null) {
      print('Message also contained a notification: ${message?.notification}');
      buildUISnackBar(context, message?.notification?.title);
    }
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
