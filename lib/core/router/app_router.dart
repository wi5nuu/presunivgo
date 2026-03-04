import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:presunivgo/features/auth/presentation/screens/splash_screen.dart';
import 'package:presunivgo/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:presunivgo/features/auth/presentation/screens/login_screen.dart';
import 'package:presunivgo/features/auth/presentation/screens/register_screen.dart';
import 'package:presunivgo/features/auth/presentation/screens/email_verify_screen.dart';
import 'package:presunivgo/features/home/presentation/screens/home_screen.dart';
import 'package:presunivgo/features/profile/presentation/screens/profile_screen.dart';
import 'package:presunivgo/features/jobs/presentation/screens/jobs_screen.dart';
import 'package:presunivgo/features/jobs/presentation/screens/job_detail_screen.dart';
import 'package:presunivgo/shared/screens/main_screen.dart';
import 'package:presunivgo/features/chat/presentation/screens/chat_list_screen.dart';
import 'package:presunivgo/features/chat/presentation/screens/chat_detail_screen.dart';
import 'package:presunivgo/features/alumni/presentation/screens/alumni_directory_screen.dart';
import 'package:presunivgo/features/alumni/presentation/screens/network_screen.dart';
import 'package:presunivgo/features/clubs/presentation/screens/club_list_screen.dart';
import 'package:presunivgo/features/clubs/presentation/screens/club_detail_screen.dart';
import 'package:presunivgo/features/ai_assistant/presentation/screens/mentor_bot_screen.dart';
import 'package:presunivgo/features/search/presentation/screens/search_screen.dart';
import 'package:presunivgo/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:presunivgo/features/ai_assistant/presentation/screens/ai_cv_review_screen.dart';
import 'package:presunivgo/features/ai_assistant/presentation/screens/ai_cover_letter_screen.dart';
import 'package:presunivgo/features/ai_assistant/presentation/screens/ai_career_roadmap_screen.dart';
import 'package:presunivgo/features/auth/presentation/screens/admin_dashboard_screen.dart';

part 'app_router.g.dart';

@riverpod
GoRouter appRouter(AppRouterRef ref) {
  return GoRouter(
    initialLocation: '/splash',
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/verify-email',
        builder: (context, state) => const EmailVerifyScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) => MainScreen(child: child),
        routes: [
          GoRoute(
            path: '/home',
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            path: '/jobs',
            builder: (context, state) => const JobMarketplaceScreen(),
          ),
          GoRoute(
            path: '/clubs',
            builder: (context, state) => const ClubListScreen(),
          ),
          GoRoute(
            path: '/chat',
            builder: (context, state) => const ChatListScreen(),
          ),
          GoRoute(
            path: '/profile',
            builder: (context, state) => const ProfileScreen(),
          ),
          GoRoute(
            path: '/network',
            builder: (context, state) => const NetworkScreen(),
          ),
          GoRoute(
            path: '/alumni',
            builder: (context, state) => const AlumniDirectoryScreen(),
          ),
          GoRoute(
            path: '/search',
            builder: (context, state) => const SearchScreen(),
          ),
          GoRoute(
            path: '/dashboard',
            builder: (context, state) => const DashboardScreen(),
          ),
          GoRoute(
            path: '/ai-cv-review',
            builder: (context, state) => const AICVReviewScreen(),
          ),
          GoRoute(
            path: '/ai-cover-letter',
            builder: (context, state) => const AICoverLetterScreen(),
          ),
          GoRoute(
            path: '/ai-career-roadmap',
            builder: (context, state) => const AICareerRoadmapScreen(),
          ),
        ],
      ),
      GoRoute(
        path: '/chat/:chatId',
        builder: (context, state) =>
            ChatDetailScreen(chatId: state.pathParameters['chatId']!),
      ),
      GoRoute(
        path: '/clubs/:clubId',
        builder: (context, state) =>
            ClubDetailScreen(clubId: state.pathParameters['clubId']!),
      ),
      GoRoute(
        path: '/jobs/:jobId',
        builder: (context, state) {
          // We pass the job via 'extra' from job_card
          final job = state.extra as dynamic;
          if (job == null) return const JobMarketplaceScreen();
          return JobDetailScreen(job: job);
        },
      ),
      GoRoute(
        path: '/mentor-bot',
        builder: (context, state) => const MentorBotScreen(),
      ),
      GoRoute(
        path: '/admin',
        builder: (context, state) => const AdminDashboardScreen(),
      ),
    ],
  );
}
