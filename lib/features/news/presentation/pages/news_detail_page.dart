    import 'package:flutter/material.dart';
    import 'package:url_launcher/url_launcher.dart';
    import 'package:cached_network_image/cached_network_image.dart';
    import 'package:newsapp/l10n/app_localizations.dart';

    import '../../domain/entities/news_entity.dart';

    class NewsDetailPage extends StatelessWidget {
      final NewsEntity article;

      const NewsDetailPage({super.key, required this.article});


      Future<void> _openArticle(BuildContext context) async {
        if (article.articleUrl.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No article URL available')),
          );
          return;
        }

        final uri = Uri.parse(article.articleUrl);

        await launchUrl(
          uri,
          mode: LaunchMode.externalApplication, 
        );
      }

      @override
      Widget build(BuildContext context) {
        final l10n = AppLocalizations.of(context);

        return Scaffold(
          appBar: AppBar(
            title: Text(l10n.source),
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                article.imageUrl.isNotEmpty
                    ? CachedNetworkImage(
                        imageUrl: article.imageUrl,
                        width: double.infinity,
                        height: 250,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          height: 250,
                          alignment: Alignment.center,
                          child: const CircularProgressIndicator(),
                        ),
                        errorWidget: (context, url, error) => Container(
                          height: 250,
                          color: Colors.grey.shade300,
                          alignment: Alignment.center,
                          child: const Icon(Icons.broken_image, size: 50),
                        ),
                      )
                    : Container(
                        width: double.infinity,
                        height: 250,
                        color: Colors.grey.shade300,
                        alignment: Alignment.center,
                        child: const Icon(Icons.image_not_supported, size: 50),
                      ),

                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        article.title.isNotEmpty ? article.title : l10n.noContent,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 12),

                      Row(
                        children: [
                          const Icon(Icons.person, size: 16, color: Colors.grey),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              article.author.isNotEmpty
                                  ? article.author
                                  : l10n.unknownAuthor,
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      Row(
                        children: [
                          const Icon(Icons.calendar_today,
                              size: 16, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text(
                            article.publishedAt.isNotEmpty
                                ? article.publishedAt
                                : l10n.publishedAt,
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      Row(
                        children: [
                          const Icon(Icons.source, size: 16, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text(
                            article.source.isNotEmpty
                                ? article.source
                                : l10n.unknownSource,
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),

                      const Divider(height: 32),

                      Text(
                        article.description.isNotEmpty
                            ? article.description
                            : l10n.noDescription,
                        style: const TextStyle(fontSize: 16, height: 1.5),
                      ),

                      const SizedBox(height: 16),

                      Text(
                        article.content.isNotEmpty
                            ? article.content
                            : l10n.noContent,
                        style: const TextStyle(fontSize: 15, height: 1.5),
                      ),

                      const SizedBox(height: 24),

              
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () => _openArticle(context),
                          icon: const Icon(Icons.open_in_new),
                          label: Text(l10n.readMore),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }
    }