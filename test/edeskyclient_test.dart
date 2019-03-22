import 'dart:convert';
import 'dart:io';

import 'package:edeskyclient/edeskyclient.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:test/test.dart';

void main() {
  final mockClient = MockClient((request) async {
    final url = request.url;

    final dashboardsFile = File('test/dashboards.xml');
    final dashboardFile = File('test/dashboard_1.xml');
    final documentsFile = File('test/documents.xml');
    String responseBody;
    int responseCode;

    switch (url.path) {
      case '/api/v1/dashboards':
        if (url.queryParameters.containsKey('id')) {
          if (url.queryParameters['id'] == '1') {
            responseBody = await dashboardFile.readAsString();
            responseCode = 200;
          } else if (url.queryParameters['id'] == '0') {
            responseBody = """<?xml version='1.0' encoding='utf-8' ?>
                  <hash><status>404</status><error>Not Found</error></hash>""";
            responseCode = 404;
          } else {
            responseBody = "General error";
            responseCode = 500;
          }
        } else {
          responseBody = await dashboardsFile.readAsString();
          responseCode = 200;
        }
        break;
      case '/api/v1/documents':
        responseBody = await documentsFile.readAsString();
        responseCode = 200;
        break;
    }

    return http.Response.bytes(
      utf8.encode(responseBody),
      responseCode,
      headers: {'Content-Type': 'application/xml; charset=utf-8'},
    );
  });

  final edesky = EdeskyClient(apiKey: 'xyz');
  edesky.httpClient = mockClient;

  group('Dashboard tests', () {
    test('Dashboard success', () async {
      final dashboard = await edesky.queryDashboard(1);

      expect(dashboard, isNotNull);
      expect(dashboard.id, 1);
      expect(dashboard.name, 'Město Olomouc');
      expect(dashboard.category, 'samosprava');
      expect(dashboard.url, 'https://edesky.cz/desky/1');
      expect(dashboard.nuts3Id, 28);
      expect(dashboard.nuts3Name, 'Olomoucký kraj');
      expect(dashboard.nuts4Id, 972);
      expect(dashboard.nuts4Name, 'Okres Olomouc');
      expect(dashboard.ico, 299308);
      expect(dashboard.abbreviation, 'Olomouc');
      expect(dashboard.parentId, 972);
      expect(dashboard.parentName, 'Okres Olomouc');
      expect(dashboard.ruianCode, 500496);
    });

    test('Dashboard 404 not found', () {
      expect(
        edesky.queryDashboard(0),
        throwsA(predicate((e) =>
            e is EdeskyClientException &&
            e.message == 'Not Found' &&
            e.statusCode == 404)),
      );
    });

    test('Dashboard general error', () {
      expect(
        edesky.queryDashboard(-1),
        throwsA(predicate((e) =>
            e is EdeskyClientException &&
            e.message == 'General error' &&
            e.statusCode == 500)),
      );
    });

    test('Dashboards test', () async {
      final dashboards = await edesky.queryDashboards();

      expect(dashboards, isNotNull);
      expect(dashboards, isNotEmpty);
      expect(dashboards.where((d) => d.id == 1).first.name, 'Město Olomouc');
    });
  });

  group('Documents tests', () {
    test('Documents', () async {
      final documents = await edesky.queryDocuments(keywords: 'chrudim');

      expect(documents.first.dashboardId, 97);
      expect(documents.first.attachments.length, 1);
      expect(documents.first.attachments.first.name,
          'Pozvanka_-_ZM_25.3.2019.pdf');
    });
  });
}
