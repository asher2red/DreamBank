import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/local_day.dart';
import '../../../data/storage_providers.dart';
import '../domain/mood_type.dart';
import '../domain/messages.dart';

class MoodSession {
  const MoodSession({
    required this.day,
    required this.mood,
    required this.index,
    this.saving = false,
    this.failedMood,
  });
  final DateTime day;
  final MoodType? mood;
  final int index;
  final bool saving;
  final MoodType? failedMood;
  String get message => Messages.pool(mood)[index];
}

final moodControllerProvider =
    AsyncNotifierProvider<MoodController, MoodSession>(
      MoodController.new,
      retry: (_, _) => null,
    );

class MoodController extends AsyncNotifier<MoodSession> {
  int _generation = 0;
  @override
  Future<MoodSession> build() async {
    _generation++;
    final day = ref.watch(localDayProvider);
    final repository = ref.watch(moodRepositoryProvider);
    final entry = await repository.latest();
    MoodType? mood;
    if (entry != null) {
      final date = DateTime.fromMillisecondsSinceEpoch(entry.createdAt)
          .toLocal();
      if (date.year == day.year &&
          date.month == day.month &&
          date.day == day.day) {
        mood = MoodType.values.byName(entry.moodType);
      }
    }
    return MoodSession(
      day: day,
      mood: mood,
      index: Messages.initialIndex(day, mood),
    );
  }

  void nextMessage() {
    final old = state.asData?.value;
    if (old == null || old.saving) return;
    state = AsyncData(
      MoodSession(
        day: old.day,
        mood: old.mood,
        index: (old.index + 1) % Messages.pool(old.mood).length,
        failedMood: old.failedMood,
      ),
    );
  }

  Future<void> select(MoodType mood) async {
    final old = state.asData?.value;
    if (old == null || old.saving || old.mood == mood) return;
    final generation = _generation;
    state = AsyncData(
      MoodSession(day: old.day, mood: old.mood, index: old.index, saving: true),
    );
    try {
      await ref.read(moodRepositoryProvider).add(mood);
      if (!ref.mounted) return;
      if (generation != _generation) {
        ref.invalidateSelf();
        return;
      }
      state = AsyncData(
        MoodSession(
          day: old.day,
          mood: mood,
          index: Messages.initialIndex(old.day, mood),
        ),
      );
    } catch (_) {
      if (!ref.mounted || generation != _generation) return;
      state = AsyncData(
        MoodSession(
          day: old.day,
          mood: old.mood,
          index: old.index,
          failedMood: mood,
        ),
      );
    }
  }
}
