import 'package:meta/meta.dart';
import 'package:xml/xml.dart';

/// Official notice board
class Dashboard {
  /// Dashboard ID
  int id;

  /// Dashboard category (samosprava, struktura, instituce)
  String category;

  /// Edesky URL
  /// (https://edesky.cz/desky/<id>)
  String url;

  /// Dashboard name
  String name;

  /// Region ID
  /// (Nomenclature of Units for Territorial Statistics)
  int nuts3Id;

  /// Region name
  /// (Nomenclature of Units for Territorial Statistics)
  String nuts3Name;

  /// District ID
  /// (Nomenclature of Units for Territorial Statistics)
  int nuts4Id;

  /// District name
  /// (Nomenclature of Units for Territorial Statistics)
  String nuts4Name;

  /// Public authority identification number (ICO)
  int ico;

  /// Public authority abbreviation
  String abbreviation;

  /// ID of parent dashboard
  int parentId;

  /// Name of parent dashboard
  String parentName;

  /// RUIAN code
  /// (Registry of Territorial Identification, Addresses and Real Estate(
  int ruianCode;

  Dashboard({
    @required this.id,
    @required this.category,
    @required this.url,
    @required this.name,
    @required this.nuts3Id,
    @required this.nuts3Name,
    @required this.nuts4Id,
    @required this.nuts4Name,
    @required this.ico,
    @required this.abbreviation,
    @required this.parentId,
    @required this.parentName,
    @required this.ruianCode,
  });

  /// Creates dashboard from parsed XML
  Dashboard.fromXML(XmlElement element) {
    id = int.tryParse(element.getAttribute('edesky_id'));
    name = element.getAttribute('name');
    category = element.getAttribute('category');
    url = element.getAttribute('edesky_url');
    nuts3Id = element.getAttribute('nuts3_id') != null
        ? int.tryParse(element.getAttribute('nuts3_id'))
        : null;
    nuts3Name = element.getAttribute('nuts3_name');
    nuts4Id = element.getAttribute('nuts4_id') != null
        ? int.tryParse(element.getAttribute('nuts4_id'))
        : null;
    nuts4Name = element.getAttribute('nuts4_name');
    ico = element.getAttribute('ovm_ico') != null
        ? int.tryParse(element.getAttribute('ovm_ico'))
        : null;
    abbreviation = element.getAttribute('ovm_zkratka');
    parentId = element.getAttribute('parent_id') != null
        ? int.tryParse(element.getAttribute('parent_id'))
        : null;
    parentName = element.getAttribute('parent_name');
    ruianCode = element.getAttribute('ruian_kod') != null
        ? int.tryParse(element.getAttribute('ruian_kod'))
        : null;
  }

  @override
  String toString() {
    return "Dashboard[$id, $name, $category, $url, parent: $parentName]";
  }
}
