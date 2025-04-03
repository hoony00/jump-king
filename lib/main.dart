import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jump_adventure/screens/s_ready.dart';
import 'package:jump_adventure/services/local_storage.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();



  // 로컬 데이터베이스 초기화
  await LocalStorage.instance.init();

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jump Adventure',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const ReadyScreen(),
    );
  }
}
