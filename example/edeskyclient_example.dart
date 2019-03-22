import 'package:edeskyclient/edeskyclient.dart';

main() async {
  final edesky = EdeskyClient(
    apiKey: 'xyz', //insert your api key
  );

  // Fetch all dashboards
//  final dashboards = await edesky.queryDashboards();
//  print(dashboards.first.name);

  // ...

  // Fetch single dashboard by ID
  final dashboard = await edesky.queryDashboard(1);
  print(dashboard.name);

  // ...

  // Search documents
//  final searchResult = await edesky.queryDocuments(keywords: 'prodej');
//  print("${searchResult.first.name}, ${searchResult.first.url}");

  // close http client when it's done being used
  edesky.close();

  // ...
}
