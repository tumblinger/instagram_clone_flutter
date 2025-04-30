enum MediaTypes {video, image}

class Media {
  final String value;
  final MediaTypes type;

  Media({
    required this.value,
    required this.type,
});
}
