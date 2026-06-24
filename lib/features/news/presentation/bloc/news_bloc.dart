import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsapp/features/news/domain/usecases/get_cached_news_usecase.dart';
import 'package:newsapp/features/news/domain/usecases/get_top_headline_usecase.dart';
import 'package:newsapp/features/news/domain/usecases/search_news_usecase.dart';
import 'news_event.dart';
import 'news_state.dart';
import 'package:newsapp/l10n/app_localizations.dart';



class NewsBloc extends Bloc<NewsEvent, NewsState> {
  final GetTopHeadlineUsecase  getTopHeadlineUsecase;
  final SearchNewsUsecase searchNewsUsecase;
  final GetCachedNewsUsecase getCachedNewsUsecase;


  int currentPage = 1;
  bool hasReachedMax = false;
  bool isLoadingMore = false;

  NewsBloc({
    required this.getTopHeadlineUsecase,
    required this.searchNewsUsecase,
    required this.getCachedNewsUsecase,
  }) : super(NewsInitial()) {
    on<FetchTopHeadlines>(_onFetchTopHeadlines);
    on<RefreshNews>(_onRefreshNews);
    on<SearchNews>(_onSearchNews);
    on<LoadMoreNews>(_onLoadMoreNews);

  }

  Future<void> _onFetchTopHeadlines(
    FetchTopHeadlines event,
    Emitter<NewsState> emit,
  ) async {
    emit(NewsLoading());

    try {
      currentPage = 1;
      final articles = await getTopHeadlineUsecase(page: currentPage);
      emit(NewsLoaded(articles: articles, hasReachedMax: articles.isEmpty));
    } catch (e) {
      
      try {
        final cachedNews = await getCachedNewsUsecase();
        emit(NewsError(
          e.toString(),
          cachedArticles: cachedNews.isNotEmpty ? cachedNews : null,
        ));
      } catch (_) {
        emit(NewsError(e.toString()));
      }
    }
  }

  Future<void> _onRefreshNews(
    RefreshNews event,
    Emitter<NewsState> emit,
  ) async {
    currentPage = 1;
    hasReachedMax = false;
    add(FetchTopHeadlines());
  }

  Future<void> _onSearchNews(
    SearchNews event,
    Emitter<NewsState> emit,
  ) async {
    emit(NewsLoading());

    try {
      currentPage = 1;
      final articles = await searchNewsUsecase(
        query: event.query,
        page: currentPage,
      );
      emit(NewsLoaded(articles: articles, hasReachedMax: articles.isEmpty));
    } catch (e) {
      // On search failure, show cached headlines with offline banner
      try {
        final cachedNews = await getCachedNewsUsecase();
        emit(NewsError(
          e.toString(),
          cachedArticles: cachedNews.isNotEmpty ? cachedNews : null,
        ));
      } catch (_) {
        emit(NewsError(e.toString()));
      }
    }
  }

  Future<void> _onLoadMoreNews(
    LoadMoreNews event,
    Emitter<NewsState> emit,
  
  ) async {
    if (state is! NewsLoaded || isLoadingMore) return;

    final currentState = state as NewsLoaded;

    if (currentState.hasReachedMax) return;

    try {
      currentPage++;
      isLoadingMore = true;

      final articles = await getTopHeadlineUsecase(page: currentPage);
     

      emit(
        NewsLoaded(
          articles: [...currentState.articles, ...articles],
          hasReachedMax: articles.isEmpty,
        ),
      );
      isLoadingMore = false;
    } catch (e) {
      isLoadingMore = false;
      currentPage--; 
      if (state is NewsLoaded) {
        emit(state);
        return;
      }

      emit( NewsError(event.l10n.failedToLoad));
    }
  }
}