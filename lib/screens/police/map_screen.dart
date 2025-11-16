import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../theme/app_colors.dart';
import '../../widgets/police_drawer.dart';

class PoliceMapScreen extends StatefulWidget {
  const PoliceMapScreen({super.key});

  @override
  State<PoliceMapScreen> createState() => _PoliceMapScreenState();
}

class _PoliceMapScreenState extends State<PoliceMapScreen> {
  final MapController _mapController = MapController();
  static const LatLng _initialCenter = LatLng(23.8103, 90.4125);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Live Map View'),
        backgroundColor: AppColors.primary,
      ),
      drawer: const PoliceDrawer(),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: const MapOptions(
              initialCenter: _initialCenter,
              initialZoom: 12.0,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                subdomains: const ['a', 'b', 'c'],
              ),
              MarkerLayer(
                markers: [
                  _buildMarker(
                    point: const LatLng(23.8103, 90.4125),
                    icon: Icons.local_police_outlined,
                    color: AppColors.error,
                    label: 'Unit 7B - High Alert',
                    isPulsing: true,
                  ),
                  _buildMarker(
                    point: const LatLng(23.777176, 90.399452),
                    icon: Icons.store,
                    color: AppColors.accentShopOwner,
                    label: 'Sabbir\'s Electronics',
                  ),
                  _buildMarker(
                    point: const LatLng(23.85, 90.42),
                    icon: Icons.store,
                    color: AppColors.accentShopOwner,
                    label: 'Green Grocers',
                  ),
                  _buildMarker(
                    point: const LatLng(23.79, 90.40),
                    icon: Icons.store,
                    color: AppColors.accentShopOwner,
                    label: 'Bookworm Corner',
                  ),
                  _buildMarker(
                    point: const LatLng(23.83, 90.39),
                    icon: Icons.store,
                    color: AppColors.accentShopOwner,
                    label: 'The Gadget Hub',
                  ),
                  _buildMarker(
                    point: const LatLng(23.75, 90.43),
                    icon: Icons.local_police,
                    color: AppColors.primary,
                    label: 'Unit 2A - On Patrol',
                  ),
                ],
              ),
            ],
          ),
          _buildMapControls(),
        ],
      ),
    );
  }

  Marker _buildMarker({
    required LatLng point,
    required IconData icon,
    required Color color,
    required String label,
    bool isPulsing = false,
  }) {
    final markerIcon = InkWell(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(label), duration: const Duration(seconds: 2)),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 8, spreadRadius: 2)],
        ),
        child: Icon(icon, color: Colors.white, size: 24),
      ),
    );

    return Marker(
      width: isPulsing ? 120.0 : 80.0, // Larger tap area for pulsing marker
      height: isPulsing ? 120.0 : 80.0,
      point: point,
      child: isPulsing
          ? markerIcon.animate(onComplete: (controller) => controller.repeat()).scaleXY(end: 1.2, duration: 1.seconds).then().scaleXY(end: 1 / 1.2, duration: 1.seconds)
          : markerIcon,
    );
  }

  Widget _buildMapControls() {
    return Positioned(
      bottom: 24,
      right: 16,
      child: Column(
        children: [
          FloatingActionButton(
            heroTag: 'zoomIn',
            mini: true,
            onPressed: () => _mapController.move(_mapController.camera.center, _mapController.camera.zoom + 1),
            child: const Icon(Icons.add),
          ),
          const SizedBox(height: 8),
          FloatingActionButton(
            heroTag: 'zoomOut',
            mini: true,
            onPressed: () => _mapController.move(_mapController.camera.center, _mapController.camera.zoom - 1),
            child: const Icon(Icons.remove),
          ),
          const SizedBox(height: 16),
          FloatingActionButton(
            heroTag: 'recenter',
            onPressed: () => _mapController.move(_initialCenter, 12.0),
            child: const Icon(Icons.my_location),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 500.ms);
  }
}
