import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gotrue_wechatlogin/gotrue.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_application_dmo1/main.dart';
import 'package:fluwx/fluwx.dart' as fluwx;

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginPageState createState() => _LoginPageState();
  
}

class _LoginPageState extends State<LoginPage> {
  String? _userId;
  String? _code;
  String? _userId__;
  @override
  void initState() {
    super.initState();
    loginWxHandler(); // 在 initState 中调用微信登录结果监听方法
  }

  late final StreamSubscription _authStateSubscription;


  // 微信登录结果监听方法
  void loginWxHandler() async {
    fluwx.weChatResponseEventHandler.listen((response) async {
      if (response is fluwx.WeChatAuthResponse) {
        if (response.code != null) {
          print('wxLogin--code:${response.code}');
          final String nonNullableCode = response.code ?? ""; // 如果response.code为空，则使用空字符串代替
          setState(() {
            _code = response.code ?? "";
          });
            final auth = GoTrueClient(
              url: "https://cpeov0k8c94v6pnsqqg0.baseapi.test1.nimbleyun.com",
              headers: {
                'Authorization': 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoiYW5vbiIsImV4cCI6MzI5NDIwNzYxOCwiaWF0IjoxNzE3NDA3NjE4LCJpc3MiOiJzdXBhYmFzZSJ9.GaOmBgKmbBHVmit8WEHmOxnncDZV6JC3NVaCBhtVMAc',
                'apikey': 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoiYW5vbiIsImV4cCI6MzI5NDIwNzYxOCwiaWF0IjoxNzE3NDA3NjE4LCJpc3MiOiJzdXBhYmFzZSJ9.GaOmBgKmbBHVmit8WEHmOxnncDZV6JC3NVaCBhtVMAc',
              },
            );
          final res = await auth.signInWithWechat(code: nonNullableCode);
          setState(() {
            _userId__ = res.user?.id;
          });
          
          final session = res.session;
          final user = res.user;
        } else {
          print('wx------------e$response');
          // print('wxLogin--code:${event.code}');
        }
      }else{
        print('未安装微信');
      }
    });
  }

  @override
  void dispose() {
    _authStateSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("登录")),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(_code != null ? "code为:${_code} ;用户id为:${_userId__}": "还没登录"),
            FutureBuilder<bool>(
              future: fluwx.isWeChatInstalled,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();  // 等待异步任务完成
                } else if (snapshot.hasError) {
                  return Text("错误提示Error: ${snapshot.error}");
                } else if (snapshot.hasData && snapshot.data!) {
                  // 如果安装了微信，显示微信登录按钮
                  return ElevatedButton(
                    onPressed: () async {
                      bool exist = await fluwx.isWeChatInstalled;
                      if (exist) {
                        fluwx.sendWeChatAuth(
                          scope: "snsapi_userinfo",
                          state: "wechat_sdk_demo_test",
                        );
                      }
                    },
                    child: const Text("微信登录"),
                  );
                } else {
                  // 如果没有安装微信
                  return const Text("没有安装微信，系统不显示按钮");
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}