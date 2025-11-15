import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/booking.dart';
import '../blocs/booking/booking_bloc.dart';
import '../blocs/booking/booking_state.dart';
import '../blocs/booking/booking_event.dart';
import '../blocs/theme/theme_bloc.dart';
import '../blocs/theme/theme_state.dart';
import '../blocs/theme/theme_event.dart';
import '../widgets/custom_loader.dart';

class MyBookingsScreen extends StatefulWidget {
  const MyBookingsScreen({super.key});

  @override
  State<MyBookingsScreen> createState() => _MyBookingsScreenState();
}

class _MyBookingsScreenState extends State<MyBookingsScreen> {
  final _emailController = TextEditingController(text: 'user@example.com');

  @override
  void initState() {
    super.initState();
    // Fetch bookings when the screen is first loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchBookings();
    });
  }

  Future<void> _fetchBookings() async {
    final bookingBloc = context.read<BookingBloc>();
    bookingBloc.add(LoadBookings(_emailController.text));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Bookings'),
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
      body: BlocBuilder<BookingBloc, BookingState>(
        builder: (context, bookingState) {
          if (bookingState is BookingLoading) {
            return const Center(
              child: CustomLoader(
                message: 'Loading bookings...',
                useIOSStyle: true,
              ),
            );
          }

          if (bookingState is BookingError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error, size: 60, color: Colors.red),
                  const SizedBox(height: 16),
                  const Text('Failed to load bookings'),
                  const SizedBox(height: 8),
                  Text(bookingState.message, 
                       style: const TextStyle(color: Colors.grey)),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _fetchBookings,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (bookingState is BookingLoaded && bookingState.bookings.isEmpty) {
            return _buildEmptyState();
          }

          if (bookingState is BookingLoaded) {
            return _buildBookingsList(bookingState.bookings);
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.travel_explore, size: 80, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          const Text('No bookings yet', style: TextStyle(fontSize: 18)),
          const SizedBox(height: 8),
          const Text('Your confirmed trips will appear here.'),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _fetchBookings,
            child: const Text('Refresh'),
          ),
        ],
      ),
    );
  }

  Widget _buildBookingsList(List<Booking> bookings) {
    return RefreshIndicator(
      onRefresh: _refreshBookings,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: bookings.length,
        itemBuilder: (context, index) {
          final booking = bookings[index];
          return _BookingCard(booking: booking);
        },
      ),
    );
  }

  Future<void> _refreshBookings() async {
    final bookingBloc = context.read<BookingBloc>();
    bookingBloc.add(LoadBookings('user@example.com'));
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }
}

class _BookingCard extends StatelessWidget {
  final Booking booking;

  const _BookingCard({required this.booking});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Flight info header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  booking.flightId,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'Confirmed',
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            // Passenger info
            Row(
              children: [
                const Icon(Icons.person, size: 16, color: Colors.grey),
                const SizedBox(width: 8),
                const Text('Passenger'),
              ],
            ),
            const SizedBox(height: 4),
            Text('${booking.firstName} ${booking.lastName}'),
            
            const SizedBox(height: 8),
            
            // Price info
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Total'),
                Text(
                  '\$${booking.totalCost.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            // Booking date
            Text(
              'Booked on ${_formatDate(booking.createdAt)}',
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}