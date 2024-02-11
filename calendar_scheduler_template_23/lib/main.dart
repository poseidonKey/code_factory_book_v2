import 'package:calendar_scheduler/screen/auth_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
      url: 'https://hjzloqqqndrnyxbruptx.supabase.co',
      anonKey:
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImhqemxvcXFxbmRybnl4YnJ1cHR4Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MDc0Mzk4NDEsImV4cCI6MjAyMzAxNTg0MX0.ENrh7L6e4w1Jrw1oBtiIMmNqzaLEoEXKSmnqCfymXIk');

  await initializeDateFormatting();

  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AuthScreen(),
    ),
  );
}
