enum LinkType { facebook, google, apple }

extension LinkTypeExtension on LinkType {
  String get name {
    switch (this) {
      case LinkType.facebook:
        return 'Facebook';
      case LinkType.google:
        return 'Google';
      case LinkType.apple:
        return 'Apple';
      }
  }
}

LinkType getLinkType(String linkType) {
  switch (linkType) {
    case 'LinkType.facebook':
      return LinkType.facebook;
    case 'LinkType.google':
      return LinkType.google;
    case 'LinkType.apple':
      return LinkType.apple;
    default:
      return LinkType.google;
  }
}
