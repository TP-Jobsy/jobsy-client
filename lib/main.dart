import 'dart:async';
import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:jobsy/pages/auth/politic.dart';
import 'package:jobsy/pages/project/favorites/favorites_clients_screen.dart';
import 'package:jobsy/pages/project/favorites/favorites_freelancers_screen.dart';
import 'package:jobsy/pages/project/freelancer_profile_screen_by_id.dart';
import 'package:jobsy/pages/project/freelancer_search_screen.dart';
import 'package:jobsy/pages/project/project_detail_screen_free.dart';
import 'package:jobsy/pages/project/project_detail_screen_free_by_id.dart';
import 'package:jobsy/pages/project/project_freelancer_search/project_search_screen.dart';
import 'package:jobsy/service/ai_service.dart';
import 'package:jobsy/service/avatar_service.dart';
import 'package:jobsy/service/client_project_service.dart';
import 'package:jobsy/service/dashboard_service.dart';
import 'package:jobsy/service/favorite_service.dart';
import 'package:jobsy/service/freelancer_response_service.dart';
import 'package:jobsy/service/freelancer_service.dart';
import 'package:jobsy/service/invitation_service.dart';
import 'package:jobsy/service/project_service.dart';
import 'package:jobsy/service/rating_service.dart';
import 'package:jobsy/service/search_service.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'model/profile/free/freelancer_profile_dto.dart';
import 'pages/project/freelancer_profile_screen.dart';
import 'pages/auth/auth.dart';
import 'pages/auth/reset_password/reset_password_screen.dart';
import 'pages/auth/verification/verification_code_screen.dart';
import 'pages/onboarding/onboarding.dart';
import 'pages/profile-client/activity_field_screen.dart';
import 'pages/profile-client/basic_data_screen.dart';
import 'pages/profile-client/company_info_screen.dart';
import 'pages/profile-client/contact_info_screen.dart';
import 'pages/profile-client/profile_screen.dart';
import 'pages/profile-freelancer/activity_field_screen_free.dart';
import 'pages/profile-freelancer/basic_data_screen_free.dart';
import 'pages/profile-freelancer/contact_info_screen_free.dart';
import 'pages/profile-freelancer/portfolio/link_entry_screen.dart';
import 'pages/profile-freelancer/portfolio/new_project_screen.dart';
import 'pages/profile-freelancer/portfolio/portfolio_screen.dart';
import 'pages/profile-freelancer/profile_screen_free.dart';
import 'pages/project/new_project/new_project_step1_screen.dart';
import 'pages/project/new_project/new_project_step2_screen.dart';
import 'pages/project/new_project/new_project_step3_screen.dart';
import 'pages/project/new_project/new_project_step4_screen.dart';
import 'pages/project/new_project/new_project_step5_screen.dart';
import 'pages/project/new_project/new_project_step6_screen.dart';
import 'pages/project/project_detail_screen.dart';
import 'pages/project/projects_screen.dart';
import 'pages/project/projects_screen_free.dart';
import 'pages/project/selection/category-selections-screen.dart';
import 'pages/project/selection/experience_screen.dart';
import 'pages/project/selection/specialization_selection_screen.dart';
import 'pages/project/skill_search/skill_search_screen.dart';
import 'pages/project/unlogged_project_screen.dart';
import 'pages/role/role_selection.dart';

import 'provider/auth_provider.dart';
import 'provider/client_profile_provider.dart';
import 'provider/freelancer_profile_provider.dart';
import 'service/profile_service.dart';
import 'util/routes.dart';

