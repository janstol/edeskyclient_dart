# Edesky client

Dart client for [edesky.cz API](https://edesky.cz/api)

## Usage

```yaml
dependencies:
    edeskyclient: ^0.0.1

```

```dart
import 'package:edesky/edesky.dart';

main() async {
  final edesky = EdeskyClient(
    apiKey: 'xyz', //insert your api key
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
