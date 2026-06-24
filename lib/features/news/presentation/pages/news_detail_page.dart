import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:newsapp/l10n/app_localizations.dart';
import 'package:newsapp/features/news/domain/entities/news_entity.dart';
import 'package:newsapp/core/themes/app_spacing.dart';
import 'package:newsapp/core/themes/app_text_styles.dart';
import 'package:newsapp/core/themes/app_colors.dart';

class NewsDetailPage extends StatelessWidget {
  final NewsEntity article;

  const NewsDetailPage({super.key, required this.article});

  Future<void> _openArticle() async {
    final uri = Uri.parse(article.articleUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.newsDetail)),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //  Image section
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
                    child: const Icon(Icons.image_not_supported, size: 50),
                  ),

            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg), //  AppSpacing
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //  Title
                  Text(
                    article.title.isNotEmpty ? article.title : l10n.noTitle,
                    style: AppTextStyles.headlineLarge, //  AppTextStyles
                  ),

                  const SizedBox(height: AppSpacing.md),

                  //  Author
                  Row(
                    children: [
                      const Icon(
                        Icons.person_outline,
                        size: 14,
                        color: AppColors.textHint,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        article.author.isNotEmpty
                            ? article.author
                            : l10n.unknownAuthor,
                        style: AppTextStyles.bodyMedium,
                      ),
                    ],
                  ),

                  const SizedBox(height: AppSpacing.sm),

                  //  Date
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_today_outlined,
                        size: 14,
                        color: AppColors.textHint,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        article.publishedAt.isNotEmpty
                            ? article.publishedAt
                            : l10n.noDate,
                        style: AppTextStyles.bodyMedium,
                      ),
                    ],
                  ),

                  const SizedBox(height: AppSpacing.lg),

                  //  Divider
                  const Divider(),

                  const SizedBox(height: AppSpacing.lg),

                  //  Description
                  Text(
                    article.description.isNotEmpty
                        ? article.description
                        : l10n.noDescription,
                    style: AppTextStyles.bodyLarge,
                  ),

                  const SizedBox(height: AppSpacing.lg),

                  //  Content
                  Text(
                    article.content.isNotEmpty
                        ? article.content
                        : l10n.noContent,
                    style: AppTextStyles.newsContent,
                  ),

                  const SizedBox(height: AppSpacing.xxxl),

                  //  Read Full Article button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: article.articleUrl.isNotEmpty
                          ? _openArticle
                          : null,
                      icon: const Icon(Icons.open_in_new),
                      label: Text(l10n.readFullArticle),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          vertical: AppSpacing.md,
                        ),
                        textStyle: AppTextStyles.labelLarge,
                      ),
                    ),
                  ),

                  const SizedBox(height: AppSpacing.lg),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
