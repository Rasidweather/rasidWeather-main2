part of 'inquiries_cubit.dart';

abstract class InquiriesState extends Equatable {
  const InquiriesState();
}

class InquiriesInitial extends InquiriesState {
  @override
  List<Object> get props => <Object>[];
}

class InquiriesLoading extends InquiriesState {

  const InquiriesLoading({required this.refresh, required this.loading});
  final bool refresh;
  final bool loading;

  @override
  List<Object> get props => <Object>[refresh, loading];
}

class InquiriesSuccess extends InquiriesState {

  const InquiriesSuccess(this.inquiries, {required this.isLastPage});
  final List<InquiryModel> inquiries;
  final bool isLastPage;

  @override
  List<Object> get props => <Object>[
        inquiries,
        isLastPage,
      ];
}

class InquiriesError extends InquiriesState {

  const InquiriesError(this.error);
  final String error;

  @override
  List<Object> get props => <Object>[error];
}

class InquiriesChatLoading extends InquiriesState {

  const InquiriesChatLoading({required this.refresh, required this.loading});
  final bool refresh;
  final bool loading;

  @override
  List<Object> get props => <Object>[refresh, loading];
}

class InquiriesChatSuccess extends InquiriesState {

  const InquiriesChatSuccess(this.inquiry, this.messages, {required this.isLastPage});
  final InquiryModel inquiry;
  final List<MessageModel> messages;
  final bool isLastPage;

  @override
  List<Object> get props => <Object>[
        inquiry,
        messages,
        isLastPage,
      ];
}

class InquiriesChatError extends InquiriesState {

  const InquiriesChatError(this.error);
  final String error;

  @override
  List<Object> get props => <Object>[error];
}

class InquirySendLoading extends InquiriesState {
  @override
  List<Object> get props => <Object>[];
}

class InquirySendSuccess extends InquiriesState {

  const InquirySendSuccess(this.message);
  final MessageModel message;

  @override
  List<Object> get props => <Object>[message];
}

class InquirySendError extends InquiriesState {

  const InquirySendError(this.error);
  final String error;

  @override
  List<Object> get props => <Object>[error];
}
