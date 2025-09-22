import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/connection_status_widget.dart';
import './widgets/delivery_status_widget.dart';
import './widgets/drone_info_widget.dart';
import './widgets/map_controls_widget.dart';
import './widgets/order_summary_widget.dart';
import './widgets/pickup_code_widget.dart';

class LiveTrackingScreen extends StatefulWidget {
  const LiveTrackingScreen({super.key});

  @override
  State<LiveTrackingScreen> createState() => _LiveTrackingScreenState();
}

class _LiveTrackingScreenState extends State<LiveTrackingScreen>
    with TickerProviderStateMixin {
  GoogleMapController? _mapController;
  Timer? _trackingTimer;
  Timer? _statusTimer;

  // Animation controllers
  late AnimationController _droneAnimationController;
  late AnimationController _bottomSheetController;

  // Map state
  MapType _currentMapType = MapType.normal;
  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};

  // Location state
  LatLng _userLocation = const LatLng(40.7128, -74.0060); // New York default
  LatLng _restaurantLocation = const LatLng(40.7589, -73.9851); // Times Square
  LatLng _droneLocation = const LatLng(40.7589, -73.9851);
  double _droneRotation = 0.0;

  // Connection state
  bool _isOnline = true;
  bool _hasGpsSignal = true;
  DateTime? _lastUpdate;

  // Order state
  String _currentStatus = 'In Transit';
  DateTime _estimatedArrival = DateTime.now().add(const Duration(minutes: 15));
  String _orderId =
      'RV${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}';
  String _pickupCode = 'RV${Random().nextInt(9999).toString().padLeft(4, '0')}';

  // Drone info
  final String _droneId =
      'RV-${Random().nextInt(999).toString().padLeft(3, '0')}';
  double _altitude = 150.0;
  double _speed = 25.0;
  double _batteryLevel = 78.0;
  final String _pilotName = 'Sarah Chen';

  // Bottom sheet
  final DraggableScrollableController _bottomSheetScrollController =
      DraggableScrollableController();
  bool _isBottomSheetExpanded = false;

  // Mock order data
  final Map<String, dynamic> _orderData = {
    "restaurant": {
      "name": "Bella Vista Italian",
      "address": "123 Broadway, New York, NY 10001",
      "image":
          "https://images.unsplash.com/photo-1555396273-367ea4eb4db5?w=400&h=300&fit=crop"
    },
    "items": [
      {"name": "Margherita Pizza", "quantity": 1, "price": "\$18.99"},
      {"name": "Caesar Salad", "quantity": 1, "price": "\$12.99"},
      {"name": "Tiramisu", "quantity": 2, "price": "\$16.98"}
    ],
    "total": "\$52.96"
  };

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _initializeLocation();
    _startTracking();
    _createMarkers();
    _createRoute();
    _lastUpdate = DateTime.now();
  }

  @override
  void dispose() {
    _trackingTimer?.cancel();
    _statusTimer?.cancel();
    _droneAnimationController.dispose();
    _bottomSheetController.dispose();
    _bottomSheetScrollController.dispose();
    super.dispose();
  }

  void _initializeAnimations() {
    _droneAnimationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _bottomSheetController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  Future<void> _initializeLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() => _hasGpsSignal = false);
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() => _hasGpsSignal = false);
          return;
        }
      }

      Position position = await Geolocator.getCurrentPosition();
      setState(() {
        _userLocation = LatLng(position.latitude, position.longitude);
        _hasGpsSignal = true;
      });

      _createMarkers();
    } catch (e) {
      setState(() => _hasGpsSignal = false);
    }
  }

  void _startTracking() {
    // Update drone position every 10 seconds
    _trackingTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
      _updateDronePosition();
      _updateDroneInfo();
      setState(() => _lastUpdate = DateTime.now());
    });

    // Update status occasionally
    _statusTimer = Timer.periodic(const Duration(minutes: 2), (timer) {
      _updateDeliveryStatus();
    });
  }

  void _updateDronePosition() {
    if (!_isOnline || !_hasGpsSignal) return;

    // Simulate drone movement towards user
    final random = Random();
    final latDiff = (_userLocation.latitude - _droneLocation.latitude) * 0.1;
    final lngDiff = (_userLocation.longitude - _droneLocation.longitude) * 0.1;

    setState(() {
      _droneLocation = LatLng(
        _droneLocation.latitude + latDiff + (random.nextDouble() - 0.5) * 0.001,
        _droneLocation.longitude +
            lngDiff +
            (random.nextDouble() - 0.5) * 0.001,
      );

      // Update rotation based on movement direction
      _droneRotation = _calculateBearing(_droneLocation, _userLocation);

      // Update altitude and speed with some variation
      _altitude = 120 + random.nextDouble() * 60;
      _speed = 20 + random.nextDouble() * 15;
      _batteryLevel = max(20, _batteryLevel - random.nextDouble() * 2);
    });

    _createMarkers();
    _createRoute();
  }

  void _updateDroneInfo() {
    final random = Random();
    setState(() {
      _altitude = 120 + random.nextDouble() * 60;
      _speed = 20 + random.nextDouble() * 15;
      _batteryLevel = max(20, _batteryLevel - random.nextDouble() * 0.5);
    });
  }

  void _updateDeliveryStatus() {
    final statuses = [
      'Order Confirmed',
      'Preparing',
      'Drone Dispatched',
      'In Transit',
      'Approaching',
      'Delivered'
    ];

    final currentIndex = statuses.indexOf(_currentStatus);
    if (currentIndex < statuses.length - 1) {
      setState(() {
        _currentStatus = statuses[currentIndex + 1];
        _estimatedArrival = DateTime.now().add(
          Duration(minutes: (statuses.length - currentIndex - 1) * 5),
        );
      });

      // Trigger haptic feedback
      HapticFeedback.lightImpact();

      // Show status update
      _showStatusUpdate();
    }
  }

  void _showStatusUpdate() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            CustomIconWidget(
              iconName: 'check_circle',
              color: AppTheme.successGreen,
              size: 20,
            ),
            SizedBox(width: 2.w),
            Text('Status updated: $_currentStatus'),
          ],
        ),
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  double _calculateBearing(LatLng start, LatLng end) {
    final lat1 = start.latitude * pi / 180;
    final lat2 = end.latitude * pi / 180;
    final deltaLng = (end.longitude - start.longitude) * pi / 180;

    final y = sin(deltaLng) * cos(lat2);
    final x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(deltaLng);

    return (atan2(y, x) * 180 / pi + 360) % 360;
  }

  void _createMarkers() {
    _markers = {
      Marker(
        markerId: const MarkerId('user'),
        position: _userLocation,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        infoWindow: const InfoWindow(title: 'Your Location'),
      ),
      Marker(
        markerId: const MarkerId('restaurant'),
        position: _restaurantLocation,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
        infoWindow: InfoWindow(
          title: _orderData['restaurant']['name'] as String,
          snippet: 'Restaurant',
        ),
      ),
      Marker(
        markerId: const MarkerId('drone'),
        position: _droneLocation,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
        rotation: _droneRotation,
        infoWindow: InfoWindow(
          title: 'Drone $_droneId',
          snippet: 'Altitude: ${_altitude.toInt()} ft',
        ),
      ),
    };
  }

  void _createRoute() {
    _polylines = {
      Polyline(
        polylineId: const PolylineId('route'),
        points: [_restaurantLocation, _droneLocation, _userLocation],
        color: AppTheme.accentYellow,
        width: 3,
        patterns: [PatternItem.dash(20), PatternItem.gap(10)],
      ),
    };
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    _centerMapOnDrone();
  }

  void _centerMapOnDrone() {
    if (_mapController != null) {
      _mapController!.animateCamera(
        CameraUpdate.newLatLngZoom(_droneLocation, 14.0),
      );
    }
  }

  void _zoomIn() {
    _mapController?.animateCamera(CameraUpdate.zoomIn());
  }

  void _zoomOut() {
    _mapController?.animateCamera(CameraUpdate.zoomOut());
  }

  void _toggleMapType() {
    setState(() {
      _currentMapType = _currentMapType == MapType.normal
          ? MapType.satellite
          : MapType.normal;
    });
  }

  void _contactRestaurant() {
    // Navigate to chat screen (would be implemented)
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Opening chat with restaurant...'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _shareLocation() {
    final message =
        'Track my order: Order #$_orderId - Pickup Code: $_pickupCode';
    Clipboard.setData(ClipboardData(text: message));

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Order details copied to clipboard'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _generateQRCode() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('QR Code'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: AppTheme.neutralGray,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomIconWidget(
                      iconName: 'qr_code',
                      color: AppTheme.primaryBlack,
                      size: 100,
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      _pickupCode,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                            fontFamily: 'monospace',
                          ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              'Show this QR code to the delivery drone',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _emergencyContact() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            CustomIconWidget(
              iconName: 'emergency',
              color: AppTheme.errorRed,
              size: 24,
            ),
            SizedBox(width: 2.w),
            const Text('Emergency Contact'),
          ],
        ),
        content: const Text(
          'Are you experiencing an emergency with your delivery? This will immediately connect you with our support team.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Connecting to emergency support...'),
                  backgroundColor: AppTheme.errorRed,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorRed,
              foregroundColor: AppTheme.surfaceWhite,
            ),
            child: const Text('Contact Support'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: const Text('Live Tracking'),
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        leading: IconButton(
          icon: CustomIconWidget(
            iconName: 'arrow_back_ios',
            color: colorScheme.onSurface,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: CustomIconWidget(
              iconName: 'info_outline',
              color: colorScheme.onSurface,
              size: 24,
            ),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context) => Container(
                  height: 70.h,
                  decoration: BoxDecoration(
                    color: colorScheme.surface,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(4.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Container(
                            width: 10.w,
                            height: 0.5.h,
                            decoration: BoxDecoration(
                              color: AppTheme.neutralGray,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                        SizedBox(height: 3.h),
                        OrderSummaryWidget(
                          orderData: _orderData,
                          onContactRestaurant: _contactRestaurant,
                          onShareLocation: _shareLocation,
                        ),
                        SizedBox(height: 2.h),
                        DroneInfoWidget(
                          droneId: _droneId,
                          altitude: _altitude,
                          speed: _speed,
                          batteryLevel: _batteryLevel,
                          pilotName: _pilotName,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          // Google Map
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: _droneLocation,
              zoom: 14.0,
            ),
            mapType: _currentMapType,
            markers: _markers,
            polylines: _polylines,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            compassEnabled: true,
            trafficEnabled: false,
            buildingsEnabled: true,
            onTap: (position) {
              // Hide bottom sheet when map is tapped
              if (_isBottomSheetExpanded) {
                _bottomSheetScrollController.animateTo(
                  0.3,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              }
            },
          ),

          // Connection status overlay
          ConnectionStatusWidget(
            isOnline: _isOnline,
            hasGpsSignal: _hasGpsSignal,
            lastUpdate: _lastUpdate,
          ),

          // Map controls
          MapControlsWidget(
            onZoomIn: _zoomIn,
            onZoomOut: _zoomOut,
            onCenterOnDrone: _centerMapOnDrone,
            onToggleMapType: _toggleMapType,
            onEmergencyContact: _emergencyContact,
            isSatelliteView: _currentMapType == MapType.satellite,
          ),

          // Bottom sheet with order details
          DraggableScrollableSheet(
            controller: _bottomSheetScrollController,
            initialChildSize: 0.3,
            minChildSize: 0.2,
            maxChildSize: 0.8,
            builder: (context, scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.shadowSubtle,
                      blurRadius: 10,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
                    children: [
                      // Drag handle
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 1.h),
                        width: 10.w,
                        height: 0.5.h,
                        decoration: BoxDecoration(
                          color: AppTheme.neutralGray,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),

                      Padding(
                        padding: EdgeInsets.all(4.w),
                        child: Column(
                          children: [
                            DeliveryStatusWidget(
                              currentStatus: _currentStatus,
                              estimatedArrival: _estimatedArrival,
                              orderId: _orderId,
                            ),
                            if (_currentStatus == 'Delivered') ...[
                              SizedBox(height: 2.h),
                              PickupCodeWidget(
                                pickupCode: _pickupCode,
                                onGenerateQR: _generateQRCode,
                              ),
                            ],
                            SizedBox(height: 2.h),
                            DroneInfoWidget(
                              droneId: _droneId,
                              altitude: _altitude,
                              speed: _speed,
                              batteryLevel: _batteryLevel,
                              pilotName: _pilotName,
                            ),
                            SizedBox(height: 2.h),
                            OrderSummaryWidget(
                              orderData: _orderData,
                              onContactRestaurant: _contactRestaurant,
                              onShareLocation: _shareLocation,
                            ),
                            SizedBox(height: 4.h),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
