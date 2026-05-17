import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sun_gate_app/features/admin/domain/entities/admin_article_entity.dart';
import 'package:sun_gate_app/features/admin/presentation/controllers/admin_controller.dart';
import 'package:sun_gate_app/features/admin/presentation/widgets/admin_message_banner.dart';
import 'package:sun_gate_app/core/notifications/notification_bootstrap.dart';
import 'package:sun_gate_app/features/admin/presentation/widgets/admin_ui_kit.dart';

class AdminArticlesScreen extends ConsumerStatefulWidget {
  const AdminArticlesScreen({super.key});

  @override
  ConsumerState<AdminArticlesScreen> createState() =>
      _AdminArticlesScreenState();
}

class _AdminArticlesScreenState extends ConsumerState<AdminArticlesScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => ref.read(adminControllerProvider.notifier).loadArticles(),
    );
  }

  Future<void> _openEditor({AdminArticleEntity? article}) async {
    final result = await showModalBottomSheet<_ArticleEditorResult>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) => _ArticleEditorSheet(article: article),
    );

    if (result != null && mounted) {
      final saved = await ref.read(adminControllerProvider.notifier).saveArticle(
            articleId: article?.id,
            title: result.title,
            body: result.body,
          );
      if (saved && mounted) {
        refreshAppNotifications(ref);
      }
    }
  }

  Future<bool?> _confirmDelete(bool isArabic) {
    return showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Text(isArabic ? 'حذف المحتوى' : 'Delete content'),
        content: Text(
          isArabic
              ? 'هل تريد حذف هذا المحتوى نهائياً؟'
              : 'Do you want to delete this content permanently?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(isArabic ? 'إلغاء' : 'Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(isArabic ? 'حذف' : 'Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(adminControllerProvider);
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return Scaffold(
      appBar: AppBar(
        title: Text(isArabic ? 'إدارة المحتوى' : 'Content management'),
        actions: [
          IconButton(
            onPressed: () => _openEditor(),
            tooltip: isArabic ? 'إضافة محتوى' : 'Add content',
            icon: const Icon(Icons.add_circle_outline),
          ),
        ],
      ),
      body: AdminScreenContainer(
        child: RefreshIndicator(
          onRefresh: () =>
              ref.read(adminControllerProvider.notifier).loadArticles(),
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
            children: [
              AdminHeroBanner(
                eyebrow: isArabic ? 'المحتوى' : 'Content',
                title: isArabic ? 'المقالات والتعليمات' : 'Articles and guides',
                subtitle: isArabic
                    ? 'أنشئ المحتوى وحرره ليظهر للمستخدمين داخل التطبيق.'
                    : 'Create and update the content shown to users inside the app.',
                icon: Icons.article_outlined,
                footer: [
                  AdminHeroMetric(
                    label: isArabic ? 'عدد العناصر' : 'Items',
                    value: '${state.articles.length}',
                  ),
                ],
              ),
              const SizedBox(height: 16),
              AdminMessageBanner(
                errorMessage: state.errorMessage,
                successMessage: state.successMessage,
              ),
              if (state.isLoading)
                const SizedBox(
                  height: 280,
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (state.articles.isEmpty)
                AdminEmptyState(
                  icon: Icons.article_outlined,
                  title: isArabic ? 'لا يوجد محتوى بعد' : 'No content yet',
                  subtitle: isArabic
                      ? 'أضف أول مقال أو تعليمات لتظهر هنا.'
                      : 'Add your first article or guide and it will appear here.',
                )
              else
                ...state.articles.map((article) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: AdminPanel(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  article.title,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed: () => _openEditor(article: article),
                                icon: const Icon(Icons.edit_outlined),
                              ),
                              IconButton(
                                onPressed: state.isSaving
                                    ? null
                                    : () async {
                                        final confirmed =
                                            await _confirmDelete(isArabic);
                                        if (confirmed == true && mounted) {
                                          await ref
                                              .read(
                                                adminControllerProvider.notifier,
                                              )
                                              .deleteArticle(article.id);
                                        }
                                      },
                                icon: const Icon(
                                  Icons.delete_outline,
                                  color: Color(0xFFC62828),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            article.body,
                            maxLines: 4,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
            ],
          ),
        ),
      ),
    );
  }
}

class _ArticleEditorResult {
  final String title;
  final String body;

  const _ArticleEditorResult({required this.title, required this.body});
}

class _ArticleEditorSheet extends StatefulWidget {
  final AdminArticleEntity? article;

  const _ArticleEditorSheet({this.article});

  @override
  State<_ArticleEditorSheet> createState() => _ArticleEditorSheetState();
}

class _ArticleEditorSheetState extends State<_ArticleEditorSheet> {
  late final TextEditingController _titleController;
  late final TextEditingController _bodyController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.article?.title ?? '');
    _bodyController = TextEditingController(text: widget.article?.body ?? '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  void _submit() {
    final title = _titleController.text.trim();
    final body = _bodyController.text.trim();

    if (title.isEmpty || body.isEmpty) {
      final isArabic = Localizations.localeOf(context).languageCode == 'ar';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isArabic
                ? 'يرجى إدخال العنوان والتفاصيل'
                : 'Please enter both title and details',
          ),
        ),
      );
      return;
    }

    Navigator.pop(
      context,
      _ArticleEditorResult(title: title, body: body),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final isEditing = widget.article != null;

    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isEditing
                ? (isArabic ? 'تعديل المحتوى' : 'Edit content')
                : (isArabic ? 'إضافة محتوى' : 'Add content'),
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            isArabic
                ? 'أدخل عنوان المقال والنص الذي سيظهر للمستخدمين.'
                : 'Enter the article title and the body shown to users.',
          ),
          const SizedBox(height: 18),
          TextField(
            controller: _titleController,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              labelText: isArabic ? 'العنوان' : 'Title',
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _bodyController,
            maxLines: 6,
            decoration: InputDecoration(
              labelText: isArabic ? 'التفاصيل' : 'Details',
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: _submit,
              child: Text(isArabic ? 'حفظ' : 'Save'),
            ),
          ),
        ],
      ),
    );
  }
}