Future<void> _reportInstallOnce() async {
  final prefs = await SharedPreferences.getInstance();
  final hasReported = prefs.getBool('appmetrica_install_reported') ?? false;
  if (!hasReported) {
    await AppMetrica.reportEvent('app_install');
    await prefs.setBool('appmetrica_install_reported', true);
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final config = AppMetricaConfig('719c22e5-e906-490f-b610-c040a3004be0');
  await AppMetrica.activate(config);
  await _reportInstallOnce();

  await initializeDateFormatting('ru', null);
  final prefs = await SharedPreferences.getInstance();
  // await prefs.remove('seenOnboarding');
  final seenOnboarding = prefs.getBool('seenOnboarding') ?? false;

  final authProvider = AuthProvider();
  await authProvider.ensureLoaded();


  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>.value(value: authProvider),
        ChangeNotifierProxyProvider<AuthProvider, ClientProfileProvider>(
          create: (ctx) {
            final auth = ctx.read<AuthProvider>();
            return ClientProfileProvider(
              authProvider: auth,
              avatarService: AvatarService(
                getToken: () async => auth.token,
                refreshToken: auth.refreshTokens,
              ),
              service: ProfileService(
                getToken: () async => auth.token,
                refreshToken: auth.refreshTokens,
              ),
            );
          },
          update: (ctx, auth, prev) {
            prev!..updateAuth(auth, auth.token ?? '');
            if (auth.isLoggedIn &&
                auth.role == 'CLIENT' &&
                prev.profile == null &&
                !prev.loading) {
              prev.loadProfile();
            }
            return prev;
          },
        ),
        ChangeNotifierProxyProvider<AuthProvider, FreelancerProfileProvider>(
          create: (ctx) {
            final auth = ctx.read<AuthProvider>();
            return FreelancerProfileProvider(
              authProvider: auth,
              token: auth.token ?? '',
              avatarService: AvatarService(
                getToken: () async => auth.token,
                refreshToken: auth.refreshTokens,
              ),
              service: ProfileService(
                getToken: () async => auth.token,
                refreshToken: auth.refreshTokens,
              ),
            );
          },
          update: (ctx, auth, prev) {
            prev!..updateAuth(auth, auth.token ?? '');
            if (auth.isLoggedIn &&
                auth.role == 'FREELANCER' &&
                prev.profile == null &&
                !prev.loading) {
              prev.loadProfile();
            }
            return prev;
          },
        ),
        Provider<AvatarService>(
          create:
              (ctx) => AvatarService(
            getToken: () async => authProvider.token,
            refreshToken: authProvider.refreshTokens,
          ),
        ),
        Provider<ProfileService>(
          create:
              (ctx) => ProfileService(
            getToken: () async => authProvider.token,
            refreshToken: authProvider.refreshTokens,
          ),
        ),
        Provider<FreelancerService>(
          create:
              (ctx) => FreelancerService(
            getToken: () async => authProvider.token,
            refreshToken: authProvider.refreshTokens,
          ),
        ),
        Provider<SearchService>(
          create:
              (ctx) => SearchService(
                getToken: () async => authProvider.token,
                refreshToken: authProvider.refreshTokens,
              ),
        ),
        Provider<FavoriteService>(
          create:
              (ctx) => FavoriteService(
                getToken: () async => authProvider.token,
                refreshToken: authProvider.refreshTokens,
              ),
        ),
        Provider<ClientProjectService>(
          create:
              (_) => ClientProjectService(
                getToken: () async => authProvider.token,
                refreshToken: authProvider.refreshTokens,
              ),
        ),
        Provider<ProjectService>(
          create:
              (ctx) => ProjectService(
                getToken: () async => authProvider.token,
                refreshToken: authProvider.refreshTokens,
              ),
        ),
        Provider<AiService>(
          create: (ctx) => AiService(
            getToken: () async {
              final auth = ctx.read<AuthProvider>();
              await auth.ensureLoaded();
              return auth.token;
            },
            refreshToken: authProvider.refreshTokens,
          ),
        ),
        Provider<FreelancerResponseService>(
          create:
              (ctx) => FreelancerResponseService(
                getToken: () async => authProvider.token,
                refreshToken: authProvider.refreshTokens,
              ),
        ),
        Provider<InvitationService>(
          create: (ctx) => InvitationService(
            getToken: () async => authProvider.token,
            refreshToken: authProvider.refreshTokens,
          ),
        ),
        Provider<RatingService>(
          create:
              (ctx) => RatingService(
                getToken: () async => authProvider.token,
                refreshToken: authProvider.refreshTokens,
              ),
        ),
        Provider<DashboardService>(
          create:
              (ctx) => DashboardService(
            getToken: () async => authProvider.token,
            refreshToken: authProvider.refreshTokens,
          ),
        ),
      ],
      child: JobsyApp(seenOnboarding: seenOnboarding),
    ),
  );
}

class JobsyApp extends StatelessWidget {
  final bool seenOnboarding;

