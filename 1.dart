
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const FirebaseInitApp());
}

class FirebaseInitApp extends StatelessWidget {
  const FirebaseInitApp({super.key});

  Future<bool> _initFirebase() async {
    await Firebase.initializeApp();
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Program 1: Firebase Connection'),
        ),
        body: Center(
          child: FutureBuilder<bool>(
            future: _initFirebase(),
            builder: (context, snapshot) {
              if (snapshot.connectionState ==
                  ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text(
                  'Connection Failed: ${snapshot.error}',
                  style: const TextStyle(color: Colors.red),
                );
              } else if (snapshot.data == true) {
                return const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.cloud_done,
                      color: Colors.green,
                      size: 72,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Firebase Connected',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ],
                );
              }

              return const Text('Initializing...');
            },
          ),
        ),
      ),
    );
  }
}
