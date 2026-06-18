import 'package:equatable/equatable.dart';

abstract class NewsEvent extends Equatable {
  const NewsEvent();

  @override
  List<Object?> get props => [];
}

class FetchTopHeadlines extends NewsEvent {}

class RefreshNews extends NewsEvent {}

class SearchNews extends NewsEvent {
  final String query;

  const SearchNews(this.query);

  @override
  List<Object?> get props => [query];
}

class LoadMoreNews extends NewsEvent {}