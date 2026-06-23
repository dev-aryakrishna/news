import 'package:newsapp/features/news/domain/entities/news_entity.dart';
import 'package:newsapp/features/news/domain/repositories/news_repository.dart';

class GetTopHeadlineUsecase {
  final NewsRepository repository;

  GetTopHeadlineUsecase(this.repository);

  Future<List<NewsEntity>> call({
    required int page
  })
  {
    return repository.getTopHeadlines(page :page);
  }
}