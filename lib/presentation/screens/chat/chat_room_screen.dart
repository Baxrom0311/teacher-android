import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';

import '../../../core/constants/app_colors.dart';
import 'package:teacher_school_app/core/localization/l10n_extension.dart';
import '../../../core/network/api_error_handler.dart';
import '../../providers/auth_provider.dart';
import '../../providers/chat_provider.dart';
import '../../widgets/app_feedback.dart';

class ChatRoomScreen extends ConsumerStatefulWidget {
  final int userId;
  final String userName;

  const ChatRoomScreen({
    super.key,
    required this.userId,
    required this.userName,
  });

  @override
  ConsumerState<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends ConsumerState<ChatRoomScreen> {
  final _messageController = TextEditingController();

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;
    ref
        .read(chatMessagesProvider(widget.userId).notifier)
        .sendMessage(_messageController.text.trim());
    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final messagesAsync = ref.watch(chatMessagesProvider(widget.userId));
    final myId = ref.watch(authControllerProvider).user?.id ?? 0;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(widget.userName),
        backgroundColor:
            theme.appBarTheme.backgroundColor ?? colorScheme.surface,
        foregroundColor:
            theme.appBarTheme.foregroundColor ?? colorScheme.onSurface,
        elevation: 1,
      ),
      body: Column(
        children: [
          Expanded(
            child: messagesAsync.when(
              data: (messages) {
                if (messages.isEmpty) {
                  return AppEmptyView(
                    message: l10n.chatRoomEmptyMessage,
                    icon: Icons.chat_bubble_outline,
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  reverse: false, // In a real app we'd reverse and sort
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final msg = messages[index];
                    final isMe = msg.senderId == myId;

                    return Align(
                      alignment: isMe
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(12),
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.75,
                        ),
                        decoration: BoxDecoration(
                          color: isMe ? colorScheme.primary : theme.cardColor,
                          borderRadius: BorderRadius.circular(16).copyWith(
                            bottomRight: isMe
                                ? const Radius.circular(0)
                                : const Radius.circular(16),
                            bottomLeft: !isMe
                                ? const Radius.circular(0)
                                : const Radius.circular(16),
                          ),
                          border: isMe
                              ? null
                              : Border.all(
                                  color: colorScheme.outline.withValues(
                                    alpha: 0.7,
                                  ),
                                ),
                        ),
                        child: Text(
                          msg.message,
                          style: TextStyle(
                            color: isMe ? Colors.white : colorScheme.onSurface,
                            fontSize: 16,
                          ),
                        ),
                      ),
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
                icon: Icons.chat_bubble_outline,
                onRetry: () =>
                    ref.invalidate(chatMessagesProvider(widget.userId)),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: theme.cardColor,
              boxShadow: [
                BoxShadow(
                  color: theme.shadowColor.withValues(alpha: 0.12),
                  blurRadius: 4,
                  offset: const Offset(0, -1),
                ),
              ],
            ),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.attach_file,
                    color: TeacherAppColors.textSecondary,
                  ),
                  onPressed: () async {
                    FilePickerResult? result = await FilePicker.platform
                        .pickFiles(
                          type: FileType.custom,
                          allowedExtensions: [
                            'jpg',
                            'jpeg',
                            'png',
                            'pdf',
                            'doc',
                            'docx',
                            'xls',
                            'xlsx',
                          ],
                        );

                    if (result != null && result.files.single.path != null) {
                      ref
                          .read(chatMessagesProvider(widget.userId).notifier)
                          .sendMessage(
                            _messageController.text.trim(),
                            attachmentPath: result.files.single.path,
                          );
                      _messageController.clear();
                    }
                  },
                ),
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: l10n.sendMessagePlaceholder,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: colorScheme.surface,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                    ),
                    textInputAction: TextInputAction.send,
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: colorScheme.primary,
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white, size: 20),
                    onPressed: _sendMessage,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
