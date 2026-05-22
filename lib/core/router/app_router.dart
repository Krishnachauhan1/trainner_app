import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:trainner_app/app_shared.dart';

import '../../features/auth/presentation/login_screen.dart';
import '../../features/call/presentation/call_preview_screen.dart';
import '../../features/call/presentation/call_room_screen.dart';
import '../../features/chat/presentation/chat_list_screen.dart';
import '../../features/chat/presentation/chat_thread_screen.dart';
import '../../features/home/presentation/home_screen.dart';
import '../../features/members/presentation/members_screen.dart';
import '../../features/requests/presentation/requests_screen.dart';
import '../../features/sessions/presentation/sessions_screen.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final auth = ref.watch(authServiceProvider);

  return GoRouter(
    initialLocation: '/',
    redirect: (context, state) async {
      final user = auth.currentUser ?? await auth.loadPersistedUser();
      final loc = state.matchedLocation;
      if (user == null && loc != '/login') return '/login';
      if (user != null && (loc == '/' || loc == '/login')) return '/home';
      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/members',
        builder: (context, state) => const MembersScreen(),
      ),
      GoRoute(
        path: '/chats',
        builder: (context, state) => const ChatListScreen(),
      ),
      GoRoute(
        path: '/chat/:id',
        builder: (context, state) => ChatThreadScreen(
          conversationId: state.pathParameters['id']!,
        ),
      ),
      GoRoute(
        path: '/requests',
        builder: (context, state) => const RequestsScreen(),
      ),
      GoRoute(
        path: '/sessions',
        builder: (context, state) => const SessionsScreen(),
      ),
      GoRoute(
        path: '/call/preview',
        builder: (context, state) => const CallPreviewScreen(),
      ),
      GoRoute(
        path: '/call/live',
        builder: (context, state) => const CallRoomScreen(),
      ),
    ],
  );
});
