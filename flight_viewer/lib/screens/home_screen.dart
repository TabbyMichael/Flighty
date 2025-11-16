import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../blocs/flight/flight_bloc.dart';
import '../blocs/flight/flight_event.dart';
import '../blocs/flight/flight_state.dart';
import '../blocs/theme/theme_bloc.dart';
import '../blocs/theme/theme_event.dart';
import '../blocs/theme/theme_state.dart';
import '../utils/navigation_utils.dart';
import 'flight_detail_screen.dart';
import '../widgets/filter_bottom_sheet.dart';
import '../widgets/custom_loader.dart';
import '../models/flight.dart' as flight_model;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Load flights when the screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FlightBloc>().add(LoadFlights());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Flights',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        actions: [
          BlocBuilder<ThemeBloc, ThemeState>(
            builder: (context, themeState) {
              return IconButton(
                icon: Icon(
                  themeState is ThemeLoaded && themeState.themeMode == ThemeMode.dark
                      ? Icons.light_mode
                      : Icons.dark_mode,
                ),
                onPressed: () {
                  context.read<ThemeBloc>().add(ToggleTheme());
                },
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.filter_alt_outlined, size: 28),
            onPressed: () {
              _openFilterSheet(context);
            },
          ),
        ],
      ),
      body: BlocBuilder<FlightBloc, FlightState>(
        builder: (context, flightState) {
          if (flightState is FlightLoading) {
            return const Center(
              child: CustomLoader(
                message: 'Loading flights...',
                useIOSStyle: true,
              ),
            );
          }

          if (flightState is FlightError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 48),
                  const SizedBox(height: 16),
                  Text(
                    'Error loading flights: ${flightState.message}',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.read<FlightBloc>().add(LoadFlights()),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (flightState is FlightLoaded && flightState.flights.isEmpty) {
            return const Center(
              child: Text('No flights found'),
            );
          }

          if (flightState is FlightLoaded) {
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: flightState.flights.length,
              itemBuilder: (context, index) {
                final flight = flightState.flights[index];
                return _buildFlightCard(context, flight);
              },
            );
          }

          // Default state
          return const Center(
            child: CustomLoader(
              message: 'Loading flights...',
              useIOSStyle: true,
            ),
          );
        },
      ),
    );
  }

  void _openFlightDetails(BuildContext context, flight_model.Flight flight) {
    NavigationUtils.navigateWithDelay(
      context: context,
      page: FlightDetailScreen(flight: flight),
      message: 'Loading flight details...',
    );
  }

  Widget _buildFlightCard(BuildContext context, flight_model.Flight flight) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: Theme.of(context).dividerColor.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => _openFlightDetails(context, flight),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Airline and price row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.flight_takeoff,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${flight.airlineCode} ${flight.flightNumber}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            '${flight.airlineName} • ${flight.cabinClass}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Theme.of(context).hintColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '\$${flight.price.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF4CAF50),
                        ),
                      ),
                      const Text(
                        'per person',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Flight route and time
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        DateFormat('HH:mm').format(flight.departureTime),
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        flight.departureAirport,
                        style: TextStyle(
                          fontSize: 14,
                          color: Theme.of(context).hintColor,
                        ),
                      ),
                    ],
                  ),
                  // Flight duration and stops
                  Column(
                    children: [
                      Text(
                        '${(flight.duration / 60).floor()}h ${flight.duration % 60}m',
                        style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).hintColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        height: 1,
                        width: 80,
                        color: Colors.grey[300],
                        child: Row(
                          children: List.generate(10, (index) {
                            return Container(
                              width: 4,
                              height: 1,
                              color: Colors.white,
                              margin: const EdgeInsets.only(right: 4),
                            );
                          }),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${flight.stops} ${flight.stops == 1 ? 'stop' : 'stops'}' , 
                        style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).hintColor,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        DateFormat('HH:mm').format(flight.arrivalTime),
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        flight.arrivalAirport,
                        style: TextStyle(
                          fontSize: 14,
                          color: Theme.of(context).hintColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Book now button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    NavigationUtils.navigateWithDelay(
                      context: context,
                      page: FlightDetailScreen(flight: flight),
                      message: 'Loading flight details...',
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E88E5), // App's primary blue color
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text(
                    'Book Now',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openFilterSheet(BuildContext context) {
    final flightBloc = context.read<FlightBloc>();
    
    // Get current state
    if (flightBloc.state is FlightLoaded) {
      final flightState = flightBloc.state as FlightLoaded;
      final allAirlines = flightState.flights
          .map((f) => f.airlineName)
          .toSet()
          .toList();
      
      // Find min and max price from available flights
      double minPrice = 0;
      double maxPrice = 1000; // Default max price
      if (flightState.flights.isNotEmpty) {
        minPrice = flightState.flights
            .map((f) => f.price)
            .reduce((a, b) => a < b ? a : b);
        maxPrice = flightState.flights
            .map((f) => f.price)
            .reduce((a, b) => a > b ? a : b);
      }

      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => FilterBottomSheet(
          currentMaxPrice: flightState.currentMaxPrice ?? maxPrice,
          currentMaxStops: flightState.currentMaxStops ?? 3, // Default to 3 stops if null
          selectedAirlines: Set<String>.from(flightState.selectedAirlines),
          minPrice: minPrice,
          maxPrice: maxPrice,
          allAirlines: allAirlines,
          onApply: ({maxPrice, maxStops, airlines}) {
            flightBloc.add(ApplyFilters(
              maxPrice: maxPrice,
              maxStops: maxStops,
              airlineCodes: airlines,
            ));
          },
        ),
      );
    }
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }
}