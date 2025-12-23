/// VIP Codes for Ollo Premium Access
/// 
/// Format: 16 characters uppercase alphanumeric (XXXX-XXXX-XXXX-XXXX)
/// 
/// HOW TO ADD NEW CODES:
/// Simply add new codes to the appropriate list below:
/// - [betaTesterCodes] for beta testers
/// - [specialCodes] for special promotions
/// - [developerCodes] for developer access (grants Developer tier)
/// 
/// Each code can only be used once per device.
class VipCodes {
  VipCodes._();

  // ============================================================
  // DEVELOPER CODES (grants Developer tier with debug features)
  // ============================================================
  static const List<String> developerCodes = [
    'OLLO-DEVT-RIAN-2024', // Developer: Trian Aprilianto
  ];

  // ============================================================
  // BETA TESTER CODES (50 codes for beta testers)
  // Generated: December 2024
  // ============================================================
  static const List<String> betaTesterCodes = [
    // Batch 1 (1-10)
    'VIP1-K7M2-N9P4-X3Q8',
    'VIP2-R5T8-W2Y6-B4D1',
    'VIP3-F9H3-J7L5-C2V8',
    'VIP4-G4K8-M1N6-S9W3',
    'VIP5-P2Q7-T5X9-Y3Z6',
    'VIP6-A8C4-E1F7-H5J2',
    'VIP7-L3N9-R6S2-U8V4',
    'VIP8-B7D1-G4K8-M2P5',
    'VIP9-Q9T3-W6X1-Z4A7',
    'VI10-C5F2-H8J4-L1N6',
    
    // Batch 2 (11-20)
    'VI11-S3U9-V7Y2-B5D8',
    'VI12-E4G1-K7M3-P9R6',
    'VI13-T2W8-X5Z1-A4C7',
    'VI14-F6H3-J9L5-N2Q8',
    'VI15-S1U7-V4Y9-B3D6',
    'VI16-E8G2-K5M1-P7R4',
    'VI17-T9W3-X6Z2-A8C5',
    'VI18-F1H7-J4L9-N6Q3',
    'VI19-S5U2-V8Y4-B1D9',
    'VI20-E3G9-K6M2-P8R5',
    
    // Batch 3 (21-30)
    'VI21-T4W1-X7Z3-A9C6',
    'VI22-F2H8-J5L1-N7Q4',
    'VI23-S6U3-V9Y5-B2D1',
    'VI24-E7G4-K1M8-P3R9',
    'VI25-T8W5-X2Z7-A4C1',
    'VI26-F3H9-J6L2-N8Q5',
    'VI27-S7U4-V1Y6-B3D2',
    'VI28-E1G5-K2M9-P4R7',
    'VI29-T9W6-X3Z8-A5C2',
    'VI30-F4H1-J7L3-N9Q6',
    
    // Batch 4 (31-40)
    'VI31-S8U5-V2Y7-B4D3',
    'VI32-E2G6-K3M1-P5R8',
    'VI33-T1W7-X4Z9-A6C3',
    'VI34-F5H2-J8L4-N1Q7',
    'VI35-S9U6-V3Y8-B5D4',
    'VI36-E3G7-K4M2-P6R9',
    'VI37-T2W8-X5Z1-A7C4',
    'VI38-F6H3-J9L5-N2Q8',
    'VI39-S1U7-V4Y9-B6D5',
    'VI40-E4G8-K5M3-P7R1',
    
    // Batch 5 (41-50)
    'VI41-T3W9-X6Z2-A8C5',
    'VI42-F7H4-J1L6-N3Q9',
    'VI43-S2U8-V5Y1-B7D6',
    'VI44-E5G9-K6M4-P8R2',
    'VI45-T4W1-X7Z3-A9C6',
    'VI46-F8H5-J2L7-N4Q1',
    'VI47-S3U9-V6Y2-B8D7',
    'VI48-E6G1-K7M5-P9R3',
    'VI49-T5W2-X8Z4-A1C7',
    'VI50-F9H6-J3L8-N5Q2',
  ];

  // ============================================================
  // SPECIAL PROMOTION CODES (add manually as needed)
  // ============================================================
  static const List<String> specialCodes = [
    'OLLO-LAUN-CH24-SPEC', // Launch special
    'OLLO-EARL-BIRD-2024', // Early bird
    // Add more special codes here...
  ];

  // ============================================================
  // HELPER METHODS
  // ============================================================
  
  /// Get all valid VIP codes (combines all lists)
  static List<String> get allCodes => [
    ...developerCodes,
    ...betaTesterCodes,
    ...specialCodes,
  ];

  /// Check if a code is a developer code
  static bool isDeveloperCode(String code) {
    return developerCodes.contains(code.toUpperCase().trim());
  }

  /// Check if a code is valid
  static bool isValidCode(String code) {
    return allCodes.contains(code.toUpperCase().trim());
  }
}
