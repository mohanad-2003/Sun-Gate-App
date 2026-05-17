import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sun_gate_app/features/admin/domain/entities/admin_article_entity.dart';
import 'package:sun_gate_app/features/admin/presentation/controllers/admin_controller.dart';
import 'package:sun_gate_app/features/admin/presentation/widgets/admin_message_banner.dart';

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
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final titleController = TextEditingController(text: article?.title ?? '');
    final bodyController = TextEditingController(text: article?.body ?? '');

    final saved = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                article == null
                    ? (isArabic ? 'إضافة محتوى' : 'Add content')
                    : (isArabic ? 'تعديل المحتوى' : 'Edit content'),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  labelText: isArabic ? 'العنوان' : 'Title',
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: bodyController,
                maxLines: 6,
                decoration: InputDecoration(
                  labelText: isArabic ? 'التفاصيل' : 'Details',
                ),
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text(isArabic ? 'حفظ' : 'Save'),
              ),
            ],
          ),
        );
      },
    );

    if (saved == true && mounted) {
      final title = titleController.text.trim();
      final body = bodyController.text.trim();
      titleController.dispose();
      bodyController.dispose();
      await ref.read(adminControllerProvider.notifier).saveArticle(
            articleId: article?.id,
            title: title,
            body: body,
          );
    } else {
      titleController.dispose();
      bodyController.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(adminControllerProvider);
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return Scaffold(
      appBar: AppBar(
        title: Text(isArabic ? 'تعديل المعلومات' : 'Edit Information'),
        actions: [
          IconButton(
            onPressed: () => _openEditor(),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () =>
            ref.read(adminControllerProvider.notifier).loadArticles(),
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          children: [
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
              SizedBox(
                height: 280,
                child: Center(
                  child: Text(
                    isArabic ? 'لا يوجد محتوى بعد' : 'No content yet',
                  ),
                ),
              )
            else
              ...state.articles.map((article) {
                return Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: ListTile(
                    title: Text(
                      article.title,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    subtitle: Text(
                      article.body,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () => _openEditor(article: article),
                          icon: const Icon(Icons.edit_outlined),
                        ),
                        IconButton(
                          onPressed: state.isSaving
                              ? null
                              : () => ref
                                    .read(adminControllerProvider.notifier)
                                    .deleteArticle(article.id),
                          icon: const Icon(
                            Icons.delete_outline,
                            color: Colors.red,
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
    );
  }
}
