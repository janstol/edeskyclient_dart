import 'package:collection/collection.dart';
import 'package:edeskyclient/src/model/attachment.dart';
import 'package:meta/meta.dart';
import 'package:xml/xml.dart';

/// Document on official notice board
class Document {
  /// Document ID
  final int id;

  /// Document name/title
  final String name;

  /// Creation date and time
  /// (YYYY-MM-DD hh:mm:ss TZD, eg. 2019-03-17 15:56:45 +0100)
  final String createdAt;

  /// Edesky URL
  /// (https://edesky.cz/dokument/....)
  final String url;

  /// Original document URL
  final String origUrl;

  /// Plain text URL
  final String textUrl;

  /// Dashboard ID
  final int dashboardId;

  /// List of [Attachment]
  final List<Attachment> attachments;

  const Document({
    @required this.id,
    @required this.name,
    @required this.createdAt,
    @required this.url,
    @required this.origUrl,
    @required this.textUrl,
    @required this.dashboardId,
    @required this.attachments,
  });

  /// Creates document from parsed XML.
  Document.fromXML(XmlElement element)
      : this(
          id: int.tryParse(element.getAttribute("edesky_id")),
          name: element.getAttribute("name"),
          createdAt: element.getAttribute("created_at"),
          url: element.getAttribute("edesky_url"),
          origUrl: element.getAttribute("orig_url"),
          textUrl: element.getAttribute("edesky_text_url"),
          dashboardId: int.tryParse(element.getAttribute("dashboard_id")),
          attachments: element
              .findAllElements("attachment")
              .map((el) => Attachment.fromXML(el))
              .toList(),
        );

  /// Creates a copy of this document but with the given fields replaced with
  /// the new values.
  Document copyWith({
    int id,
    String name,
    String createdAt,
    String url,
    String origUrl,
    String textUrl,
    int dashboardId,
    List<Attachment> attachments,
  }) {
    return Document(
      id: id ?? this.id,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
      url: url ?? this.url,
      origUrl: origUrl ?? this.origUrl,
      textUrl: textUrl ?? this.textUrl,
      dashboardId: dashboardId ?? this.dashboardId,
      attachments: attachments ?? this.attachments,
    );
  }

  // helper for comparing lists
  static const _listEquality = ListEquality<Attachment>();

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      createdAt.hashCode ^
      url.hashCode ^
      origUrl.hashCode ^
      textUrl.hashCode ^
      dashboardId.hashCode ^
      _listEquality.hash(attachments);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is Document &&
            id == other.id &&
            name == other.name &&
            createdAt == other.createdAt &&
            url == other.url &&
            origUrl == other.origUrl &&
            textUrl == other.textUrl &&
            dashboardId == other.dashboardId &&
            _listEquality.equals(attachments, other.attachments);
  }

  @override
  String toString() {
    return "Document($id, $name, $url, att: $attachments)";
  }
}
