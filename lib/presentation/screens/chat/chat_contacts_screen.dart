import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:teacher_school_app/core/localization/l10n_extension.dart';

import '../../../core/network/api_error_handler.dart';
import '../../providers/chat_provider.dart';
import '../../widgets/app_feedback.dart';
import '../../widgets/common/page_background.dart';
import '../../widgets/common/premium_card.dart';

class ChatContactsScreen extends ConsumerWidget {
  const ChatContactsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final contactsAsync = ref.watch(chatContactsProvider);

    return PageBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: contactsAsync.when(
          data: (contacts) {
            return CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverAppBar(
                  floating: true,
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  centerTitle: true,
                  title: Text(
                    l10n.messagesTitle,
                    style: const TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 24,
                    ),
                  ),
                ),
                if (contacts.isEmpty)
                  SliverFillRemaining(
                    child: AppEmptyView(
                      title: l10n.contactsEmptyTitle,
                      message: l10n.contactsEmptyMessage,
                      icon: Icons.chat_bubble_outline_rounded,
                    ),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _ContactItem(contact: contacts[index]),
                        );
                      }, childCount: contacts.length),
                    ),
                  ),
              ],
            );
          },
          loading: () => const Center(child: AppLoadingView()),
          error: (err, st) => Center(
            child: AppErrorView(message: ApiErrorHandler.readableMessage(err)),
          ),
        ),
      ),
    );
  }
}

class _ContactItem extends StatelessWidget {
  final dynamic contact;

  const _ContactItem({required this.contact});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colorScheme = Theme.of(context).colorScheme;
    final hasUnread = (contact.unreadCount as int? ?? 0) > 0;

    return InkWell(
      onTap: () => context.push('/chat/${contact.id}', extra: contact.name),
      borderRadius: BorderRadius.circular(32),
      child: PremiumCard(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: hasUnread
                      ? colorScheme.primary
                      : colorScheme.onSurface.withValues(alpha: 0.1),
                  width: 2,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(28),
                child: contact.profilePhotoUrl != null
                    ? Image.network(contact.profilePhotoUrl!, fit: BoxFit.cover)
                    : Container(
                        color: colorScheme.primary.withValues(alpha: 0.12),
                        child: Center(
                          child: Text(
                            contact.name.toString().isNotEmpty
                                ? contact.name.toString()[0].toUpperCase()
                                : '?',
                            style: TextStyle(
                              color: colorScheme.primary,
                              fontWeight: FontWeight.w900,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          contact.name?.toString() ?? l10n.chat,
                          style: const TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      if (contact.lastMessageAt != null)
                        Text(
                          _formatTime(contact.lastMessageAt.toString()),
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: colorScheme.onSurface.withValues(alpha: 0.4),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          contact.lastMessage?.toString() ??
                              l10n.sendMessagePlaceholder,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: hasUnread
                                ? colorScheme.onSurface
                                : colorScheme.onSurface.withValues(alpha: 0.55),
                            fontWeight: hasUnread
                                ? FontWeight.w800
                                : FontWeight.w500,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      if (hasUnread) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: colorScheme.primary,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '${contact.unreadCount}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(String rawAt) {
    if (rawAt.length >= 16) return rawAt.substring(11, 16);
    return rawAt;
  }
}
