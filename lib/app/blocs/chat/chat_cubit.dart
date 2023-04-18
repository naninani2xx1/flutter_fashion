import 'package:equatable/equatable.dart';
import 'package:flutter_fashion/app/models/chat/chat.dart';
import 'package:flutter_fashion/app/presentation/home/export.dart';
import 'package:flutter_fashion/app/repositories/user_repository.dart';
import 'package:flutter_fashion/core/status_cubit/status_cubit.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  final UserRepositoryImpl _userRepositoryImpl;
  ChatCubit({required UserRepositoryImpl userRepo})
      : _userRepositoryImpl = userRepo,
        super(const ChatState());

  void fetchChats() async {
    emit(state.copyWith(status: AppStatus.loading));

    final result = await _userRepositoryImpl.fetchChats();

    result.fold(
      (error) => emit(state.copyWith(status: AppStatus.error)),
      (listChat) {
        if (listChat.isEmpty) {
          emit(state.copyWith(chats: listChat, status: AppStatus.success));
        } else {
          emit(
            state.copyWith(
                roomChatId: listChat[0].room_chat_id,
                chats: listChat,
                status: AppStatus.success),
          );
        }
      },
    );
  }

  void addChat(ChatModel chat) {
    final state = this.state;
    final updateList = [...state.chats, chat];

    emit(state.copyWith(chats: updateList));
  }

  void createChat(String message) async {
    final state = this.state;

    emit(state.copyWith(submitStatus: SubmitChatStatus.sending));

    final result = await _userRepositoryImpl.createChat(message: message);

    result.fold(
      (error) {
        emit(state.copyWith(submitStatus: SubmitChatStatus.failure));
      },
      (chat) {},
    );
  }
}
