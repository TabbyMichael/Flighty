# Flight Viewer

A Flutter flight booking application with backend integration.

## Getting Started

This project is a flight booking application built with Flutter. It integrates with a FastAPI backend for flight data, bookings, and user management.

## Features

- Flight search and booking
- User authentication
- Extra services selection
- Booking management
- Real-time flight tracking (planned)

## Backend Integration

This Flutter app integrates with a FastAPI backend that provides:

- Flight data from AviationStack API
- Booking management
- User authentication
- Webhook notifications
- Caching with Redis
- Background tasks with Celery

### Running with Backend

1. Start the backend server:
   ```bash
   cd ../flight_backend
   ./startup.sh
   ```

2. Update the API service URL in `lib/services/api_service.dart` if needed:
   ```dart
   static const String baseUrl = 'http://127.0.0.1:8000'; // For iOS simulator
   // static const String baseUrl = 'http://10.0.2.2:8000'; // For Android emulator
   ```

3. Run the Flutter app:
   ```bash
   flutter pub get
   flutter run
   ```

## Development

### Prerequisites

- Flutter SDK
- Dart SDK
- Backend server running (see backend README)

### Running Tests

```bash
flutter test
```

### Backend API Endpoints

- `GET /flights` - Fetch all flights
- `GET /flights/search` - Search flights by origin, destination, and date
- `GET /airlines` - Fetch all airlines
- `GET /bookings` - Fetch user bookings
- `POST /bookings` - Create a new booking

## Architecture

The app uses the Bloc pattern for state management and follows a clean architecture:

- `lib/blocs/` - Business logic components
- `lib/models/` - Data models
- `lib/screens/` - UI screens
- `lib/services/` - API services
- `lib/widgets/` - Reusable widgets

## Resources

- [Flutter documentation](https://docs.flutter.dev/)
- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)