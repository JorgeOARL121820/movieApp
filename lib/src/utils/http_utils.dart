import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:movie_app/src/utils/utils.dart';

enum ApiMethod { get, post, put, delete }

class Api {
  Api();

  /// Este método se utiliza para hacer cualquier llamada al API.
  /// Apunta al host configrado en cada ambiente. Se define el tipo de request.
  /// Los headers, interceptores, logs, encriptaciones, etc.
  static Future<Map<String, dynamic>> call(String endpoint,
      {dynamic data,
      Map<String, dynamic>? queryParameters,
      ApiMethod method = ApiMethod.get,
      bool tokenNeeded = true,
      Map<String, String>? extraHeaders,
      bool? debugPrint,
      bool? saveLog,
      bool? encrypt,
      bool showError = true,
      Function(int, int)? onSendProgress}) async {
    late Map<String, dynamic> jsonResponse;

    /// Imprimimos los logs solo cuando estamos en ambiente de desarrollo
    bool? localDebugPrint = debugPrint;
    if (localDebugPrint == null) {
      localDebugPrint = environment.debugPrint;
    } else {
      if (localDebugPrint && !environment.debugPrint) {
        localDebugPrint = false;
      }
    }

    try {
      /// Construimos el uri del endpoint
      late String url;
      if (endpoint.startsWith('http')) {
        url = endpoint;
      } else {
        url = 'https://';

        url += environment.baseURL.split('//').last;
        url += endpoint;
      }
      final Uri uri = Uri.parse(url);

      /// Construimos los headers
      final Map<String, String> headers = <String, String>{
        'Content-Type': 'application/json',
        'Accept': '*/*; charset=utf-8',
        'x-app-language': Platform.localeName.split('_')[0]
      };
      if (tokenNeeded) {
        headers.putIfAbsent(
            'Authorization', () => 'Bearer ${environment.apiToken}');
      }
      if (extraHeaders != null && extraHeaders.isNotEmpty) {
        headers.addAll(extraHeaders);
      }

      /// Imprimimos los logs si es necesario
      if (localDebugPrint) {
        printHeader(url, queryParameters, method, extraHeaders);
      }

      final BaseOptions optionsApi =
          BaseOptions(baseUrl: environment.baseURL, headers: headers);

      final Dio client = Dio(optionsApi);

      ///
      late Response<Map<String, dynamic>> response;
      if (method == ApiMethod.get) {
        response = await client.get(uri.toString(),
            queryParameters: queryParameters,
            options: Options(headers: headers));
      } else {
        if (data != null) {
          dynamic realData;
          realData = data;

          if (localDebugPrint) {
            printBody(data, realData, false);
          }
          if (method == ApiMethod.post) {
            response = await client.post(uri.toString(),
                options: Options(headers: headers),
                data: jsonEncode(realData),
                onSendProgress: onSendProgress);
          } else if (method == ApiMethod.put) {
            response = await client.put(uri.toString(),
                options: Options(headers: headers),
                data: jsonEncode(realData),
                onSendProgress: onSendProgress);
          } else {
            response = await client.delete(uri.toString(),
                options: Options(headers: headers), data: jsonEncode(realData));
          }
        } else {
          if (method == ApiMethod.post) {
            response = await client.post(uri.toString(),
                options: Options(headers: headers),
                onSendProgress: onSendProgress);
          } else if (method == ApiMethod.put) {
            response = await client.put(uri.toString(),
                options: Options(headers: headers),
                onSendProgress: onSendProgress);
          } else {
            response = await client.delete(uri.toString(),
                options: Options(headers: headers));
          }
        }
      }

      if (response.data is String) {
        jsonResponse = <String, dynamic>{
          'statusCode': response.statusCode,
          'data': response.data,
          'message': null,
        };
      } else {
        jsonResponse = <String, dynamic>{
          'statusCode': response.statusCode,
          'data': response.data!['data'],
          'message': response.data!['message']
        };
      }
    } on DioException catch (error) {
      try {
        final Map<String, dynamic> data =
            error.response?.data as Map<String, dynamic>;

        jsonResponse = <String, dynamic>{
          'statusCode': error.response?.statusCode,
          'data': data['data'],
          'message': data['message']
        };
      } catch (_) {
        jsonResponse = <String, dynamic>{
          'statusCode': 502,
          'data': <String>[error.message ?? ''],
          'message': error.response?.data.toString()
        };
      }
    }

    if (localDebugPrint) {
      printResponse('', jsonResponse, false);
    }
    return jsonResponse;
  }

  static void printHeader(
    String url,
    Map<String, dynamic>? queryParams,
    ApiMethod method,
    Map<String, String>? extraHeaders,
  ) {
    String finalUrl = url;
    String? stringMethod;
    if (method == ApiMethod.get) {
      stringMethod = 'GET';
    } else if (method == ApiMethod.post) {
      stringMethod = 'POST';
    } else if (method == ApiMethod.put) {
      stringMethod = 'PUT';
    } else if (method == ApiMethod.delete) {
      stringMethod = 'DELETE';
    }

    if (queryParams?.isNotEmpty ?? false) {
      if (!finalUrl.contains('?')) {
        finalUrl += '?';
      }
      queryParams!.forEach((String key, dynamic value) {
        finalUrl += '$key=$value&';
      });
      finalUrl = finalUrl.substring(0, finalUrl.length - 1);
    }

    log(' ');
    log('----------------------------------------------');
    log('URL ($stringMethod): $finalUrl\n');
    log(' ');
    if (extraHeaders?.isNotEmpty ?? false) {
      log('CUSTOM HEADERS: $extraHeaders\n');
      log(' ');
    }
  }

  static void printBody(
    dynamic realData,
    dynamic encryptedData,
    bool encrypt, {
    bool printEncyptedData = true,
  }) {
    log('BODY:');
    log(jsonEncode(realData));
    if (encrypt && printEncyptedData) {
      log(' ');
      log('BODY ENCRIPTADO:');
      log(jsonEncode(encryptedData));
    }
    log(' ');
  }

  static void printResponse(
    dynamic encryptedData,
    dynamic realData,
    bool encrypt, {
    bool printEncyptedData = true,
  }) {
    if (encrypt && printEncyptedData) {
      log('RESPONSE ENCRIPTADA:');
      log(jsonEncode(encryptedData));
      log(' ');
    }
    log('RESPONSE:');
    log(jsonEncode(realData));
    log(' ');
  }
}
