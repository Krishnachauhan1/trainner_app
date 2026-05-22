import '../models/user.dart';

class SeedData {
  static const memberId = 'member_dk';
  static const memberName = 'DK';
  static const trainerId = 'trainer_aarav';
  static const trainerName = 'Aarav (Lead Trainer)';
  /// Legacy default conversation (Aarav).
  static const conversationId = 'conv_dk_aarav';

  static String conversationIdFor(String trainerId) =>
      'conv_${memberId}_$trainerId';

  static User trainerById(String id) => trainers.firstWhere(
        (t) => t.id == id,
        orElse: () => trainer,
      );

  static final trainers = [
    const User(
      id: trainerId,
      name: trainerName,
      role: UserRole.trainer,
    ),
    const User(
      id: 'trainer_maya',
      name: 'Maya (Strength)',
      role: UserRole.trainer,
    ),
    const User(
      id: 'trainer_raj',
      name: 'Raj (Mobility)',
      role: UserRole.trainer,
    ),
  ];

  static User member(String trainerId) => User(
        id: memberId,
        name: memberName,
        role: UserRole.member,
        trainerId: trainerId,
      );

  static const trainer = User(
    id: trainerId,
    name: trainerName,
    role: UserRole.trainer,
  );
}
