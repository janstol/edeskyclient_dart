# Edesky client

[![Pub](https://img.shields.io/pub/v/edeskyclient.svg?style=flat-square)](https://pub.dartlang.org/packages/edeskyclient)
[![Build Status](https://travis-ci.com/janstol/edeskyclient_dart.svg?branch=master)](https://travis-ci.com/janstol/edeskyclient_dart)

Dart client for Czech service [edesky.cz API](https://edesky.cz/api). Supports dashboards and documents querying.

## Usage

```yaml
dependencies:
    edeskyclient: ^1.0.1+1

```

```dart
import 'package:edesky/edesky.dart';
import 'package:http/http.dart';

Future<void> main() async {
  final edesky = EdeskyClient(
    apiKey: 'xyz', //insert your api key
    httpClient: Client(),
  );

  // Fetch all dashboards
  final dashboards = await edesky.queryDashboards();
  print(dashboards.first.name);

  // ...

  // Fetch single dashboard by ID
  final dashboard = await edesky.queryDashboard(1);
  print(dashboard.name);

  // ...

  // Search documents
  final searchResult = await edesky.queryDocuments(keywords: 'prodej');
  print("${searchResult.first.name}, ${searchResult.first.url}");

  // close http client when it's done being used
  edesky.close();

  // ...
}
```

## Features and bugs

Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: https://github.com/janstol/edeskyclient_dart/issues
