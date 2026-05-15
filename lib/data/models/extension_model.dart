class ExtensionModel {
  final String name;
  final String pkgName;
  final String version;
  final String lang;
  final String type; // manga, manhwa, anime, novel
  final String scriptUrl;
  final bool isInstalled;

  ExtensionModel({
    required this.name,
    required this.pkgName,
    required this.version,
    required this.lang,
    required this.type,
    required this.scriptUrl,
    this.isInstalled = false,
  });

  factory ExtensionModel.fromJson(Map<String, dynamic> json, {bool isInstalled = false}) {
    return ExtensionModel(
      name: json['name'] ?? '',
      pkgName: json['pkg_name'] ?? '',
      version: json['version'] ?? '',
      lang: json['lang'] ?? '',
      type: json['type'] ?? '',
      scriptUrl: json['script_url'] ?? '',
      isInstalled: isInstalled,
    );
  }

  ExtensionModel copyWith({bool? isInstalled}) {
    return ExtensionModel(
      name: name,
      pkgName: pkgName,
      version: version,
      lang: lang,
      type: type,
      scriptUrl: scriptUrl,
      isInstalled: isInstalled ?? this.isInstalled,
    );
  }
}

// Result model for our Scraper
class ScrapedMedia {
  final String title;
  final String url;
  final String imageUrl;
  final String sourceName;

  ScrapedMedia({
    required this.title,
    required this.url,
    required this.imageUrl,
    required this.sourceName
  });
}