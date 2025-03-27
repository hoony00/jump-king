import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:jump_adventure/screens/game_screen.dart';
import 'package:jump_adventure/services/local_db_service.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Firebase 초기화
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,  
  ); 
    
  // Hive 초기화 
  await Hive.initFlutter();
  
  // 로컬 DB 서비스 초기화  
  final localDBService = LocalDBService();  
  await localDBService.init();
   
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
      home: const GameScreen(),
    );
  }
}
