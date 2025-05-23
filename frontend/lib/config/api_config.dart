import 'dart:io' show Platform;

/// API configurations
class ApiConfig {
  // API Base URL for connecting to backend
  static String get apiBaseUrl {
    try {
      if (Platform.isAndroid) {
        // For physical Android devices and emulators
        const bool isPhysicalDevice = true; // Change this based on your device
        if (isPhysicalDevice) {
          // Use your computer's actual IP address when testing on physical device
          return 'http://192.168.88.99:5000/api'; // Your computer's Wi-Fi IP
        } else {
          // For Android Emulator
          return 'http://10.0.2.2:5000/api';
        }
      } else if (Platform.isIOS) {
        // For iOS Simulator, use localhost
        return 'http://127.0.0.1:5000/api';
      } else {
        // For desktop/web platforms, use localhost
        return 'http://localhost:5000/api';
      }
    } catch (e) {
      print('Error determining platform-specific URL: $e, using default URL');
      // Default fallback URL for physical devices
      return 'http://192.168.88.99:5000/api'; // Your computer's Wi-Fi IP
    }
  }
  
  // List of fallback URLs to try if the main one fails
  static List<String> get fallbackUrls {
    return [
      'http://192.168.88.99:5000/api',   // Your computer's Wi-Fi IP
      'http://192.168.88.1:5000/api',    // Your router IP
      'http://10.0.2.2:5000/api',        // Android emulator
      'http://127.0.0.1:5000/api',       // iOS simulator & localhost
      'http://localhost:5000/api',       // Local network
    ];
  }
  
  // Request timeouts - increased for mobile networks
  static const int connectionTimeout = 60000;  // 60 seconds
  static const int receiveTimeout = 60000;     // 60 seconds
  
  // Retry configuration
  static const int maxRetries = 3;
  static const int retryDelay = 3000;  // 3 seconds
} 