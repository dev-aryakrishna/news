import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:newsapp/core/connectivity/connectivity_cubit.dart';
import 'package:newsapp/core/localization/localization_service.dart';
import 'package:newsapp/core/themes/app_theme.dart';
import 'package:newsapp/core/widgets/connectivity_wrapper.dart';
import 'package:newsapp/dependency_injection/injection.dart';
import 'package:newsapp/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:newsapp/l10n/app_localizations.dart';
import 'package:newsapp/routes/app_router.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<AuthBloc>()),
        BlocProvider(create: (_) => sl<ConnectivityCubit>()),
      ],
      child: ListenableBuilder(
        listenable: sl<LocalizationService>(),
        builder: (context, _) {
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            title: 'News App',
            theme: AppTheme.lightTheme,
            routerConfig: appRouter,
            locale: sl<LocalizationService>().currentLocale,
            supportedLocales: LocalizationService.supportedLocales,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            builder: (context, child) {
              return ConnectivityWrapper(
                child: child ?? const SizedBox(),
              );
            },
          );
        },
      ),
    );
  }
}