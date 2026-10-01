class OfflineCacheService {
  static final Map<String, dynamic> _memoryCache = {};

  static Future<void> cacheData(String key, dynamic data) async {
    _memoryCache[key] = data;
  }

  static Future<dynamic> getCachedData(String key) async {
    return _memoryCache[key];
  }
}
