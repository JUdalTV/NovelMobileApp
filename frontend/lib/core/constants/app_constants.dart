import 'dart:io' show Platform;

/// Application-wide constants
class AppConstants {
  // API Configuration
  
  // Determine the appropriate API URL based on platform
  static String get API_BASE_URL {
    // Choose the appropriate URL based on your development environment
    
    // OPTION 1: For real Android or iOS devices on the same network as your PC
    // Use your computer's actual network IP address
    return 'http://192.168.1.10:5000/api';
    
    // OPTION 2: For emulators and simulators
    /*
    if (Platform.isAndroid) {
      // For Android Emulator, use 10.0.2.2 to reach the host machine
      return 'http://10.0.2.2:5000/api';
    } else if (Platform.isIOS) {
      // For iOS Simulator, use localhost
      return 'http://127.0.0.1:5000/api';
    } else {
      // For desktop/web platforms, use localhost
      return 'http://localhost:5000/api';
    }
    */
  }
  
  // Timeouts
  static const int connectionTimeout = 5000; // milliseconds
  static const int receiveTimeout = 3000;  // milliseconds
} 