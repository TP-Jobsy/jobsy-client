import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:jobsy/pages/project/favorites-freelancer/favorites_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'pages/auth/auth.dart';
import 'pages/auth/password_recovery/password_recovery_screen.dart';
import 'pages/auth/reset_password/reset_password_screen.dart';
import 'pages/auth/verification/verification_code_screen.dart';
import 'pages/onboarding/onboarding.dart';
import 'pages/profile-client/activity_field_screen.dart';
import 'pages/profile-client/basic_data_screen.dart';
import 'pages/profile-client/company_info_screen.dart';
import 'pages/profile-client/contact_details_screen.dart';
import 'pages/profile-client/contact_info_screen.dart';
import 'pages/profile-client/profile_screen.dart';
import 'pages/profile-freelancer/activity_field_screen_free.dart';
import 'pages/profile-freelancer/basic_data_screen_free.dart';
import 'pages/profile-freelancer/contact_details_screen_free.dart';
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

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('ru', null);
  final prefs = await SharedPreferences.getInstance();
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
      routes: {
        Routes.onboarding1: (_) => const OnboardingScreen(),
        Routes.auth: (_) => const AuthScreen(),
        Routes.passwordRecovery: (_) => const PasswordRecoveryScreen(),
        Routes.verify: (_) => const VerificationCodeScreen(),
        Routes.role: (_) => const RoleSelectionScreen(),
        Routes.projects: (_) => const ProjectsScreen(),
        Routes.projectsFree: (_) => const ProjectsScreenFree(),
        Routes.createProjectStep1: (_) => const NewProjectStep1Screen(),
        Routes.createProjectStep2: (_) => NewProjectStep2Screen(previousData: {}),
        Routes.createProjectStep3: (_) => NewProjectStep3Screen(previousData: {}),
        Routes.createProjectStep4: (_) => NewProjectStep4Screen(previousData: {}),
        Routes.createProjectStep5: (_) => NewProjectStep5Screen(previousData: {}),
        Routes.createProjectStep6: (_) => NewProjectStep6Screen(previousData: {}),
        Routes.profile: (_) => const ProfileScreen(),
        Routes.basicData: (_) => const BasicDataScreen(),
        Routes.activityField: (_) => const ActivityFieldScreen(),
        Routes.contactInfo: (_) => const ContactInfoScreen(),
        Routes.contactDetails: (_) => const ContactDetailsScreen(),
        Routes.companyInfo: (_) => const CompanyInfoScreen(),
        Routes.profileFree: (_) => const ProfileScreenFree(),
        Routes.activityFieldFree: (_) => const ActivityFieldScreenFree(),
        Routes.basicDataFree: (_) => const BasicDataScreenFree(),
        Routes.contactInfoFree: (_) => const ContactInfoScreenFree(),
        Routes.contactDetailsFree: (_) => const ContactDetailsScreenFree(),
        Routes.portfolio: (_) => const PortfolioScreen(),
        Routes.linkEntry: (_) => const LinkEntryScreen(),
        Routes.newProject: (_) => const NewProjectScreen(),
        Routes.resetPassword: (_) => const ResetPasswordScreen(),
        Routes.selectCategory: (_) => CategorySelectionScreen(categories: []),
        Routes.selectSpecialization: (_) => SpecializationSelectionScreen(items: [], selected: null),
        Routes.searchSkills: (_) => SkillSearchScreen(),
        Routes.experience: (_) => ExperienceScreen(),
        Routes.unloggedProjects: (_) => const UnloggedScreen(),
        Routes.favorites: (_) => const FavoritesScreen(),
        Routes.projectDetail: (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
          return ProjectDetailScreen(project: args);
        },
      },
    );
  }
}
