import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_application_dmo1/pages/account_page.dart';
import 'package:flutter_application_dmo1/pages/login_page.dart';
import 'package:flutter_application_dmo1/pages/splash_page.dart';
import 'package:fluwx/fluwx.dart' as fluwx;


const gotrueUrl = 'https://cpeov0k8c94v6pnsqqg0.baseapi.test1.nimbleyun.com';
const annonToken = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoiYW5vbiIsImV4cCI6MzI5NDIwNzYxOCwiaWF0IjoxNzE3NDA3NjE4LCJpc3MiOiJzdXBhYmFzZSJ9.GaOmBgKmbBHVmit8WEHmOxnncDZV6JC3NVaCBhtVMAc';
Future<void> main() async {
 
  await Supabase.initialize(
    url: gotrueUrl,
    anonKey: annonToken,
  );
    fluwx.registerWxApi(
        appId: 'wxa08e26735ccfd912', //查看微信开放平台
        doOnAndroid: true,
        doOnIOS: true
        );

  runApp(MyApp());
}

final supabase = Supabase.instance.client;
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Supabase Flutter',
      theme: ThemeData.dark().copyWith(
        primaryColor: Colors.green,
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: Colors.green,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.green,
          ),
        ),
      ),
      initialRoute: '/',
      routes: <String, WidgetBuilder>{
        '/': (_) => const SplashPage(),
        '/login': (_) => const LoginPage(),
        '/account': (_) => const AccountPage(),
      },
    );
  }
}
