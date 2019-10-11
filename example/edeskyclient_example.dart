import 'package:edeskyclient/edeskyclient.dart';
import 'package:http/http.dart';

Future<void> main() async {
  final edesky = EdeskyClient(
    httpClient: Client(),
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
