import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:jobsy/pages/project/favorites-freelancer/favorites_screen.dart';
import 'package:jobsy/pages/project/freelancer_search_screen.dart';
import 'package:jobsy/pages/project/project_detail_screen_free.dart';
import 'package:jobsy/service/ai_service.dart';
import 'package:jobsy/service/client_project_service.dart';
import 'package:jobsy/service/favorite_service.dart';
import 'package:jobsy/service/freelancer_response_service.dart';
import 'package:jobsy/service/search_service.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'pages/project/freelancer_profile_screen.dart';
import 'pages/auth/auth.dart';
import 'pages/auth/password_recovery/password_recovery_screen.dart';
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
import 'pages/project/project_search/project_search_screen.dart';

import 'provider/auth_provider.dart';
import 'provider/client_profile_provider.dart';
import 'provider/freelancer_profile_provider.dart';
import 'service/profile_service.dart';
import 'util/routes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('ru', null);
  final prefs = await SharedPreferences.getInstance();
  // await prefs.remove('seenOnboarding');
  final seenOnboarding = prefs.getBool('seenOnboarding') ?? false;

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(
          create: (_) => AuthProvider(),
        ),
        ChangeNotifierProxyProvider<AuthProvider, ClientProfileProvider>(
          create: (ctx) {
            final auth = ctx.read<AuthProvider>();
            return ClientProfileProvider(
              authProvider: auth,
              token: auth.token ?? '',
            )..loadProfile();
          },
          update: (ctx, auth, previous) {
            previous!
              ..updateAuth(auth, auth.token ?? '')
              ..loadProfile();
            return previous;
          },
        ),
        ChangeNotifierProxyProvider<AuthProvider, FreelancerProfileProvider>(
          create: (ctx) {
            final auth = ctx.read<AuthProvider>();
            return FreelancerProfileProvider(
              service: ProfileService(),
              authProvider: auth,
              token: auth.token ?? '',
            )..loadProfile();
          },
          update: (ctx, auth, previous) {
            previous!
              ..updateAuth(auth, auth.token ?? '')
              ..loadProfile();
            return previous;
          },
        ),
        Provider<SearchService>(create: (_) => SearchService()),
        Provider<FavoriteService>(create: (_) => FavoriteService()),
        Provider<ClientProjectService>(create: (_) => ClientProjectService()),
        Provider<FreelancerResponseService>(
            create: (_) => FreelancerResponseService()),
        Provider<AiService>(create: (_) => AiService()),
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
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Inter',
      ),
      home: home,
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case Routes.onboarding1:
            return MaterialPageRoute(
                builder: (_) => const OnboardingScreen());
          case Routes.auth:
            return MaterialPageRoute(builder: (_) => const AuthScreen());
          case Routes.passwordRecovery:
            return MaterialPageRoute(
                builder: (_) => const PasswordRecoveryScreen());
          case Routes.verify:
            return MaterialPageRoute(
                builder: (_) => const VerificationCodeScreen());
          case Routes.role:
            return MaterialPageRoute(
                builder: (_) => const RoleSelectionScreen());
          case Routes.projects:
            return MaterialPageRoute(builder: (_) => const ProjectsScreen());
          case Routes.projectsFree:
            return MaterialPageRoute(
                builder: (_) => const ProjectsScreenFree());

          case Routes.createProjectStep1:
            return MaterialPageRoute(
              builder: (_) => const NewProjectStep1Screen(),
            );
          case Routes.createProjectStep2:
            final args = settings.arguments as Map<String, dynamic>;
            return MaterialPageRoute(
              builder: (_) => NewProjectStep2Screen(
                draftId: args['draftId'] as int,
                previousData: args['previousData'] as Map<String, dynamic>,
              ),
            );
          case Routes.createProjectStep3:
            final args = settings.arguments as Map<String, dynamic>;
            return MaterialPageRoute(
              builder: (_) => NewProjectStep3Screen(
                draftId: args['draftId'] as int,
                previousData: args['previousData'] as Map<String, dynamic>,
              ),
            );
          case Routes.createProjectStep4:
            final args = settings.arguments as Map<String, dynamic>;
            return MaterialPageRoute(
              builder: (_) => NewProjectStep4Screen(
                draftId: args['draftId'] as int,
                previousData: args['previousData'] as Map<String, dynamic>,
              ),
            );
          case Routes.createProjectStep5:
            final args = settings.arguments as Map<String, dynamic>;
            return MaterialPageRoute(
              builder: (_) => NewProjectStep5Screen(
                draftId: args['draftId'] as int,
                previousData: args['previousData'] as Map<String, dynamic>,
              ),
            );
          case Routes.createProjectStep6:
            final args = settings.arguments as Map<String, dynamic>;
            return MaterialPageRoute(
              builder: (_) => NewProjectStep6Screen(
                draftId: args['draftId'] as int,
                previousData: args['previousData'] as Map<String, dynamic>,
              ),
            );

          case Routes.profile:
            return MaterialPageRoute(builder: (_) => const ProfileScreen());
          case Routes.basicData:
            return MaterialPageRoute(
                builder: (_) => const BasicDataScreen());
          case Routes.activityField:
            return MaterialPageRoute(
                builder: (_) => const ActivityFieldScreen());
          case Routes.contactInfo:
            return MaterialPageRoute(
                builder: (_) => const ContactInfoScreen());
          case Routes.companyInfo:
            return MaterialPageRoute(
                builder: (_) => const CompanyInfoScreen());
          case Routes.profileFree:
            return MaterialPageRoute(
                builder: (_) => const ProfileScreenFree());
          case Routes.activityFieldFree:
            return MaterialPageRoute(
                builder: (_) => const ActivityFieldScreenFree());
          case Routes.basicDataFree:
            return MaterialPageRoute(
                builder: (_) => const BasicDataScreenFree());
          case Routes.contactInfoFree:
            return MaterialPageRoute(
                builder: (_) => const ContactInfoScreenFree());
          case Routes.portfolio:
            return MaterialPageRoute(
                builder: (_) => const PortfolioScreen());
          case Routes.linkEntry:
            return MaterialPageRoute(
                builder: (_) => const LinkEntryScreen());
          case Routes.newProject:
            return MaterialPageRoute(
                builder: (_) => const NewProjectScreen());
          case Routes.resetPassword:
            return MaterialPageRoute(
                builder: (_) => const ResetPasswordScreen());
          case Routes.selectCategory:
            return MaterialPageRoute(
                builder: (_) => CategorySelectionScreen(categories: []));
          case Routes.selectSpecialization:
            return MaterialPageRoute(
                builder: (_) => SpecializationSelectionScreen(
                  items: [],
                  selected: null,
                ));
          case Routes.searchSkills:
            return MaterialPageRoute(
                builder: (_) => const SkillSearchScreen());
          case Routes.searchProject:
            return MaterialPageRoute(
                builder: (_) => const ProjectSearchScreen());
          case Routes.experience:
            return MaterialPageRoute(
                builder: (_) => const ExperienceScreen());
          case Routes.unloggedProjects:
            return MaterialPageRoute(
                builder: (_) => const UnloggedScreen());
          case Routes.favorites:
            return MaterialPageRoute(
                builder: (_) => const FavoritesScreen());
          case Routes.freelancerProfileScreen:
            return MaterialPageRoute(
                builder: (_) => const FreelancerProfileScreen());
          case Routes.projectDetail:
            return MaterialPageRoute(
                builder: (_) => const ProjectDetailScreen(project: {}));
          case Routes.projectDetailFree:
            final args = settings.arguments as Map<String, dynamic>;
            return MaterialPageRoute(
                builder: (_) =>
                    ProjectDetailScreenFree(projectFree: args));
          case Routes.filterProjects:
            return MaterialPageRoute(builder: (_) => const ProjectsScreen());
          case Routes.freelancerSearch:
            return MaterialPageRoute(
                builder: (_) => const FreelancerSearchScreen());

          default:
            return null;
        }
      },
    );
  }
}