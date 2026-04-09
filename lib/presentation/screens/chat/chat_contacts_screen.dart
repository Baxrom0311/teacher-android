import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:teacher_school_app/core/localization/l10n_extension.dart';
import '../../../core/network/api_error_handler.dart';
import '../../providers/chat_provider.dart';
import '../../widgets/app_feedback.dart';

class ChatContactsScreen extends ConsumerWidget {
  const ChatContactsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final contactsAsync = ref.watch(chatContactsProvider);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(l10n.messagesTitle),
        backgroundColor:
            theme.appBarTheme.backgroundColor ?? colorScheme.surface,
        foregroundColor:
            theme.appBarTheme.foregroundColor ?? colorScheme.onSurface,
        elevation: 0,
      ),
      body: contactsAsync.when(
        data: (contacts) {
          if (contacts.isEmpty) {
            return AppEmptyView(
              title: l10n.contactsEmptyTitle,
              message: l10n.contactsEmptyMessage,
            );
          }

          return ListView.separated(
            itemCount: contacts.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final contact = contacts[index];
              return ListTile(
                tileColor: theme.cardColor,
                leading: CircleAvatar(
                  backgroundColor: colorScheme.primary.withValues(alpha: 0.2),
                  backgroundImage: contact.profilePhotoUrl != null
                      ? NetworkImage(contact.profilePhotoUrl!)
                      : null,
                  child: contact.profilePhotoUrl == null
                      ? Text(
                          contact.name[0].toUpperCase(),
                          style: TextStyle(color: colorScheme.primary),
                        )
                      : null,
                ),
                title: Text(
                  contact.name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
                subtitle: Text(
                  contact.lastMessage ?? l10n.sendMessagePlaceholder,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: contact.unreadCount > 0
                        ? colorScheme.onSurface
                        : colorScheme.onSurfaceVariant,
                    fontWeight: contact.unreadCount > 0
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if (contact.lastMessageAt != null)
                      Text(
                        contact.lastMessageAt!.substring(
                          11,
                          16,
                        ), // Mock time formatting
                        style: TextStyle(
                          fontSize: 12,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    if (contact.unreadCount > 0) ...[
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: colorScheme.primary,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          '${contact.unreadCount}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                onTap: () {
                  context.push('/chat/${contact.id}', extra: contact.name);
                },
              );
            },
          );
        },
        loading: () => AppLoadingView(
          title: l10n.messagesLoadingTitle,
          subtitle: l10n.messagesLoadingSubtitle,
        ),
        error: (err, st) => AppErrorView(
          title: l10n.messagesLoadErrorTitle,
          message: ApiErrorHandler.readableMessage(err),
        ),
      ),
    );
  }
}
