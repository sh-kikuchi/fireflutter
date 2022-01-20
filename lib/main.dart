import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //Firebaseの初期化
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyAuthPage(title: 'Authentication'),
    );
  }
}

class MyAuthPage extends StatefulWidget {
  const MyAuthPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyAuthPageState createState() => _MyAuthPageState();
}

class _MyAuthPageState extends State<MyAuthPage> {
  // メールとパスワードの入力欄
  String newEmail = "";
  String newPassword = "";
  // メールとパスワードの入力欄(ログイン)
  String email = "";
  String password = "";
  // 登録・ログインに関する情報を表示
  String info = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextFormField(
                decoration: const InputDecoration(labelText: "Mail Address"),
                onChanged: (String value) {
                  setState(() {
                    newEmail = value;
                  });
                }),
            const SizedBox(height: 8),
            TextFormField(
              decoration: const InputDecoration(
                  labelText: "Pass（more than 8 characters）"),
              obscureText: true,
              onChanged: (String value) {
                setState(() {
                  newPassword = value;
                });
              },
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () async {
                try {
                  //メールとパスワード登録
                  final FirebaseAuth auth = FirebaseAuth.instance;
                  final UserCredential result =
                      await auth.createUserWithEmailAndPassword(
                    email: newEmail,
                    password: newPassword,
                  );

                  //登録ユーザー情報
                  final User user = result.user!;
                  setState(() {
                    info = "Success：${user.email}";
                  });
                } catch (e) {
                  //登録に失敗
                  setState(() {
                    info = "Failed:${e.toString()}";
                  });
                }
              },
              child: const Text("Register"),
            ),
            const SizedBox(height: 32),
            TextFormField(
              decoration: InputDecoration(labelText: "Mail AdDress"),
              onChanged: (String value) {
                setState(() {
                  email = value;
                });
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: "Password"),
              obscureText: true,
              onChanged: (String value) {
                setState(() {
                  password = value;
                });
              },
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () async {
                try {
                  final FirebaseAuth auth = FirebaseAuth.instance;
                  final UserCredential result =
                      await auth.signInWithEmailAndPassword(
                          email: email, password: password);
                  // ログインに成功した場合
                  final User user = result.user!;
                  setState(() {
                    info = "Success：${user.email}";
                  });
                } catch (e) {
                  setState(() {
                    info = "Failed:${e.toString()}";
                  });
                }
              },
              child: Text("Login"),
            ),
            const SizedBox(height: 8),
            Text(info)
          ],
        ),
      ),
    );
  }
}
