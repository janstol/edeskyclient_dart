import 'package:meta/meta.dart';
import 'package:xml/xml.dart';

/// Attachment in document
class Attachment {
  /// Attachment ID
  String id;

  /// Attachment name/title
  String name;

  /// Mime type of attachment
  String mimeType;

  /// Edesky URL
  String url;

  /// Original attachment URL
  String origUrl;

  bool containsText;

  Attachment({
    @required this.id,
    @required this.name,
    @required this.mimeType,
    @required this.url,
    @required this.origUrl,
    @required this.containsText,
  });

  /// Creates attachment from parsed XML
  Attachment.fromXML(XmlElement xml) {
    id = xml.getAttribute('edesky_id');
    name = xml.getAttribute('name');
    mimeType = xml.getAttribute('mimetype');
    url = xml.getAttribute('edesky_url');
    origUrl = xml.getAttribute('orig_url');
    containsText = xml.getAttribute('contains_text') == '1';
  }

  @override
  String toString() {
    return "Attachment[$id, $name, $origUrl, $mimeType, containsText: $containsText]";
  }
}
