import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:lo_omas_app/screen/main/main_screen.dart';
import 'package:lo_omas_app/screen/history_screen/history_screen.dart';
import 'package:lo_omas_app/screen/current_screen/current_screen.dart';


import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  // FirebaseMessaging messaging = FirebaseMessaging.instance;

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // // Request notification permissions
  // NotificationSettings settings = await messaging.requestPermission(
  //   alert: true,
  //   badge: true,
  //   sound: true,
  // );

  // if (settings.authorizationStatus == AuthorizationStatus.authorized){
  //   // Permission granted, get the token
  //   String? token = await messaging.getToken();
  //   print('FCM Token: $token');

  //   // Use the token to send notifications to the device
  // } else {
  //   // Permission denied
  //   print('Permission denied');
  // }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      restorationScopeId: 'app',
      debugShowCheckedModeBanner: false,
      title: 'Lolo Omas\' Greenhouse Monitoring',
      theme: ThemeData(
        // UI
        primaryColor: const Color.fromRGBO(49, 54, 63, 1),

        // font
        textTheme: TextTheme(
          titleMedium: GoogleFonts.poppins(fontSize: 21, color: Colors.white),
          titleSmall: GoogleFonts.poppins(fontSize: 15,  color: Colors.white)
        )

      ),
      home: const DefaultTabController(
        length: 3, 
        child: MyHomePage(title: 'Greenhouse Monitoring')
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override 
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        bottom: const TabBar(
          tabs: [
            Tab(icon: Icon(Symbols.monitoring, color: Colors.white,)),
            Tab(icon: Icon(Symbols.view_timeline, color: Colors.white,)),
            Tab(icon: Icon(Symbols.history, color: Colors.white,))
          ],
        ),
        backgroundColor: Theme.of(context).primaryColor,

        leading: Icon(
          Symbols.potted_plant,
          color: Colors.green[400],
          ),

        title: RichText(
          text: TextSpan(
            children: <TextSpan>[
                TextSpan(text: 'Lolo Omas\'\n', style: Theme.of(context).textTheme.titleSmall),
                TextSpan(text: 'Greenhouse Monitoring', style: Theme.of(context).textTheme.titleSmall),
            ],
          ),
        ),

      ),
      body: const TabBarView(
        children: [
          MainScreen(),
          CurrentScreen(),
          HistoryScreen(restorationId: 'main'),
        ],
      ),
    );
  }
}
