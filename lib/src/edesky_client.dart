import 'dart:convert';

import 'package:edeskyclient/src/model/dashboard.dart';
import 'package:edeskyclient/src/model/document.dart';
import 'package:http/http.dart';
import 'package:meta/meta.dart';
import 'package:xml/xml.dart' as xml;

/// Edesky client to query https://edesky.cz API
///
/// You have to provide [apiKey],
/// you can get one at https://edesky.cz when you sign up
class EdeskyClient {
  /// API key is *required*! Requests will not work without API key!
  /// You have to create an account at `https://edesky.cz` to get an API key
  final String apiKey;

  /// HTTP client
  Client httpClient = Client();

  /// Creates edesky client
  EdeskyClient({@required this.apiKey});

  /// Gets a single dashboard by id
  ///
  /// Throws [EdeskyClientException] when response status code is not 200
  Future<Dashboard> queryDashboard(int id) async {
    final response =
        await httpClient.get(_createUrl("dashboards", {'id': id.toString()}));

    switch (response.statusCode) {
      case 200:
        return xml
            .parse(utf8.decode(response.bodyBytes))
            .findAllElements('dashboard')
            .map((d) => Dashboard.fromXML(d))
            .single;
      case 404:
        throw EdeskyClientException(_parseError(response), 404);
      default:
        throw EdeskyClientException(
            utf8.decode(response.bodyBytes), response.statusCode);
    }
  }

  /// Gets all dashboards
  ///
  /// Throws [EdeskyClientException] when response status code is not 200
  Future<List<Dashboard>> queryDashboards() async {
    final response = await httpClient.get(_createUrl("dashboards"));

    switch (response.statusCode) {
      case 200:
        return xml
            .parse(utf8.decode(response.bodyBytes))
            .findAllElements('dashboard')
            .map((d) => Dashboard.fromXML(d))
            .toList();
      case 404:
        throw EdeskyClientException(_parseError(response), 404);
      default:
        throw EdeskyClientException(
            utf8.decode(response.bodyBytes), response.statusCode);
    }
  }

  /// Search for documents
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
  /// Throws [EdeskyClientException] when response status code is not 200
  Future<List<Document>> queryDocuments({
    @required String keywords,
    String searchWith = 'es',
    String createdFrom,
    int dashboardId,
    int includeTexts = 0,
    String order = 'score',
    int page = 1,
  }) async {
    final Map params = <String, String>{
      'keywords': keywords,
      'search_with': searchWith,
      'created_from': createdFrom,
      'dashboard_id': dashboardId?.toString(),
      'include_texts': includeTexts.toString(),
      'order': order,
      'page': page.toString(),
    };
    final response = await httpClient.get(_createUrl('documents', params));

    switch (response.statusCode) {
      case 200:
        return xml
            .parse(utf8.decode(response.bodyBytes))
            .findAllElements('document')
            .map((d) => Document.fromXML(d))
            .toList();
      case 404:
        throw EdeskyClientException(_parseError(response), 404);
      default:
        throw EdeskyClientException(
            utf8.decode(response.bodyBytes), response.statusCode);
    }
  }

  /// Closes the http client
  ///
  /// It's important to close the client when it's done being used,
  /// otherwise Dart process can hang
  void close() {
    httpClient.close();
  }

  /// Constructs url for requets
  String _createUrl(String path, [Map<String, String> parameters]) {
    final params = Map<String, String>();

    params.addAll({'api_key': apiKey}); //add required api key
    if (parameters != null && parameters.isNotEmpty) {
      params.addAll(parameters);
    }

    return Uri.https("edesky.cz", "/api/v1/$path", params).toString();
  }

  /// Parses errors text for exceptions
  String _parseError(Response response) {
    final responseBody = utf8.decode(response.bodyBytes);

    try {
      return xml.parse(responseBody).findAllElements('error').first.text;
    } on Exception catch (_) {
      return responseBody;
    }
  }
}

class EdeskyClientException implements Exception {
  final String message;

  final int statusCode;

  EdeskyClientException([this.message = '', this.statusCode]);

  @override
  String toString() {
    return "EdeskyClientException: $message, $statusCode";
  }
}
