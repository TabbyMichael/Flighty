import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/main_tab_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'blocs/flight/flight_bloc.dart';
import 'blocs/theme/theme_bloc.dart';
import 'blocs/theme/theme_state.dart';
import 'blocs/booking/booking_bloc.dart';
import 'blocs/extra_service/extra_service_bloc.dart';
import 'blocs/auth/auth_bloc.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<bool>? _firstRun;

  @override
  void initState() {
    super.initState();
    _firstRun = _checkFirstRun();
  }

  Future<bool> _checkFirstRun() async {
    final prefs = await SharedPreferences.getInstance();
    return !(prefs.getBool('onboarding_done') ?? false);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => FlightBloc()),
        BlocProvider(create: (_) => ThemeBloc()),
        BlocProvider(create: (_) => BookingBloc()),
        BlocProvider(create: (_) => ExtraServiceBloc()),
        BlocProvider(create: (_) => AuthBloc()..add(AppStarted())),
      ],
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, themeState) {
          return BlocBuilder<AuthBloc, AuthState>(
            builder: (context, authState) {
              return MaterialApp(
                title: 'SkyScan Flight Viewer',
                debugShowCheckedModeBanner: false,
                themeMode: themeState is ThemeLoaded ? themeState.themeMode : ThemeMode.system,
                theme: ThemeData(
                  colorScheme: ColorScheme.fromSeed(
                    seedColor: const Color(0xFF1E88E5),
                    primary: const Color(0xFF1E88E5),
                    secondary: const Color(0xFF64B5F6),
                    surface: Colors.white,
                    background: const Color(0xFFF5F5F5),
                  ),
                  textTheme: GoogleFonts.robotoTextTheme(
                    Theme.of(context).textTheme.copyWith(
                      displayLarge: const TextStyle(
                        fontSize: 28,  // Increased from 24
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      displayMedium: const TextStyle(
                        fontSize: 24,  // Increased from 20
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                      bodyLarge: const TextStyle(
                        fontSize: 18,  // Increased from 16
                        color: Colors.black,
                      ),
                      bodyMedium: const TextStyle(
                        fontSize: 16,  // Increased from 14
                        color: Colors.black,
                      ),
                      titleLarge: const TextStyle(
                        fontSize: 22,  // Increased from 18
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      labelLarge: const TextStyle(
                        fontSize: 18,  // Increased from 16
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  scaffoldBackgroundColor: const Color(0xFFF5F5F5),
                  appBarTheme: AppBarTheme(
                    elevation: 0,
                    centerTitle: true,
                    backgroundColor: Colors.white,
                    titleTextStyle: GoogleFonts.roboto(
                      color: Colors.black87,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    iconTheme: const IconThemeData(color: Colors.black87),
                  ),
                  inputDecorationTheme: InputDecorationTheme(
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                  elevatedButtonTheme: ElevatedButtonThemeData(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1E88E5),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                      textStyle: GoogleFonts.roboto(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                darkTheme: ThemeData.dark().copyWith(
                  colorScheme: const ColorScheme.dark(
                    primary: Color(0xFF90CAF9),
                    secondary: Color(0xFF64B5F6),
                    surface: Color(0xFF121212),
                    background: Color(0xFF121212),
                  ),
                  textTheme: GoogleFonts.robotoTextTheme(
                    Theme.of(context).textTheme.copyWith(
                      displayLarge: const TextStyle(
                        fontSize: 28,  // Increased from 24
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      displayMedium: const TextStyle(
                        fontSize: 24,  // Increased from 20
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                      bodyLarge: const TextStyle(
                        fontSize: 18,  // Increased from 16
                        color: Colors.white,
                      ),
                      bodyMedium: const TextStyle(
                        fontSize: 16,  // Increased from 14
                        color: Colors.white70,
                      ),
                      titleLarge: const TextStyle(
                        fontSize: 22,  // Increased from 18
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      labelLarge: const TextStyle(
                        fontSize: 18,  // Increased from 16
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  scaffoldBackgroundColor: const Color(0xFF121212),
                  appBarTheme: const AppBarTheme(
                    elevation: 0,
                    centerTitle: true,
                    backgroundColor: Color(0xFF1E1E1E),
                    titleTextStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    iconTheme: IconThemeData(color: Colors.white),
                  ),
                  inputDecorationTheme: InputDecorationTheme(
                    filled: true,
                    fillColor: const Color(0xFF2D2D2D),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                  elevatedButtonTheme: ElevatedButtonThemeData(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1E88E5),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                      textStyle: GoogleFonts.roboto(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  cardTheme: ThemeData.dark().cardTheme.copyWith(
                    color: const Color(0xFF1E1E1E),
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    margin: const EdgeInsets.all(8.0),
                  ),
                ),
                home: FutureBuilder<bool>(
                  future: _firstRun,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    
                    // Check if onboarding is needed
                    if (snapshot.data!) {
                      return const OnboardingScreen();
                    }
                    
                    // Check auth state
                    if (authState is Authenticated) {
                      return const MainTabScreen();
                    } else if (authState is Unauthenticated) {
                      return const LoginScreen();
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}