import 'package:edeskyclient/edeskyclient.dart';
import 'package:test/test.dart';
import 'package:xml/xml.dart';

import '../fixtures/fixture.dart';

// ignore_for_file: prefer_const_constructors
void main() {
  test('should parse an model from XML', () {
    final xml = XmlDocument.parse(fixture('attachment.xml'))
        .findElements('attachment')
        .single;

    expect(Attachment.fromXML(xml), testAttachment);
  });

  test('copyWith creates copy with updated values', () {
    final original = testAttachment;
    final copy = original.copyWith(name: 'Some name');

    expect(original.id, copy.id);
    expect(original.mimeType, copy.mimeType);
    expect(original.url, copy.url);
    expect(original.origUrl, copy.origUrl);
    expect(original.containsText, copy.containsText);
    expect(copy.name, 'Some name');
  });


  test('equality', () {
    final first = testAttachment;
    final second = Attachment(
      id: first.id,
      name: first.name,
      url: first.url,
      origUrl: first.origUrl,
      containsText: first.containsText,
      mimeType: first.mimeType,
    );

    expect(first, second);
  });

  test('toString returns correct value', () {
    final attachment = testAttachment;
    expect(
        attachment.toString(),
        'Attachment<${attachment.id}, ${attachment.name}, '
        '${attachment.origUrl}, ${attachment.mimeType}, '
        'containsText: ${attachment.containsText}>');
  });
}
