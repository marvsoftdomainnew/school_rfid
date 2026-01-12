import 'package:dio/dio.dart';
import 'package:schoolmsrfid/core/constants/api_endpoints.dart';
import 'package:schoolmsrfid/core/services/sharedpreferences_service.dart';
import '../constants/app_keys.dart';
import '../utils/app_log.dart';
import '../utils/session_manager.dart';

class ApiService {
  static final Dio dio =
  Dio(
    BaseOptions(
      baseUrl: ApiEndpoints.baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
      },
    ),
  )
    ..interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final startTime = DateTime.now();
          options.extra['startTime'] = startTime;
          // Load token from SharedPreferences
          final prefs = await SharedPreferencesService.getInstance();
          final token = prefs.getString(AppKeys.token);

          // Add Bearer token if available
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
            appLog("🔐 Bearer Token attached");
          }

          appLog("📤 REQUEST → ${options.method} ${options.uri}");
          appLog("🔸 Headers: ${options.headers}");
          appLog("🔸 Data: ${options.data}");
          appLog("⏱️ Started at: $startTime");

          return handler.next(options);
        },

        onResponse: (response, handler) {
          final startTime =
          response.requestOptions.extra['startTime'] as DateTime?;
          final duration = startTime != null
              ? DateTime.now().difference(startTime)
              : null;
          appLog(
            "✅ RESPONSE ← ${response.statusCode} ${response.requestOptions.uri}",
          );
          appLog("📦 Response Data: ${response.data}");
          if (duration != null) {
            appLog(
              "⏳ API Duration: ${duration.inMilliseconds} ms (${duration.inSeconds}s)",
            );
          }
          return handler.next(response);
        },

        onError: (DioException e, handler) async {
          final statusCode = e.response?.statusCode;

          appLog("❌ ERROR ← $statusCode ${e.requestOptions.uri}");
          appLog("🧯 Message: ${e.message}");

          // =========================
          // 🔐 HANDLE 401 UNAUTHORIZED
          // =========================
          if (statusCode == 401) {
            appLog("🚨 401 detected → forcing logout");

            await SessionManager.forceLogout();

            // ⛔ stop further propagation
            return;
          }

          // ===== EXISTING TIMEOUT / RETRY LOGIC =====
          if (e.type == DioExceptionType.connectionTimeout ||
              e.type == DioExceptionType.receiveTimeout) {
            appLog("⚠️ Timeout detected");

            try {
              appLog("🔁 Retrying request once...");
              final retryOptions = e.requestOptions;
              retryOptions.connectTimeout = const Duration(seconds: 30);
              retryOptions.receiveTimeout = const Duration(seconds: 30);

              final response = await dio.fetch(retryOptions);
              return handler.resolve(response);
            } catch (_) {}
          }

          return handler.next(e);
        },

      ),
    );
}
