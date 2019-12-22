import 'package:meta/meta.dart';
import 'package:xml/xml.dart';

/// Attachment in document
class Attachment {
  /// Attachment ID
  final int id;

  /// Attachment name/title
  final String name;

  /// Mime type of attachment
  final String mimeType;

  /// Edesky URL
  final String url;

  /// Original attachment URL
  final String origUrl;

  final bool containsText;

  const Attachment({
    @required this.id,
    @required this.name,
    @required this.mimeType,
    @required this.url,
    @required this.origUrl,
    @required this.containsText,
  });

  /// Creates attachment from parsed XML.
  Attachment.fromXML(XmlElement element)
      : this(
          id: int.tryParse(element.getAttribute('edesky_id')),
          name: element.getAttribute('name'),
          mimeType: element.getAttribute('mimetype'),
          url: element.getAttribute('url'),
          origUrl: element.getAttribute('orig_url'),
          containsText: element.getAttribute('contains_text') == '1',
        );

  /// Creates a copy of this attachment but with the given fields replaced with
  /// the new values.
  Attachment copyWith({
    int id,
    String name,
    String mimeType,
    String url,
    String origUrl,
    bool containsText,
  }) {
    return Attachment(
      id: id ?? this.id,
      name: name ?? this.name,
      mimeType: mimeType ?? this.mimeType,
      url: url ?? this.url,
      origUrl: origUrl ?? this.origUrl,
      containsText: containsText ?? this.containsText,
    );
  }

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      mimeType.hashCode ^
      url.hashCode ^
      origUrl.hashCode ^
      containsText.hashCode;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is Attachment &&
            id == other.id &&
            name == other.name &&
            mimeType == other.mimeType &&
            url == other.url &&
            origUrl == other.origUrl &&
            containsText == other.containsText;
  }

  @override
  String toString() {
    return 'Attachment<$id, $name, $origUrl, $mimeType, '
        'containsText: $containsText>';
  }
}
