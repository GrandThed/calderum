/// Utility for deep JSON conversion of Freezed models for Firestore
class JsonConverter {
  /// Deep convert any object to JSON-serializable format for Firestore
  static dynamic deepConvertToJson(dynamic obj) {
    if (obj == null) return null;
    
    // If it's already a primitive type, return as is
    if (obj is String || obj is num || obj is bool) {
      return obj;
    }
    
    // If it's a DateTime, convert to ISO string
    if (obj is DateTime) {
      return obj.toIso8601String();
    }
    
    // If it's a List, recursively convert each element
    if (obj is List) {
      return obj.map((item) => deepConvertToJson(item)).toList();
    }
    
    // If it's a Map, recursively convert each value
    if (obj is Map) {
      final Map<String, dynamic> result = {};
      obj.forEach((key, value) {
        result[key.toString()] = deepConvertToJson(value);
      });
      return result;
    }
    
    // If it has a toJson method, use it and then recursively convert
    try {
      final dynamic jsonObj = (obj as dynamic).toJson();
      return deepConvertToJson(jsonObj);
    } catch (e) {
      // Enums should already be handled by Freezed's toJson, 
      // but if we encounter a raw enum, this is a fallback
      // DO NOT use .name as it returns the Dart name, not the JSON value
      
      // Otherwise, convert to string as last resort
      print('Warning: Could not serialize object of type ${obj.runtimeType}');
      return obj.toString();
    }
  }
  
  /// Convert a Freezed model to a Firestore-safe Map
  static Map<String, dynamic> toFirestoreJson(dynamic model) {
    final json = model.toJson();
    final converted = deepConvertToJson(json);
    
    if (converted is Map<String, dynamic>) {
      return converted;
    } else {
      // This should not happen, but handle it gracefully
      return {'data': converted};
    }
  }
}