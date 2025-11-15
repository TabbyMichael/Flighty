import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../services/haptics_service.dart';
import 'theme_event.dart';
import 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  static const String _themeKey = 'app_theme';
  final HapticsService _hapticsService = HapticsService();

  ThemeBloc() : super(ThemeInitial()) {
    on<ToggleTheme>(_onToggleTheme);
    on<SetThemeMode>(_onSetThemeMode);
    on<LoadTheme>(_onLoadTheme);
    add(LoadTheme());
  }

  Future<void> _onLoadTheme(LoadTheme event, Emitter<ThemeState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    final themeString = prefs.getString(_themeKey) ?? 'system';
    
    ThemeMode themeMode;
    switch (themeString) {
      case 'light':
        themeMode = ThemeMode.light;
        break;
      case 'dark':
        themeMode = ThemeMode.dark;
        break;
      default:
        themeMode = ThemeMode.system;
    }
    
    // Emit the loaded theme state
    emit(ThemeLoaded(themeMode));
  }

  Future<void> _onToggleTheme(ToggleTheme event, Emitter<ThemeState> emit) async {
    if (state is ThemeLoaded) {
      final currentState = state as ThemeLoaded;
      final newThemeMode = currentState.themeMode == ThemeMode.dark 
          ? ThemeMode.light 
          : ThemeMode.dark;
      
      emit(ThemeLoaded(newThemeMode));
      
      // Save to shared preferences
      final prefs = await SharedPreferences.getInstance();
      final themeString = newThemeMode == ThemeMode.light ? 'light' : 'dark';
      await prefs.setString(_themeKey, themeString);
      
      _hapticsService.lightImpact();
    }
  }

  Future<void> _onSetThemeMode(SetThemeMode event, Emitter<ThemeState> emit) async {
    emit(ThemeLoaded(event.themeMode));
    
    // Save to shared preferences
    final prefs = await SharedPreferences.getInstance();
    String themeString;
    
    switch (event.themeMode) {
      case ThemeMode.light:
        themeString = 'light';
        break;
      case ThemeMode.dark:
        themeString = 'dark';
        break;
      default:
        themeString = 'system';
    }
    
    await prefs.setString(_themeKey, themeString);
  }
}