import 'package:edeskyclient/edeskyclient.dart';
import 'package:test/test.dart';
import 'package:xml/xml.dart';

import '../fixtures/fixture.dart';

// ignore_for_file: prefer_const_constructors
void main() {
  test('should parse an model from XML', () {
    final xml = XmlDocument.parse(fixture('documents.xml'))
        .findAllElements('document')
        .first;

    expect(Document.fromXML(xml), testDocument);
  });

  test('copyWith creates copy with updated values', () {
    final original = testDocument;
    final copy = original.copyWith(name: 'Some name');

    expect(original.id, copy.id);
    expect(original.dashboardId, copy.dashboardId);
    expect(original.url, copy.url);
    expect(original.origUrl, copy.origUrl);
    expect(original.textUrl, copy.textUrl);
    expect(original.attachments, copy.attachments);
    expect(copy.name, 'Some name');
  });

  test('equality', () {
    final first = testDocument;
    final second = Document(
        id: first.id,
        name: first.name,
        url: first.url,
        origUrl: first.origUrl,
        textUrl: first.textUrl,
        createdAt: first.createdAt,
        dashboardId: first.dashboardId,
        attachments: first.attachments);

    expect(first, second);
  });

  test('toString returns correct value', () {
    final model = testDocument;
    expect(
      model.toString(),
      'Document(${model.id}, ${model.name}, ${model.url}, '
      'att: ${model.attachments})',
    );
  });
}
