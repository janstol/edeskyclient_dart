import 'dart:convert';
import 'dart:io';

import 'package:edeskyclient/edeskyclient.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:test/test.dart';

import 'fixtures/fixture.dart';

void main() {
  final mockClient = MockClient((request) async {
    final url = request.url;
    String responseBody;
    int responseCode;

    if (!url.queryParameters.containsKey('api_key') ||
        url.queryParameters['api_key'] != testApiKey) {
      return http.Response(
        errorNotLoggedIn,
        401,
        headers: {HttpHeaders.contentTypeHeader: 'text/html; charset=utf-8'},
      );
    }

    switch (url.path) {
      case '/api/v1/dashboards':
        if (url.queryParameters.containsKey('id')) {
          if (url.queryParameters['id'] == '1') {
            responseBody = fixture('dashboard_1.xml');
            responseCode = 200;
          } else if (url.queryParameters['id'] == '0') {
            responseBody = fixture('not_found.xml');
            responseCode = 404;
          } else {
            responseBody = 'General error';
            responseCode = 500;
          }
        } else {
          responseBody = fixture('dashboards.xml');
          responseCode = 200;
        }
        break;
      case '/api/v1/documents':
        if (url.queryParameters['keywords'] == 'chrudim') {
          responseBody = fixture('documents.xml');
        } else {
          responseBody = fixture('documents_empty.xml');
        }
        responseCode = 200;
        break;
    }

    return http.Response.bytes(
      utf8.encode(responseBody),
      responseCode,
      headers: {
        HttpHeaders.contentTypeHeader: 'application/xml; charset=utf-8',
      },
    );
  });

  //////////////////////////////////////////////////////////////////////////////

  EdeskyClient edesky;

  group('General tests', () {
    setUpAll(() {
      edesky = EdeskyClient(httpClient: mockClient, apiKey: 'xyz');
    });

    tearDownAll(() {
      edesky.close();
    });

    test('Should throw EdeskyClientException (401 unauthorized)', () {
      expect(
        edesky.queryDashboard(1),
        throwsA(predicate<EdeskyClientException>(
            (e) => e.message == errorNotLoggedIn && e.statusCode == 401)),
      );
    });
  });

  group('Dashboard tests', () {
    setUpAll(() {
      edesky = EdeskyClient(httpClient: mockClient, apiKey: testApiKey);
    });

    tearDownAll(() {
      edesky.close();
    });

    test('Dashboards should be equal', () async {
      expect(await edesky.queryDashboard(1), createTestDashboardCity());
    });

    test('Should throw EdeskyClientException (404 Not found)', () async {
      expect(
        edesky.queryDashboard(0),
        throwsA(predicate<EdeskyClientException>(
            (e) => e.message == 'Not Found' && e.statusCode == 404)),
      );
    });

    test('Should throw EdeskyClientException (500 General error)', () async {
      expect(
        edesky.queryDashboard(-1),
        throwsA(predicate<EdeskyClientException>(
            (e) => e.message == 'General error' && e.statusCode == 500)),
      );
    });

    test('Should return list of dashboards and match test dashboards',
        () async {
      final dashboards = await edesky.queryDashboards();

      expect(dashboards, isNotNull);
      expect(dashboards, isNotEmpty);

      expect(
        dashboards.where((d) => d.id == 1).first,
        createTestDashboardCity(),
      );

      expect(
        dashboards.where((d) => d.id == 28).first,
        createTestDashboardRegion(),
      );

      expect(
        dashboards.where((d) => d.id == 59).first,
        createTestDashboardStructure(),
      );

      expect(
        dashboards.where((d) => d.id == 1231).first,
        createTestDashboardInstitution(),
      );
    });
  });

  group('Documents tests', () {
    setUpAll(() {
      edesky = EdeskyClient(httpClient: mockClient, apiKey: testApiKey);
    });

    tearDownAll(() {
      edesky.close();
    });

    test('Should return documents for Chrudim and match first', () async {
      final documents = await edesky.queryDocuments(keywords: 'chrudim');
      expect(documents.first, createTestDocument());
    });

    test('Should return no documents (empty)', () async {
      final documents = await edesky.queryDocuments(keywords: 'hjkggkghk');
      expect(documents, isEmpty);
    });
  });
}
