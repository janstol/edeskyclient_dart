import 'package:meta/meta.dart';
import 'package:xml/xml.dart';

/// Official notice board
class Dashboard {
  /// Dashboard ID
  final int id;

  /// Dashboard category (samosprava, struktura, instituce)
  final String category;

  /// Edesky URL
  /// (https://edesky.cz/desky/<id>)
  final String url;

  /// Dashboard name
  final String name;

  /// Region ID
  /// (Nomenclature of Units for Territorial Statistics)
  final int nuts3Id;

  /// Region name
  /// (Nomenclature of Units for Territorial Statistics)
  final String nuts3Name;

  /// District ID
  /// (Nomenclature of Units for Territorial Statistics)
  final int nuts4Id;

  /// District name
  /// (Nomenclature of Units for Territorial Statistics)
  final String nuts4Name;

  /// Public authority identification number (ICO)
  final int ico;

  /// Public authority abbreviation
  final String abbreviation;

  /// ID of parent dashboard
  final int parentId;

  /// Name of parent dashboard
  final String parentName;

  /// RUIAN code
  /// (Registry of Territorial Identification, Addresses and Real Estate)
  final int ruianCode;

  const Dashboard({
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

  /// Creates dashboard from parsed XML.
  Dashboard.fromXML(XmlElement element)
      : this(
          id: int.tryParse(element.getAttribute('edesky_id')),
          name: element.getAttribute('name'),
          category: element.getAttribute('category'),
          url: element.getAttribute('edesky_url'),
          nuts3Id: int.tryParse(element.getAttribute('nuts3_id') ?? ''),
          nuts3Name: element.getAttribute('nuts3_name'),
          nuts4Id: int.tryParse(element.getAttribute('nuts4_id') ?? ''),
          nuts4Name: element.getAttribute('nuts4_name'),
          ico: int.tryParse(element.getAttribute('ovm_ico') ?? ''),
          abbreviation: element.getAttribute('ovm_zkratka'),
          parentId: int.tryParse(element.getAttribute('parent_id') ?? ''),
          parentName: element.getAttribute('parent_name'),
          ruianCode: int.tryParse(element.getAttribute('ruian_kod') ?? ''),
        );

  /// Creates a copy of this dashboard but with the given fields replaced with
  /// the new values.
  Dashboard copyWidth({
    int id,
    String category,
    String url,
    String name,
    int nuts3Id,
    String nuts3Name,
    int nuts4Id,
    String nuts4Name,
    int ico,
    String abbreviation,
    int parentId,
    String parentName,
    int ruianCode,
  }) {
    return Dashboard(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      url: url ?? this.url,
      nuts3Id: nuts3Id ?? this.nuts3Id,
      nuts3Name: nuts3Name ?? this.nuts3Name,
      nuts4Id: nuts4Id ?? this.nuts4Id,
      nuts4Name: nuts4Name ?? this.nuts4Name,
      ico: ico ?? this.ico,
      abbreviation: abbreviation ?? this.abbreviation,
      parentId: parentId ?? this.parentId,
      parentName: parentName ?? this.parentName,
      ruianCode: ruianCode ?? this.ruianCode,
    );
  }

  @override
  int get hashCode =>
      id.hashCode ^
      category.hashCode ^
      url.hashCode ^
      name.hashCode ^
      nuts3Id.hashCode ^
      nuts3Name.hashCode ^
      nuts4Id.hashCode ^
      nuts4Name.hashCode ^
      ico.hashCode ^
      abbreviation.hashCode ^
      parentId.hashCode ^
      parentName.hashCode ^
      ruianCode.hashCode;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is Dashboard &&
            id == other.id &&
            category == other.category &&
            url == other.url &&
            name == other.name &&
            nuts3Id == other.nuts3Id &&
            nuts3Name == other.nuts3Name &&
            nuts4Id == other.nuts4Id &&
            nuts4Name == other.nuts4Name &&
            ico == other.ico &&
            abbreviation == other.abbreviation &&
            parentId == other.parentId &&
            parentName == other.parentName &&
            ruianCode == other.ruianCode;
  }

  @override
  String toString() {
    return 'Dashboard[$id, $name, $category, $url, parent: $parentName]';
  }
}
