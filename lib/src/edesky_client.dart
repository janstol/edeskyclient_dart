import 'dart:convert';

import 'package:edeskyclient/src/edesky_client_exception.dart';
import 'package:edeskyclient/src/model/dashboard.dart';
import 'package:edeskyclient/src/model/document.dart';
import 'package:http/http.dart';
import 'package:xml/xml.dart';

/// Edesky client to query https://edesky.cz API.
///
/// You have to provide [apiKey]! You can get one at https://edesky.cz
/// when you sign up.
class EdeskyClient {
  /// API key is *required*! Requests will not work without API key!
  /// You have to create an account at `https://edesky.cz` to get an API key
  final String apiKey;

  /// HTTP client.
  Client httpClient;

  /// Creates edesky client
  EdeskyClient({required this.httpClient, required this.apiKey});

  /// Gets a single dashboard by [id].
  ///
  /// Throws [EdeskyClientException] when response status code is not 200.
  Future<Dashboard> queryDashboard(int id) async {
    final response = await _queryGet(_createUrl('dashboards', {'id': '$id'}));

    return XmlDocument.parse(utf8.decode(response.bodyBytes))
        .findAllElements('dashboard')
        .map((d) => Dashboard.fromXML(d))
        .single;
  }

  /// Gets all dashboards.
  ///
  /// Throws [EdeskyClientException] when response status code is not 200.
  Future<List<Dashboard>> queryDashboards() async {
    final response = await _queryGet(_createUrl('dashboards'));

    return XmlDocument.parse(utf8.decode(response.bodyBytes))
        .findAllElements('dashboard')
        .map((d) => Dashboard.fromXML(d))
        .toList();
  }

  /// Search for documents.
  ///
  /// * [keywords] - search query, required!
  /// * [searchWith] - type of search, `es` - fulltext
  /// or `sql` - keywords in document names, default `es`
  /// * [createdFrom] - search only documents created AFTER this date
  /// * [dashboardId] - specifies dashboard id, empty means search everywhere
  /// * [includeTexts] - set `1` to include parsed texts, default `0`
  /// * [order] - results ordering, `date` or `score`, default `score`
  /// * [page] - pagination, every page has 200 documents, default `1`
  ///
  /// Throws [EdeskyClientException] when response status code is not 200.
  Future<List<Document>> queryDocuments({
    required String keywords,
    String searchWith = 'es',
    String? createdFrom,
    int? dashboardId,
    int includeTexts = 0,
    String order = 'score',
    int page = 1,
  }) async {
    final params = <String, String?>{
      'keywords': keywords,
      'search_with': searchWith,
      'created_from': createdFrom,
      'dashboard_id': dashboardId?.toString(),
      'include_texts': includeTexts.toString(),
      'order': order,
      'page': page.toString(),
    };
    final response = await _queryGet(_createUrl('documents', params));

    return XmlDocument.parse(utf8.decode(response.bodyBytes))
        .findAllElements('document')
        .map((d) => Document.fromXML(d))
        .toList();
  }

  /// Closes the http client
  ///
  /// It's important to close the client when it's done being used,
  /// otherwise Dart process can hang
  void close() {
    httpClient.close();
  }

  /// Sends GET request to [requestUrl] and returns [Response]
  /// or throws [EdeskyClientException] when response status code is not 200.
  Future<Response> _queryGet(String requestUrl) async {
    Response response;

    try {
      response = await httpClient.get(Uri.parse(requestUrl));
    } on Exception catch (e) {
      throw EdeskyClientException('$e');
    }

    if (response.statusCode == 200) {
      return response;
    } else {
      throw EdeskyClientException(_parseError(response), response.statusCode);
    }
  }

  /// Constructs url for requets
  String _createUrl(String path, [Map<String, String?>? parameters]) {
    final params = <String, String?>{};

    params.addAll({'api_key': apiKey}); //add required api key
    if (parameters != null && parameters.isNotEmpty) {
      params.addAll(parameters);
    }

    return Uri.https('edesky.cz', '/api/v1/$path', params).toString();
  }

  /// Parses errors text for exceptions
  String _parseError(Response response) {
    final responseBody = utf8.decode(response.bodyBytes);

    try {
      return XmlDocument.parse(responseBody)
          .findAllElements('error')
          .first
          .text;
    } on Exception catch (_) {
      return responseBody;
    }
  }

  @override
  String toString() => 'EdeskyClient(httClient: $httpClient, apiKey: $apiKey)';
}
