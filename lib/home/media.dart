enum MediaTypes {video, image}

class Media {
  final String value;
  final MediaTypes type;

  Media({
    required this.value,
    required this.type,
});
  factory Media.fromMap(Map<String, dynamic> mediaMap) {
    return Media(
      value: mediaMap['value'] as String,
      type: _stringToMediaType(mediaMap['type']),
    );
  }
  static MediaTypes _stringToMediaType(String stringMediaType) {
    switch (stringMediaType) {
      case 'image':
        return MediaTypes.image;
      case 'video':
        return MediaTypes.video;
      default:
        throw ArgumentError('Unknown media type - $stringMediaType');
    }
  }
}
