// ignore: depend_on_referenced_packages
import 'package:flutter_riverpod/legacy.dart';

/// 当前选中的话题（用于 Master-Detail 模式）
class SelectedTopicState {
  const SelectedTopicState({
    this.topicId,
    this.initialTitle,
    this.scrollToPostNumber,
  });

  final int? topicId;
  final String? initialTitle;
  final int? scrollToPostNumber;

  bool get hasSelection => topicId != null;

  SelectedTopicState copyWith({
    int? topicId,
    String? initialTitle,
    int? scrollToPostNumber,
    bool clearSelection = false,
  }) {
    if (clearSelection) {
      return const SelectedTopicState();
    }
    return SelectedTopicState(
      topicId: topicId ?? this.topicId,
      initialTitle: initialTitle ?? this.initialTitle,
      scrollToPostNumber: scrollToPostNumber ?? this.scrollToPostNumber,
    );
  }
}

class SelectedTopicNotifier extends StateNotifier<SelectedTopicState> {
  SelectedTopicNotifier() : super(const SelectedTopicState());

  void select({
    required int topicId,
    String? initialTitle,
    int? scrollToPostNumber,
  }) {
    state = SelectedTopicState(
      topicId: topicId,
      initialTitle: initialTitle,
      scrollToPostNumber: scrollToPostNumber,
    );
  }

  void clear() {
    state = const SelectedTopicState();
  }
}

final selectedTopicProvider =
    StateNotifierProvider<SelectedTopicNotifier, SelectedTopicState>((ref) {
  return SelectedTopicNotifier();
});
