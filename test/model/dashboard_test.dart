import 'package:edeskyclient/edeskyclient.dart';
import 'package:test/test.dart';
import 'package:xml/xml.dart';

import '../fixtures/fixture.dart';

// ignore_for_file: prefer_const_constructors
void main() {
  test('should parse an model from XML', () {
    final xml = XmlDocument.parse(fixture('dashboards.xml'))
        .findAllElements('dashboard')
        .first;

    expect(Dashboard.fromXML(xml), testDashboardCity);
  });

  test('copyWith creates copy with updated values', () {
    final original = testDashboardCity;
    final copy = original.copyWidth(name: 'Some name');

    expect(original.id, copy.id);
    expect(original.url, copy.url);
    expect(original.abbreviation, copy.abbreviation);
    expect(original.ico, copy.ico);
    expect(original.category, copy.category);
    expect(original.nuts3Id, copy.nuts3Id);
    expect(original.nuts3Name, copy.nuts3Name);
    expect(original.nuts4Id, copy.nuts4Id);
    expect(original.nuts4Name, copy.nuts4Name);
    expect(original.parentId, copy.parentId);
    expect(original.parentName, copy.parentName);
    expect(original.ruianCode, copy.ruianCode);
    expect(copy.name, 'Some name');
  });

  test('equality', () {
    final first = testDashboardInstitution;
    final second = Dashboard(
      id: first.id,
      name: first.name,
      category: first.category,
      url: first.url,
      nuts3Id: first.nuts3Id,
      nuts3Name: first.nuts3Name,
      nuts4Id: first.nuts4Id,
      nuts4Name: first.nuts4Name,
      ico: first.ico,
      abbreviation: first.abbreviation,
      parentId: first.parentId,
      parentName: first.parentName,
      ruianCode: first.ruianCode,
    );

    expect(first, second);
  });

  test('toString returns correct value', () {
    final model = testDashboardStructure;
    expect(
      model.toString(),
      'Dashboard[${model.id}, ${model.name}, ${model.category}, ${model.url}, '
      'parent: ${model.parentName}]',
    );
  });
}
