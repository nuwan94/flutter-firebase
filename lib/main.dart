import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SE App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'SE App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String msg = 'Signin to continue.';
  FirebaseAuth auth;

  void initializeFlutterFire() async {
    try {
      await Firebase.initializeApp();
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    initializeFlutterFire();
    super.initState();
  }

  Future<void> login() async {
    try {
      auth = FirebaseAuth.instance;
      UserCredential res = await auth.signInAnonymously();
      setState(() {
        msg = "Last SignIn Time : " +
            res.user.metadata.lastSignInTime.toIso8601String() +
            '\n' +
            "User ID : " +
            res.user.uid;
      });
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<void> logout() async {
    try {
      auth = FirebaseAuth.instance;
      await auth.signOut();
      setState(() {
        msg = 'Signin to continue.';
      });
    } catch (e) {
      print(e);
      throw e;
    }
  }

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
            ButtonBar(
              alignment: MainAxisAlignment.center,
              children: <Widget>[
                RaisedButton(
                  onPressed: () async {
                    await login();
                  },
                  child: const Text('Signin', style: TextStyle(fontSize: 20)),
                ),
                RaisedButton(
                  onPressed: () async {
                    await logout();
                  },
                  child: const Text('Signout', style: TextStyle(fontSize: 20)),
                ),
              ],
            ),
            Text(
              msg,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
