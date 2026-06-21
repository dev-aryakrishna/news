import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:newsapp/core/services/local_storage_service.dart';
import 'package:newsapp/core/network/dio_client.dart';
import 'package:newsapp/core/services/connectivity_service.dart';
import 'package:newsapp/core/connectivity/connectivity_cubit.dart';
import 'package:newsapp/core/localization/localization_service.dart';
import 'package:newsapp/features/auth/data/datasource/auth_remote_datasource.dart';
import 'package:newsapp/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:newsapp/features/auth/domain/repositories/auth_repository.dart';
import 'package:newsapp/features/auth/domain/usecases/login_usecase.dart';
import 'package:newsapp/features/auth/domain/usecases/signup_usecase.dart';
import 'package:newsapp/features/auth/domain/usecases/logout_usecase.dart';
import 'package:newsapp/features/auth/domain/usecases/is_logged_in_usecase.dart';
import 'package:newsapp/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:newsapp/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:newsapp/features/auth/presentation/bloc/login/login_bloc.dart';
import 'package:newsapp/features/auth/presentation/bloc/signup/signup_bloc.dart';
import 'package:newsapp/features/news/data/datasource/news_remote_datasource.dart';
import 'package:newsapp/features/news/data/repositories/news_repository_impl.dart';
import 'package:newsapp/features/news/domain/repositories/news_repository.dart';
import 'package:newsapp/features/news/presentation/bloc/news_bloc.dart';

final sl = GetIt.instance;

Future<void> configureDependencies() async {
  final prefs = await SharedPreferences.getInstance();

  // Core
  sl.registerLazySingleton<SharedPreferences>(() => prefs);
  sl.registerLazySingleton<LocalStorageService>(
    () => LocalStorageServiceImpl(sl<SharedPreferences>()),
  );

  // Supabase
  sl.registerLazySingleton<SupabaseClient>(() => Supabase.instance.client);

  // Auth DataSource
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(sl<SupabaseClient>()),
  );

  // Auth Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(sl<AuthRemoteDataSource>()),
  );

  sl.registerLazySingleton(() => LoginUseCase(sl<AuthRepository>()));
  sl.registerLazySingleton(() => SignUpUseCase(sl<AuthRepository>()));
  sl.registerLazySingleton(() => LogoutUseCase(sl<AuthRepository>()));
  sl.registerLazySingleton(() => IsLoggedInUseCase(sl<AuthRepository>()));
  sl.registerLazySingleton(() => GetCurrentUserUseCase(sl<AuthRepository>()));

  sl.registerFactory<LoginBloc>(
    () => LoginBloc(loginUseCase: sl<LoginUseCase>()),
  );
  sl.registerFactory<SignupBloc>(
    () => SignupBloc(signUpUseCase: sl<SignUpUseCase>()),
  );
  sl.registerFactory<AuthBloc>(
    () => AuthBloc(
      logoutUseCase: sl<LogoutUseCase>(),
      isLoggedInUseCase: sl<IsLoggedInUseCase>(),
      getCurrentUserUseCase: sl<GetCurrentUserUseCase>(),
    ),
  );

  // Network
  sl.registerLazySingleton<DioClient>(() => DioClient());

  // News DataSource
  sl.registerLazySingleton<NewsRemoteDataSource>(
    () => NewsRemoteDataSourceImpl(sl<DioClient>()),
  );

  // News Repository
  sl.registerLazySingleton<NewsRepository>(
    () => NewsRepositoryImpl(
      sl<NewsRemoteDataSource>(),
      sl<LocalStorageService>(),
    ),
  );

  // News Bloc
  sl.registerFactory<NewsBloc>(
    () => NewsBloc(newsRepository: sl<NewsRepository>()),
  );

  // Connectivity
  sl.registerLazySingleton<Connectivity>(() => Connectivity());
  sl.registerLazySingleton<ConnectivityService>(
    () => ConnectivityService(sl<Connectivity>()),
  );
  sl.registerFactory<ConnectivityCubit>(
    () => ConnectivityCubit(connectivityService: sl<ConnectivityService>()),
  );

  // Localization
  sl.registerLazySingleton<LocalizationService>(
    () => LocalizationService(sl<SharedPreferences>()),
  );
}