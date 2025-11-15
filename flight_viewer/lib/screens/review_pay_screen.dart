import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/flight.dart';
import '../models/booking.dart';
import '../blocs/extra_service/extra_service_bloc.dart';
import '../blocs/extra_service/extra_service_event.dart';
import '../blocs/extra_service/extra_service_state.dart';
import '../blocs/booking/booking_bloc.dart';
import '../blocs/booking/booking_event.dart';
import '../blocs/booking/booking_state.dart';
import '../blocs/theme/theme_bloc.dart';
import '../blocs/theme/theme_event.dart';
import '../blocs/theme/theme_state.dart';
import '../widgets/custom_loader.dart';
import '../services/haptics_service.dart';
import 'receipt_screen.dart';
import '../models/receipt.dart';

class ReviewPayScreen extends StatelessWidget {
  final Flight flight;
  final double totalCost;
  final Map<String, int> selections;
  final String firstName;
  final String lastName;
  final String passport;
  final String email;

  const ReviewPayScreen({
    super.key,
    required this.flight,
    required this.totalCost,
    required this.selections,
    required this.firstName,
    required this.lastName,
    required this.passport,
    required this.email,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ExtraServiceBloc()..add(LoadServices())),
        BlocProvider(create: (_) => BookingBloc()),
      ],
      child: _ReviewPayBody(
        flight: flight,
        totalCost: totalCost,
        selections: selections,
        firstName: firstName,
        lastName: lastName,
        passport: passport,
        email: email,
      ),
    );
  }
}

class _ReviewPayBody extends StatelessWidget {
  final Flight flight;
  final double totalCost;
  final Map<String, int> selections;
  final String firstName;
  final String lastName;
  final String passport;
  final String email;
  late final HapticsService _hapticsService = HapticsService();

  _ReviewPayBody({
    required this.flight,
    required this.totalCost,
    required this.selections,
    required this.firstName,
    required this.lastName,
    required this.passport,
    required this.email,
  });

  @override
  Widget build(BuildContext context) {
    
    // Calculate extras cost (total - flight price)
    final extrasCost = totalCost - flight.price;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Review & Pay'),
        actions: [
          BlocBuilder<ThemeBloc, ThemeState>(
            builder: (context, themeState) {
              if (themeState is ThemeLoaded) {
                return IconButton(
                  icon: Icon(
                    themeState.themeMode == ThemeMode.dark
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
      body: BlocBuilder<ExtraServiceBloc, ExtraServiceState>(
        builder: (context, extraState) {
          return BlocBuilder<BookingBloc, BookingState>(
            builder: (context, bookingState) {
              // Calculate extras cost (total - flight price)
              final extrasCost = totalCost - flight.price;
              
              if ((extraState is ExtraServiceLoading) || (bookingState is BookingLoading)) {
                return const Center(
                  child: CustomLoader(
                    message: 'Processing...',
                    useIOSStyle: true,
                  ),
                );
              }
              
              if ((extraState is ExtraServiceError) || (bookingState is BookingError)) {
                return Center(child: Text('Error: ${(extraState as ExtraServiceError?)?.message ?? (bookingState as BookingError?)?.message}'));
              }
              
              if (extraState is ExtraServiceLoaded) {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Flight Details', style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 4),
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${flight.airlineName} (${flight.airlineCode}) ${flight.flightNumber}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text('${flight.departureAirport} → ${flight.arrivalAirport}'),
                              Text('Duration: ${_formatDuration(flight.duration)}'),
                              const SizedBox(height: 8),
                              Text(
                                '\$${flight.price.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 16),
                      Text('Passenger', style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 4),
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('$firstName $lastName'),
                              Text(passport),
                              Text(email),
                            ],
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 16),
                      Text('Extras', style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 8),
                      if (selections.isEmpty)
                        const Card(
                          child: Padding(
                            padding: EdgeInsets.all(16),
                            child: Text('No extras selected'),
                          ),
                        )
                      else
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              children: [
                                ..._buildSelectedExtrasList(extraState),
                                const Divider(height: 24),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Extras Total',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      '\$${extrasCost.toStringAsFixed(2)}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      
                      const Spacer(),
                      
                      // Price summary
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('Flight Price'),
                                  Text('\$${flight.price.toStringAsFixed(2)}'),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('Extras'),
                                  Text('\$${extrasCost.toStringAsFixed(2)}'),
                                ],
                              ),
                              const Divider(height: 24),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Total',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    '\$${totalCost.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: (bookingState is BookingLoading) ? null : () => _confirmBooking(context),
                          child: (bookingState is BookingLoading)
                              ? const CustomLoader(
                                  message: 'Confirming booking...',
                                  useIOSStyle: true,
                                )
                              : const Text('Pay & Confirm'),
                        ),
                      ),
                    ],
                  ),
                );
              }
              
              // Default return for other states
              return const Center(
                child: CustomLoader(
                  message: 'Loading...',
                  useIOSStyle: true,
                ),
              );
            },
          );
        },
      )
    );
  }
  
  List<Widget> _buildSelectedExtrasList(ExtraServiceLoaded state) {
    final List<Widget> items = [];
    
    selections.forEach((id, qty) {
      if (qty > 0) {
        final service = state.getServiceById(id);
        if (service != null) {
          items.add(
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          service.name,
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                        Text(
                          service.description,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text('x$qty'),
                  Text('\$${(service.price * qty).toStringAsFixed(2)}'),
                ],
              ),
            ),
          );
        } else {
          // Fallback for services not found
          items.add(
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Service $id'),
                  Text('x$qty'),
                  // We can't calculate price without the service object
                ],
              ),
            ),
          );
        }
      }
    });
    
    return items;
  }
  
  String _formatDuration(int minutes) {
    final hours = minutes ~/ 60;
    final mins = minutes % 60;
    if (hours > 0) {
      return '${hours}h ${mins}m';
    } else {
      return '${mins}m';
    }
  }
  
  void _confirmBooking(BuildContext context) async {
    final bookingBloc = context.read<BookingBloc>();
    
    try {
      // Trigger haptic feedback when booking begins
      _hapticsService.selection();
      
      bookingBloc.add(CreateBooking(
        flightId: flight.id,
        firstName: firstName,
        lastName: lastName,
        passport: passport,
        email: email,
        extras: selections,
        totalCost: totalCost,
      ));
      
      // We'll handle the success case in the BlocListener
      // For now, we'll just show a loading indicator
      _hapticsService.success();
      
      // The navigation will be handled by listening to the bloc state
    } catch (e) {
      // Trigger error haptic feedback
      _hapticsService.error();
      
      // Show error dialog
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Error'),
          content: Text('Failed to create booking: $e'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK'),
            )
          ],
        ),
      );
    }
  }
}