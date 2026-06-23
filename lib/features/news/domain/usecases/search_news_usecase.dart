import 'package:newsapp/features/news/domain/entities/news_entity.dart';
import 'package:newsapp/features/news/domain/repositories/news_repository.dart';

class SearchNewsUsecase {
  final NewsRepository repository;

  SearchNewsUsecase(this.repository);

 Future<List<NewsEntity>> call({
    required String query,
    required int page,
  })
  {
    return repository.searchNews( 
      query : query, 
      page :page,
      );
  }

  
}