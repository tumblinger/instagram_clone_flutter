import 'package:instagram_clone/home/media.dart';

class Posts {
  final String userName;
  final String avatar;
  final List <Media> media;
  final String caption;
  final int likes;
  final int shares;
  final int comments;
  final DateTime createdAt;
  final DateTime updatedAt;

  Posts ({
    required this.userName,
    required this.avatar,
    required this.media,
    required this.caption,
    required this.likes,
    required this.shares,
    required this.comments,
    required this.createdAt,
    required this.updatedAt,
});
}
