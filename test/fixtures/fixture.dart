import 'dart:io';
import 'package:edeskyclient/src/model/attachment.dart';
import 'package:edeskyclient/src/model/dashboard.dart';
import 'package:edeskyclient/src/model/document.dart';
import 'package:path/path.dart';

String fixture(String name) =>
    File("$_testDirectory/fixtures/$name").readAsStringSync();

const String testApiKey = "XYZ123abc";

const String errorNotLoggedIn = "Chyba: nepřihlášen. Použijte svůj API klíč, "
    "který najdete pro přihlášení na https://edesky.cz/uzivatel/edit";

Dashboard createTestDashboardCity() {
  return const Dashboard(
    id: 1,
    name: "Město Olomouc",
    category: "samosprava",
    url: "https://edesky.cz/desky/1",
    nuts3Id: 28,
    nuts3Name: "Olomoucký kraj",
    nuts4Id: 972,
    nuts4Name: "Okres Olomouc",
    ico: 299308,
    abbreviation: "Olomouc",
    parentId: 972,
    parentName: "Okres Olomouc",
    ruianCode: 500496,
  );
}

Dashboard createTestDashboardRegion() {
  return const Dashboard(
    id: 28,
    name: "Olomoucký kraj",
    category: "samosprava",
    url: "https://edesky.cz/desky/28",
    nuts3Id: 28,
    nuts3Name: "Olomoucký kraj",
    nuts4Id: null,
    nuts4Name: null,
    ico: 60609460,
    abbreviation: "KUOlomouc",
    parentId: 113,
    parentName: "Morava",
    ruianCode: 124,
  );
}

Dashboard createTestDashboardStructure() {
  return const Dashboard(
    id: 59,
    name: "Praha",
    category: "struktura",
    url: "https://edesky.cz/desky/59",
    nuts3Id: null,
    nuts3Name: null,
    nuts4Id: null,
    nuts4Name: null,
    ico: 49710052,
    abbreviation: null,
    parentId: null,
    parentName: null,
    ruianCode: 19,
  );
}

Dashboard createTestDashboardInstitution() {
  return const Dashboard(
    id: 1231,
    name: "Ministerstvo financí",
    category: "instituce",
    url: "https://edesky.cz/desky/1231",
    nuts3Id: null,
    nuts3Name: null,
    nuts4Id: null,
    nuts4Name: null,
    ico: 6947,
    abbreviation: "MFinanci",
    parentId: 1227,
    parentName: "Ministerstva",
    ruianCode: null,
  );
}

Document createTestDocument() {
  return const Document(
    id: 3312051,
    name: 'rozhodnutí - společné povolení (U+S): '
        '"Palackého třída, Chrudim - podélné parkování"',
    url: "https://edesky.cz/dokument/3312051",
    origUrl:
        "http://edeska.chrudim-city.cz/eDeska/eDeskaDetail.jsp?detailId=10787",
    textUrl: "https://edesky.cz/dokument/3312051.txt",
    createdAt: "2019-10-10 17:10:14 +0200",
    dashboardId: 97,
    attachments: [
      Attachment(
        id: 4875071,
        name: "2019-002720.pdf",
        url: "https://edesky.cz/dokument/3312051#priloha_4875071",
        origUrl:
            "http://edeska.chrudim-city.cz/eDeska/download.jsp?idPriloha=11257",
        containsText: true,
        mimeType: "application/pdf",
      ),
    ],
  );
}

// From https://github.com/flutter/flutter/issues/20907#issuecomment-466185328
final _testDirectory = join(
  Directory.current.path,
  Directory.current.path.endsWith('test') ? '' : 'test',
);
