import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../data/model/base/api_response.dart';
import '../../data/model/inquirie_model.dart';
import '../../data/model/message_model.dart';
import '../../data/repository/inquiries_repo.dart';

part 'inquiries_state.dart';

class InquiriesBloc extends Cubit<InquiriesState> {
  InquiriesBloc(this.inquiriesRepo) : super(InquiriesInitial());
  final InquiriesRepo inquiriesRepo;

  late final FocusNode focusNode = FocusNode();
  late final ScrollController scrollController = ScrollController();
  late final TextEditingController textEditingController = TextEditingController();

  final List<MessageModel> _messages = <MessageModel>[];

  bool get isTextFieldEnable => textEditingController.text.isNotEmpty;

  Future<void> getInquiryChat({bool refresh = false, int currentPage = 1}) async {
    emit(InquiriesChatLoading(refresh: currentPage == 1, loading: currentPage > 1));
    final String params = '?page=$currentPage';

    if (currentPage == 1) {
      _messages.clear();
    }
    final ApiResponse apiResponse = await inquiriesRepo.getInquiryChat(params);
    if (apiResponse.response!.statusCode == 200) {
      final InquiryModel inquiry = InquiryModel.fromJson(apiResponse.response!.data['body']['contact'] as Map<String, dynamic>);
      final MessageBodyModel messages = MessageBodyModel.fromJson(apiResponse.response?.data['body']['messages'] as Map<String, dynamic>);
      _messages.addAll(messages.data!);
      emit(InquiriesChatSuccess(inquiry, _messages, isLastPage: messages.meta!.lastPage == messages.meta!.currentPage));
    } else {
      emit(InquiriesChatError(apiResponse.toString()));
    }
  }

  Future<void> sendMsgInquiry({String id = '', String? message, File? media}) async {
    final FormData formData = FormData();

    if (message != null) {
      formData.fields.add(MapEntry('message', message));
    }

    if (media != null) {
      formData.files.add(MapEntry(
        'media',
        await MultipartFile.fromFile(media.path, filename: media.path.split('/').last),
      ));
    }

    emit(InquirySendLoading());
    try {
      final ApiResponse apiResponse = await inquiriesRepo.sendMsgInquiry(id, formData);
      if (apiResponse.error != null) {
        emit(InquirySendError(apiResponse.error ?? ''));
      } else {
        final MessageModel message = MessageModel.fromJson(apiResponse.response!.data['body'] as Map<String, dynamic>);
        emit(InquirySendSuccess(message));
      }
    } catch (e) {
      emit(InquirySendError(e.toString()));
    }
  }
}
