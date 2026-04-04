import 'package:abc_money_diary/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  // 1. 플러터 엔진 초기화 (이미 잘 하셨습니다)
  WidgetsFlutterBinding.ensureInitialized();

  // 2. 한국어 날짜 데이터 초기화 (가계부 앱 필수!)
  await initializeDateFormatting('ko_KR', null);

  // 3. Supabase 초기화
  try {
    await Supabase.initialize(
      url: 'https://feiaheiknuhepqsyypcx.supabase.co',
      anonKey: 'sb_publishable_Ogb-J-IPyY4v2dsrURI9ag_Zhh7UZPC', // 키 보안 주의
    );
  } catch (e) {
    debugPrint('Supabase 초기화 실패: $e');
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return MaterialApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('ko', 'KR')
      ],

      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        bottomSheetTheme: BottomSheetThemeData(
          dragHandleColor: Colors.orange,
          dragHandleSize: Size(50, 5),

        ),

      ),
      home: HomeScreen(),
    );
  }
}
