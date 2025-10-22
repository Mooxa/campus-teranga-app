import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:logger/logger.dart';

/// Connectivity Service for monitoring network status
/// 
/// This service provides:
/// - Real-time network connectivity monitoring
/// - Network type detection (WiFi, Mobile, Ethernet)
/// - Connection quality assessment
/// - Offline mode detection
class ConnectivityService {
  final Connectivity _connectivity = Connectivity();
  final Logger _logger = Logger();
  
  StreamController<bool> _connectionController = StreamController<bool>.broadcast();
  StreamController<ConnectivityResult> _connectivityController = 
      StreamController<ConnectivityResult>.broadcast();

  bool _isConnected = false;
  ConnectivityResult _currentConnectivity = ConnectivityResult.none;

  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;

  ConnectivityService() {
    _initializeConnectivity();
  }

  /// Stream of connection status changes
  Stream<bool> get connectionStream => _connectionController.stream;

  /// Stream of connectivity type changes
  Stream<ConnectivityResult> get connectivityStream => _connectivityController.stream;

  /// Current connection status
  bool get isConnected => _isConnected;

  /// Current connectivity type
  ConnectivityResult get currentConnectivity => _currentConnectivity;

  /// Initialize connectivity monitoring
  void _initializeConnectivity() async {
    try {
      // Get initial connectivity status
      final List<ConnectivityResult> initialResult = 
          await _connectivity.checkConnectivity();
      
      if (initialResult.isNotEmpty) {
        _updateConnectivityStatus(initialResult.first);
      }

      // Listen for connectivity changes
      _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
        (List<ConnectivityResult> results) {
          if (results.isNotEmpty) {
            _updateConnectivityStatus(results.first);
          }
        },
        onError: (error) {
          _logger.e('Connectivity error: $error');
        },
      );
    } catch (e) {
      _logger.e('Failed to initialize connectivity: $e');
    }
  }

  /// Update connectivity status
  void _updateConnectivityStatus(ConnectivityResult result) {
    _currentConnectivity = result;
    _isConnected = result != ConnectivityResult.none;

    _logger.d('Connectivity changed: $result, Connected: $_isConnected');

    // Notify listeners
    _connectivityController.add(result);
    _connectionController.add(_isConnected);
  }

  /// Check current connectivity status
  Future<bool> checkConnectivity() async {
    try {
      final List<ConnectivityResult> results = 
          await _connectivity.checkConnectivity();
      
      if (results.isNotEmpty) {
        _updateConnectivityStatus(results.first);
        return _isConnected;
      }
      return false;
    } catch (e) {
      _logger.e('Failed to check connectivity: $e');
      return false;
    }
  }

  /// Get detailed connectivity information
  Future<ConnectivityInfo> getConnectivityInfo() async {
    try {
      final List<ConnectivityResult> results = 
          await _connectivity.checkConnectivity();
      
      if (results.isNotEmpty) {
        final result = results.first;
        return ConnectivityInfo(
          type: result,
          isConnected: result != ConnectivityResult.none,
          connectionQuality: _getConnectionQuality(result),
        );
      }
      
      return ConnectivityInfo(
        type: ConnectivityResult.none,
        isConnected: false,
        connectionQuality: ConnectionQuality.none,
      );
    } catch (e) {
      _logger.e('Failed to get connectivity info: $e');
      return ConnectivityInfo(
        type: ConnectivityResult.none,
        isConnected: false,
        connectionQuality: ConnectionQuality.none,
      );
    }
  }

  /// Determine connection quality based on connectivity type
  ConnectionQuality _getConnectionQuality(ConnectivityResult result) {
    switch (result) {
      case ConnectivityResult.wifi:
        return ConnectionQuality.excellent;
      case ConnectivityResult.ethernet:
        return ConnectionQuality.excellent;
      case ConnectivityResult.mobile:
        return ConnectionQuality.good;
      case ConnectivityResult.bluetooth:
        return ConnectionQuality.poor;
      case ConnectivityResult.vpn:
        return ConnectionQuality.good;
      case ConnectivityResult.other:
        return ConnectionQuality.unknown;
      case ConnectivityResult.none:
        return ConnectionQuality.none;
    }
  }

  /// Check if connected to WiFi
  bool get isWiFiConnected => _currentConnectivity == ConnectivityResult.wifi;

  /// Check if connected to mobile data
  bool get isMobileConnected => _currentConnectivity == ConnectivityResult.mobile;

  /// Check if connected to Ethernet
  bool get isEthernetConnected => _currentConnectivity == ConnectivityResult.ethernet;

  /// Check if connected via VPN
  bool get isVPNConnected => _currentConnectivity == ConnectivityResult.vpn;

  /// Get connection type as string
  String get connectionTypeString {
    switch (_currentConnectivity) {
      case ConnectivityResult.wifi:
        return 'WiFi';
      case ConnectivityResult.mobile:
        return 'Mobile Data';
      case ConnectivityResult.ethernet:
        return 'Ethernet';
      case ConnectivityResult.bluetooth:
        return 'Bluetooth';
      case ConnectivityResult.vpn:
        return 'VPN';
      case ConnectivityResult.other:
        return 'Other';
      case ConnectivityResult.none:
        return 'No Connection';
    }
  }

  /// Get connection quality as string
  String get connectionQualityString {
    switch (_getConnectionQuality(_currentConnectivity)) {
      case ConnectionQuality.excellent:
        return 'Excellent';
      case ConnectionQuality.good:
        return 'Good';
      case ConnectionQuality.poor:
        return 'Poor';
      case ConnectionQuality.unknown:
        return 'Unknown';
      case ConnectionQuality.none:
        return 'No Connection';
    }
  }

  /// Check if connection is suitable for data-heavy operations
  bool get isSuitableForDataHeavyOperations {
    final quality = _getConnectionQuality(_currentConnectivity);
    return quality == ConnectionQuality.excellent || 
           quality == ConnectionQuality.good;
  }

  /// Check if connection is suitable for basic operations
  bool get isSuitableForBasicOperations {
    return _isConnected && _currentConnectivity != ConnectivityResult.none;
  }

  /// Dispose resources
  void dispose() {
    _connectivitySubscription?.cancel();
    _connectionController.close();
    _connectivityController.close();
  }
}

/// Connectivity information model
class ConnectivityInfo {
  final ConnectivityResult type;
  final bool isConnected;
  final ConnectionQuality connectionQuality;

  ConnectivityInfo({
    required this.type,
    required this.isConnected,
    required this.connectionQuality,
  });

  @override
  String toString() {
    return 'ConnectivityInfo(type: $type, isConnected: $isConnected, quality: $connectionQuality)';
  }
}

/// Connection quality levels
enum ConnectionQuality {
  none,
  poor,
  good,
  excellent,
  unknown,
}
