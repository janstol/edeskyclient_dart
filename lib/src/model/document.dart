import 'package:edeskyclient/src/model/attachment.dart';
import 'package:meta/meta.dart';
import 'package:xml/xml.dart';

/// Document on official notice board
class Document {
  /// Document ID
  int id;

  /// Document name/title
  String name;

  /// Creation date and time
  /// (YYYY-MM-DD hh:mm:ss TZD, eg. 2019-03-17 15:56:45 +0100)
  String createdAt;

  /// Edesky URL
  /// (https://edesky.cz/dokument/....)
  String url;

  /// Original document URL
  String origUrl;

  /// Plain text URL
  String textUrl;

  /// Dashboard ID
  int dashboardId;

  /// List of [Attachment]
  List<Attachment> attachments;

  Document({
    @required this.id,
    @required this.name,
    @required this.createdAt,
    @required this.url,
    @required this.origUrl,
    @required this.textUrl,
    @required this.dashboardId,
    @required this.attachments,
  });

  /// Creates document from parsed XML
  Document.fromXML(XmlElement element) {
    id = int.tryParse(element.getAttribute('edesky_id'));
    name = element.getAttribute('dashboard_name');
    createdAt = element.getAttribute('created_at');
    url = element.getAttribute('edesky_url');
    origUrl = element.getAttribute('orig_url');
    textUrl = element.getAttribute('text_url');
    dashboardId = int.tryParse(element.getAttribute('dashboard_id'));

    attachments = element
        .findAllElements('attachment')
        .map((el) => Attachment.fromXML(el))
        .toList();
  }

  @override
  String toString() {
    return "Document[$id, $name, $url, att: $attachments]";
  }
}
