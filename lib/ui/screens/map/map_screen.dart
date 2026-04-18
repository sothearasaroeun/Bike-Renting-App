import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import '../../theme/theme.dart';
import '../station/station_screen.dart';
import '../station/view_model/station_view_model.dart';
import 'view_model/map_view_model.dart';
import '../../states/map_state.dart';
import 'widgets/station_marker.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController _mapController = MapController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MapViewModel>().loadStations();
    });
  }

  void _openStation(BuildContext context, station) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => StationScreen(station: station)),
    );
    
    if (mounted) {
      context.read<MapViewModel>().loadStations();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Consumer<MapViewModel>(
            builder: (context, vm, _) {
              return FlutterMap(
                mapController: _mapController,
                options: const MapOptions(
                  initialCenter: LatLng(11.5625, 104.9160),
                  initialZoom: 14.5,
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.example.final_project',
                  ),
                  if (vm.state is MapLoaded)
                    MarkerLayer(
                      markers: vm.stations.map((station) {
                        return Marker(
                          point: LatLng(station.latitude, station.longitude),
                          width: 60,
                          height: 70,
                          child: StationMarker(
                            station: station,
                            onTap: () => _openStation(context, station),
                          ),
                        );
                      }).toList(),
                    ),
                ],
              );
            },
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top + 12,
            left: 16,
            right: 16,
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.cardShadow,
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Row(
                children: [
                  SizedBox(width: AppSpacing.md),
                  Icon(Icons.search, color: AppColors.textHint, size: 20),
                  SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      'Search for bike stations...',
                      style: TextStyle(color: AppColors.textHint, fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Consumer<MapViewModel>(
            builder: (context, vm, _) {
              if (vm.state is MapLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (vm.state is MapError) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        (vm.state as MapError).message,
                        style: AppTextStyles.bodySecondary,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      ElevatedButton(
                        onPressed: vm.loadStations,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }
}