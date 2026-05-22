import 'dart:async';

import '../models/user.dart';
import '../utils/app_logger.dart';
import '../utils/seed_data.dart';

abstract class AuthService {
  Stream<User?> get userStream;
  User? get currentUser;
  Future<User?> loadPersistedUser();
  Future<User> loginMember({required String name, required String trainerId});
  Future<User> loginTrainer();
  Future<void> logout();
  Future<bool> isOnboardingComplete();
  Future<void> setOnboardingComplete();
}

class MockAuthService implements AuthService {
  MockAuthService(this._persist);

  final AuthPersistence _persist;
  User? _user;

  @override
  User? get currentUser => _user;

  final _userController = StreamController<User?>.broadcast();

  @override
  Stream<User?> get userStream => _userController.stream;

  void _emit() => _userController.add(_user);

  @override
  Future<User?> loadPersistedUser() async {
    _user = await _persist.getUser();
    AppLogger.instance.log(LogCategory.auth, 'Loaded user: ${_user?.id}');
    _emit();
    return _user;
  }

  @override
  Future<User> loginMember({
    required String name,
    required String trainerId,
  }) async {
    _user = User(
      id: SeedData.memberId,
      name: name,
      role: UserRole.member,
      trainerId: trainerId,
    );
    await _persist.saveUser(_user!);
    AppLogger.instance.log(LogCategory.auth, 'Member login: $name');
    _emit();
    return _user!;
  }

  @override
  Future<User> loginTrainer() async {
    _user = SeedData.trainer;
    await _persist.saveUser(_user!);
    AppLogger.instance.log(LogCategory.auth, 'Trainer login');
    _emit();
    return _user!;
  }

  @override
  Future<void> logout() async {
    _user = null;
    await _persist.clearUser();
    AppLogger.instance.log(LogCategory.auth, 'Logout');
    _emit();
  }

  @override
  Future<bool> isOnboardingComplete() => _persist.isOnboardingComplete();

  @override
  Future<void> setOnboardingComplete() => _persist.setOnboardingComplete(true);
}

abstract class AuthPersistence {
  Future<User?> getUser();
  Future<void> saveUser(User user);
  Future<void> clearUser();
  Future<bool> isOnboardingComplete();
  Future<void> setOnboardingComplete(bool value);
}
