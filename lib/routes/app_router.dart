import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../features/news/domain/entities/news_entity.dart';
import '../dependency_injection/injection.dart';
import '../features/news/presentation/bloc/news_bloc.dart';
import '../features/auth/presentation/pages/login_page.dart';
import '../features/auth/presentation/pages/signup_page.dart';
import '../features/auth/presentation/pages/splash_page.dart';
import '../features/news/presentation/pages/news_detail_page.dart';
import '../features/news/presentation/pages/news_list_page.dart';
import '../features/news/presentation/bloc/news_event.dart';
import '../features/settings/pages/language_select_page.dart';
import 'route_names.dart';

final appRouter = GoRouter(
  initialLocation: RouteNames.splash,
  routes: [
    GoRoute(
      path: RouteNames.splash,
      builder: (context, state) => const SplashPage(),
    ),
    GoRoute(
      path: RouteNames.login,
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: RouteNames.signup,
      builder: (context, state) => const SignupPage(),
    ),
    GoRoute(
      path: RouteNames.news,
      builder: (context, state) => BlocProvider(
        create: (_) =>
            sl<NewsBloc>()..add(FetchTopHeadlines()), // 👈 only change
        child: const NewsListPage(),
      ),
    ),
    GoRoute(
      path: RouteNames.newsDetail,
      builder: (context, state) =>
          NewsDetailPage(article: state.extra as NewsEntity),
    ),
    GoRoute(
      path: RouteNames.languageSelect,
      builder: (context, state) => const LanguageSelectPage(),
    ),
  ],
);
