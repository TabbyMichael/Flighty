import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../widgets/custom_loader.dart';
import '../../services/haptics_service.dart';
import '../../blocs/theme/theme_bloc.dart';
import '../../blocs/theme/theme_state.dart';
import '../../blocs/theme/theme_event.dart';

class LoadingScreen extends StatefulWidget {
  final String message;

  const LoadingScreen({super.key, this.message = 'Loading...'});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  final HapticsService _hapticsService = HapticsService();

  @override
  void initState() {
    super.initState();
    // Trigger a light haptic feedback when loading starts
    _hapticsService.lightImpact();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          BlocBuilder<ThemeBloc, ThemeState>(
            builder: (context, state) {
              if (state is ThemeLoaded) {
                return IconButton(
                  icon: Icon(
                    state.themeMode == ThemeMode.dark
                        ? Icons.light_mode
                        : Icons.dark_mode,
                  ),
                  onPressed: () {
                    context.read<ThemeBloc>().add(ToggleTheme());
                  },
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: Center(
        child: CustomLoader(
          message: widget.message,
          useIOSStyle: true,
        ),
      ),
    );
  }
}