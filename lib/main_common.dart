import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'data/repositories/booking/booking_repository.dart';
import 'data/repositories/booking/booking_repository_mock.dart';
import 'data/repositories/pass/pass_repository_mock.dart';
import 'data/repositories/stations/station_repository_mock.dart';
import 'ui/screens/booking/view_model/booking_view_model.dart';
import 'ui/screens/map/map_screen.dart';
import 'ui/screens/map/view_model/map_view_model.dart';
import 'ui/screens/pass/pass_screen.dart';
import 'ui/screens/pass/view_model/pass_view_model.dart';
import 'ui/screens/station/view_model/station_view_model.dart';
import 'ui/theme/theme.dart';

final _stationRepository = MockStationRepository();
final _bookingRepository = MockBookingRepository();
final _passRepository = MockPassRepository();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<BookingRepository>(create: (_) => _bookingRepository),
        ChangeNotifierProvider(
          create: (_) =>
              StationViewModel(stationRepository: _stationRepository),
        ),
        ChangeNotifierProvider(
          create: (_) => MapViewModel(stationRepository: _stationRepository),
        ),
        ChangeNotifierProvider(
          create: (_) => BookingViewModel(
            bookingRepository: _bookingRepository,
            stationRepository: _stationRepository,
            passRepository: _passRepository,
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => PassViewModel(passRepository: _passRepository),
        ),
      ],
      child: MaterialApp(
        title: 'City Bike Renting',
        theme: AppTheme.theme,
        debugShowCheckedModeBanner: false,
        home: const _RootScaffold(),
      ),
    );
  }
}

class _RootScaffold extends StatefulWidget {
  const _RootScaffold();

  @override
  State<_RootScaffold> createState() => _RootScaffoldState();
}

class _RootScaffoldState extends State<_RootScaffold> {
  int _currentIndex = 0;

  void _onTabTap(int index) {
    setState(() => _currentIndex = index);
    if (index == 1) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<PassViewModel>().loadActivePass();
      });
    }

    if (index == 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<MapViewModel>().loadStations();
      });
    }
  }

  final List<Widget> _screens = const [MapScreen(), PassScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTap,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.map_outlined),
            activeIcon: Icon(Icons.map),
            label: 'Map',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.card_membership_outlined),
            activeIcon: Icon(Icons.card_membership),
            label: 'Pass',
          ),
        ],
      ),
    );
  }
}