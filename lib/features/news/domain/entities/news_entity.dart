import 'package:equatable/equatable.dart';

class NewsEntity extends Equatable {
  final String title;
  final String description;
  final String content;
  final String imageUrl;
  final String author;
  final String source;
  final String publishedAt;
  final String articleUrl;

  const NewsEntity({
    required this.title,
    required this.description,
    required this.content,
    required this.imageUrl,
    required this.author,
    required this.source,
    required this.publishedAt,
    required this.articleUrl,
  });

  @override
  List<Object?> get props => [
        title,
        description,
        content,
        imageUrl,
        author,
        source,
        publishedAt,
        articleUrl,
      ];
}