  const JobsyApp({required this.seenOnboarding, super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    Widget home;
    if (!seenOnboarding) {
      home = const OnboardingScreen();
    } else if (!auth.isLoggedIn) {
      home = const UnloggedScreen();
    } else {
      switch (auth.role) {
        case 'CLIENT':
          home = const ProjectsScreen();
          break;
        case 'FREELANCER':
          home = const ProjectsScreenFree();
          break;
        default:
          home = const UnloggedScreen();
      }
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Jobsy',
      locale: const Locale('ru', 'RU'),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('ru', 'RU')],
      theme: ThemeData(primarySwatch: Colors.blue, fontFamily: 'Inter'),
      home: home,

      routes: {
        Routes.onboarding1: (_) => const OnboardingScreen(),
        Routes.auth: (_) => const AuthScreen(),
        Routes.verify: (_) => const VerificationCodeScreen(),
        Routes.role: (_) => const RoleSelectionScreen(),
        Routes.projects: (_) => const ProjectsScreen(),
        Routes.projectsFree: (_) => const ProjectsScreenFree(),
        Routes.createProjectStep1: (_) => const NewProjectStep1Screen(),
        Routes.profile: (_) => const ProfileScreen(),
        Routes.basicData: (_) => const BasicDataScreen(),
        Routes.activityField: (_) => const ActivityFieldScreen(),
        Routes.contactInfo: (_) => const ContactInfoScreen(),
        Routes.companyInfo: (_) => const CompanyInfoScreen(),
        Routes.profileFree: (_) => const ProfileScreenFree(),
        Routes.activityFieldFree: (_) => const ActivityFieldScreenFree(),
        Routes.basicDataFree: (_) => const BasicDataScreenFree(),
        Routes.contactInfoFree: (_) => const ContactInfoScreenFree(),
        Routes.portfolio: (_) => const PortfolioScreen(),
        Routes.linkEntry: (_) => const LinkEntryScreen(),
        Routes.newProject: (_) => const NewProjectScreen(),
        Routes.resetPassword: (_) => const ResetPasswordScreen(),
        Routes.selectCategory: (_) => CategorySelectionScreen(categories: []),
        Routes.selectSpecialization:
            (_) => SpecializationSelectionScreen(items: [], selected: null),
        Routes.searchSkills: (_) => const SkillSearchScreen(),
        Routes.searchProject: (_) => const ProjectSearchScreen(),
        Routes.experience: (_) => const ExperienceScreen(),
        Routes.unloggedProjects: (_) => const UnloggedScreen(),
        Routes.favorites: (_) => const FavoritesScreen(),
        Routes.projectDetail: (context) {
          final args =
              ModalRoute.of(context)!.settings.arguments
                  as Map<String, dynamic>;
          return ProjectDetailScreen(projectId: args['projectId']);
        },
        Routes.filterProjects: (_) => const ProjectsScreen(),
        Routes.freelancerSearch: (_) => const FreelancerSearchScreen(),
        Routes.favoritesFreelancers: (_) => const FavoritesFreelancersScreen(),

        Routes.politic: (_) => const PoliticScreen(),
      },

      onGenerateRoute: (settings) {
        if (settings.name == Routes.projectDetailFree) {
          final args = settings.arguments;
          if (args is int) {
            return MaterialPageRoute(
              builder: (_) => ProjectDetailScreenFreeById(projectId: args),
            );
          } else if (args is Map<String, dynamic>) {
            return MaterialPageRoute(
              builder: (_) => ProjectDetailScreenFree(projectFree: args),
            );
          } else {
            return MaterialPageRoute(
              builder:
                  (_) => Scaffold(
                    body: Center(
                      child: Text('Неверные аргументы для ProjectDetail'),
                    ),
                  ),
            );
          }
        }
        switch (settings.name) {
          case Routes.createProjectStep2:
            final args = settings.arguments as Map<String, dynamic>;
            return MaterialPageRoute(
              builder:
                  (_) => NewProjectStep2Screen(
                    draftId: args['draftId'],
                    previousData: args['previousData'],
                  ),
            );
          case Routes.createProjectStep3:
            final args = settings.arguments as Map<String, dynamic>;
            return MaterialPageRoute(
              builder:
                  (_) => NewProjectStep3Screen(
                    draftId: args['draftId'],
                    previousData: args['previousData'],
                  ),
            );
          case Routes.createProjectStep4:
            final args = settings.arguments as Map<String, dynamic>;
            return MaterialPageRoute(
              builder:
                  (_) => NewProjectStep4Screen(
                    draftId: args['draftId'],
                    previousData: args['previousData'],
                  ),
            );
          case Routes.createProjectStep5:
            final args = settings.arguments as Map<String, dynamic>;
            return MaterialPageRoute(
              builder:
                  (_) => NewProjectStep5Screen(
                    draftId: args['draftId'],
                    previousData: args['previousData'],
                  ),
            );
          case Routes.createProjectStep6:
            final args = settings.arguments as Map<String, dynamic>;
            return MaterialPageRoute(
              builder:
                  (_) => NewProjectStep6Screen(
                    draftId: args['draftId'],
                    previousData: args['previousData'],
                  ),
            );
          case Routes.freelancerProfileScreen:
            final args = settings.arguments;
            if (args is int) {
              return MaterialPageRoute(
                builder: (_) => FreelancerProfileScreenById(freelancerId: args),
              );
            }
            if (args is FreelancerProfile) {
              return MaterialPageRoute(
                builder: (_) => FreelancerProfileScreen(freelancer: args),
              );
            }
            return MaterialPageRoute(
              builder:
                  (_) => Scaffold(
                    body: Center(child: Text('Неверные аргументы для профиля')),
                  ),
            );

          default:
            return null;
        }
      },
    );
  }
}
