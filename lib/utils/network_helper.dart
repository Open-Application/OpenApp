import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkHelper {
  static final Connectivity _connectivity = Connectivity();
  static Future<bool> hasConnection() async {
    try {
      final List<ConnectivityResult> results = await _connectivity.checkConnectivity();
      if (results.isEmpty) {
        return false;
      }
      return results.any((result) => result != ConnectivityResult.none);
    } catch (_) {
      return true;
    }
  }

  static Future<NetworkStatus> getNetworkStatus() async {
    try {
      final List<ConnectivityResult> results = await _connectivity.checkConnectivity();

      if (results.isEmpty || results.every((r) => r == ConnectivityResult.none)) {
        return NetworkStatus.disconnected;
      }

      bool hasWifi = results.contains(ConnectivityResult.wifi);
      bool hasMobile = results.contains(ConnectivityResult.mobile);
      bool hasEthernet = results.contains(ConnectivityResult.ethernet);
      bool hasVpn = results.contains(ConnectivityResult.vpn);

      if (hasVpn) {
        return NetworkStatus.vpn;
      } else if (hasWifi) {
        return NetworkStatus.wifi;
      } else if (hasMobile) {
        return NetworkStatus.mobile;
      } else if (hasEthernet) {
        return NetworkStatus.ethernet;
      } else if (results.contains(ConnectivityResult.bluetooth)) {
        return NetworkStatus.bluetooth;
      } else if (results.contains(ConnectivityResult.other)) {
        return NetworkStatus.other;
      }

      return NetworkStatus.unknown;
    } catch (_) {
      return NetworkStatus.unknown;
    }
  }

  static Stream<List<ConnectivityResult>> get onConnectivityChanged {
    return _connectivity.onConnectivityChanged;
  }

  static Future<bool> isVpnConnected() async {
    try {
      final List<ConnectivityResult> results = await _connectivity.checkConnectivity();
      return results.contains(ConnectivityResult.vpn);
    } catch (_) {
      return false;
    }
  }
}

enum NetworkStatus {
  disconnected,
  wifi,
  mobile,
  ethernet,
  bluetooth,
  vpn,
  other,
  unknown,
}

extension NetworkStatusExtension on NetworkStatus {
  String get displayName {
    switch (this) {
      case NetworkStatus.disconnected:
        return 'No Connection';
      case NetworkStatus.wifi:
        return 'Wi-Fi';
      case NetworkStatus.mobile:
        return 'Mobile Data';
      case NetworkStatus.ethernet:
        return 'Ethernet';
      case NetworkStatus.bluetooth:
        return 'Bluetooth';
      case NetworkStatus.vpn:
        return 'VPN';
      case NetworkStatus.other:
        return 'Connected';
      case NetworkStatus.unknown:
        return 'Unknown';
    }
  }

  bool get isConnected => this != NetworkStatus.disconnected;
}