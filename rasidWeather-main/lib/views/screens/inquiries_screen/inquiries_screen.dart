import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:http/http.dart' as http;
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

import '../../../bloc/inquiries_cubit/inquiries_cubit.dart';
import '../../../data/model/inquirie_model.dart';
import '../../../data/model/message_model.dart';
import '../../../data/model/user_model.dart';
import '../../../utils/date_utils.dart';
import '../../../utils/ui_utils.dart';

class InquiriesScreen extends StatefulWidget {
  const InquiriesScreen({super.key, required this.user});
  final UserModel user;

  @override
  State<InquiriesScreen> createState() => _InquiriesScreenState();
}

class _InquiriesScreenState extends State<InquiriesScreen> {
  late List<types.Message> _messages = <types.Message>[];
  InquiryModel? inquiry;
  late types.User _user;
  int currentPage = 0;
  bool _isLastPage = false;

  @override
  void initState() {
    _user = types.User(id: widget.user.id ?? '');
    super.initState();
    _handleEndReached();
  }

  Future<void> _handleEndReached() async {
    if (!_isLastPage) {
      currentPage = currentPage + 1;
      await context.read<InquiriesBloc>().getInquiryChat(
        currentPage: currentPage,
      );
    }
  }

  void _addMessage(types.Message message) {
    setState(() => _messages.insert(0, message));
  }

  Future<void> _handleSendPressed({types.PartialText? message}) async {
    await context.read<InquiriesBloc>().sendMsgInquiry(
      id: inquiry?.id ?? '',
      message: message!.text,
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      centerTitle: true,
      title: const Text('inquiries.title').tr(),
    ),
    body: BlocConsumer<InquiriesBloc, InquiriesState>(
      listener: (BuildContext context, InquiriesState state) {
        if (state is InquiriesLoading) {}

        if (state is InquiriesChatSuccess) {
          inquiry = state.inquiry;
          final List<MessageModel> messages = state.messages;
          final List<types.TextMessage> typeMessages =
              messages
                  .map(
                    (MessageModel e) => types.TextMessage(
                      author: types.User(
                        id: e.user?.id ?? '',
                        firstName: e.user?.name ?? '',
                        imageUrl: e.user?.avatar?.tiny ?? '',
                      ),
                      id: e.id ?? '',
                      text: e.content ?? '',
                      createdAt: e.createdAt?.millisecondsSinceEpoch,
                    ),
                  )
                  .toList();
          setState(() {
            _messages = typeMessages;
            _isLastPage = state.isLastPage;
          });
        }

        if (state is InquiriesChatError) {
          showSnackBar(context, state.error);
        }

        if (state is InquirySendSuccess) {
          final types.TextMessage textMessage = types.TextMessage(
            author: _user,
            createdAt: state.message.createdAt?.millisecondsSinceEpoch,
            id: state.message.id ?? '',
            text: state.message.content ?? '',
          );
          _addMessage(textMessage);
        }
        if (state is InquirySendError) {
          showSnackBar(context, state.error);
        }
      },
      builder: (BuildContext context, InquiriesState state) {
        if (state is InquiriesChatLoading) {
          if (state.refresh) {
            return Container();
          }
        }
        if (state is InquiriesChatError) {
          return Center(child: Text(state.error));
        }
        return Chat(
          theme: DefaultChatTheme(
            messageMaxWidth: MediaQuery.sizeOf(context).width * 90,
            primaryColor: Theme.of(context).primaryColor,
            highlightMessageColor: Theme.of(context).primaryColor,
            systemMessageTheme: SystemMessageTheme(
              margin: EdgeInsets.zero,
              textStyle: Theme.of(context).textTheme.bodyMedium!,
            ),
            inputTextCursorColor: Colors.white,
            inputSurfaceTintColor: Colors.yellow,
            inputBackgroundColor: Colors.white,
            inputMargin: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 10,
            ),
            inputTextStyle: const TextStyle(color: Colors.black),
            inputBorderRadius: const BorderRadius.horizontal(
              left: Radius.circular(20),
              right: Radius.circular(20),
            ),
            inputTextDecoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
              hintText: 'inquiries.write_inquiry'.tr(),
              hintStyle: const TextStyle(color: Colors.black54),
            ),
            inputContainerDecoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          messages: _messages,
          onEndReached: _handleEndReached,
          // onAttachmentPressed: _handleImageSelection,
          onMessageTap: _handleMessageTap,
          onPreviewDataFetched: _handlePreviewDataFetched,
          onSendPressed:
              (types.PartialText t) => _handleSendPressed(message: t),
          showUserAvatars: true,
          showUserNames: true,
          disableImageGallery: false,
          user: _user,
          customDateHeaderText: (DateTime date) {
            return dateTimeToTimeAgo(date);
          },
        );
      },
    ),
  );

  void _handlePreviewDataFetched(
    types.TextMessage message,
    types.PreviewData previewData,
  ) {
    final int index = _messages.indexWhere(
      (types.Message element) => element.id == message.id,
    );
    final types.Message updatedMessage = (_messages[index] as types.TextMessage)
        .copyWith(previewData: previewData);

    setState(() => _messages[index] = updatedMessage);
  }

  Future<void> _handleMessageTap(BuildContext _, types.Message message) async {
    if (message is types.FileMessage) {
      String localPath = message.uri;

      if (message.uri.startsWith('http')) {
        try {
          final int index = _messages.indexWhere(
            (types.Message element) => element.id == message.id,
          );
          final types.Message updatedMessage =
              (_messages[index] as types.FileMessage).copyWith(isLoading: true);

          setState(() => _messages[index] = updatedMessage);

          final http.Client client = http.Client();
          final http.Response request = await client.get(
            Uri.parse(message.uri),
          );
          final Uint8List bytes = request.bodyBytes;
          final String documentsDir =
              (await getApplicationDocumentsDirectory()).path;
          localPath = '$documentsDir/${message.name}';

          if (!File(localPath).existsSync()) {
            final File file = File(localPath);
            await file.writeAsBytes(bytes);
          }
        } finally {
          final int index = _messages.indexWhere(
            (types.Message element) => element.id == message.id,
          );
          final types.Message updatedMessage =
              (_messages[index] as types.FileMessage).copyWith();

          setState(() => _messages[index] = updatedMessage);
        }
      }

      OpenFile.open(localPath);
      // await OpenFilex.open(localPath);
    }
  }
}
