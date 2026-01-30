import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/selected_topic_provider.dart';
import '../providers/discourse_providers.dart';
import '../utils/responsive.dart';
import '../widgets/layout/master_detail_layout.dart';
import 'topics_page.dart';
import 'topic_detail_page/topic_detail_page.dart';
import 'create_topic_page.dart';

/// 话题屏幕
/// 在手机上显示单栏列表，平板上显示 Master-Detail 双栏
class TopicsScreen extends ConsumerWidget {
  const TopicsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedTopic = ref.watch(selectedTopicProvider);
    final isMobile = Responsive.isMobile(context);
    final user = ref.watch(currentUserProvider).value;

    // 统一使用 MasterDetailLayout 处理所有情况
    // 手机/平板单栏：只显示 master
    // 平板双栏：显示 master + detail
    return MasterDetailLayout(
      master: const TopicsPage(),
      detail: selectedTopic.hasSelection && !isMobile
          ? TopicDetailPane(
              key: ValueKey(selectedTopic.topicId),
              topicId: selectedTopic.topicId!,
              initialTitle: selectedTopic.initialTitle,
              scrollToPostNumber: selectedTopic.scrollToPostNumber,
            )
          : null,
      masterFloatingActionButton: user != null
          ? FloatingActionButton(
              onPressed: () => _createTopic(context, ref),
              child: const Icon(Icons.add),
            )
          : null,
    );
  }

  Future<void> _createTopic(BuildContext context, WidgetRef ref) async {
    final topicId = await Navigator.push<int>(
      context,
      MaterialPageRoute(builder: (_) => const CreateTopicPage()),
    );
    if (topicId != null && context.mounted) {
      // 刷新列表
      for (final filter in TopicListFilter.values) {
        ref.invalidate(topicListProvider(filter));
      }
      // 在 Master-Detail 模式下，选中新话题
      ref.read(selectedTopicProvider.notifier).select(topicId: topicId);
    }
  }
}

/// 话题详情面板（用于双栏模式，不包含返回按钮）
class TopicDetailPane extends ConsumerWidget {
  const TopicDetailPane({
    super.key,
    required this.topicId,
    this.initialTitle,
    this.scrollToPostNumber,
  });

  final int topicId;
  final String? initialTitle;
  final int? scrollToPostNumber;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TopicDetailPage(
      topicId: topicId,
      initialTitle: initialTitle,
      scrollToPostNumber: scrollToPostNumber,
      embeddedMode: true, // 嵌入模式，不显示返回按钮
    );
  }
}
