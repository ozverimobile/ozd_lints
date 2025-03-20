import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

part 'block_check_is_closed_event.dart';
part 'block_check_is_closed_state.dart';

final class BlockCheckIsClosedBloc extends Bloc<BlockCheckIsClosedEvent, BlockCheckIsClosedState> {
  BlockCheckIsClosedBloc() : super(BlockCheckIsClosedInitial()) {
    on<BlockCheckIsClosedEvent>(_init);
    on<BlockCheckIsClosedSomeEvent>(_someMethod);
  }

  Future<void> _init(BlockCheckIsClosedEvent event, Emitter<BlockCheckIsClosedState> emit) async {
    emit(BlockCheckIsClosedInitial());
    await Future<void>.delayed(const Duration(seconds: 1));
    _test();
    // ignore: unused_local_variable
    var x = 5;
    x++; 
    // expect_lint: bloc_check_is_closed
    emit(BlockCheckIsClosedInitial());
     
    if (isClosed) {
      // expect_lint: bloc_check_is_closed
      emit(BlockCheckIsClosedInitial());
    }

    // expect_lint: bloc_check_is_closed
    if (isClosed) emit(BlockCheckIsClosedInitial());

    if (!isClosed) {
      emit(BlockCheckIsClosedInitial());
    }

    if (!isClosed) emit(BlockCheckIsClosedInitial());

    if (isClosed) return;

    emit(BlockCheckIsClosedInitial());
  }

  Future<void> _someMethod(BlockCheckIsClosedSomeEvent event, Emitter<BlockCheckIsClosedState> emit) async {
    emit(BlockCheckIsClosedInitial());
    await Future<void>.delayed(const Duration(seconds: 1));

    if (isClosed) return;

    if (isClosed) {
      return;
    }

    emit(BlockCheckIsClosedInitial());
  }

  // ignore: unused_element
  Future<void> _someMethod2(BlockCheckIsClosedSomeEvent event, Emitter<BlockCheckIsClosedState> emit) async {
    emit(BlockCheckIsClosedInitial());
    await Future<void>.delayed(const Duration(seconds: 1));

    if (isClosed) {
      return;
    }

    emit(BlockCheckIsClosedInitial());
  }

  // ignore: unused_element
  Future<void> _someMethod3(BlockCheckIsClosedSomeEvent event, Emitter<BlockCheckIsClosedState> emit) async {
    emit(BlockCheckIsClosedInitial());

    Future.delayed(Durations.medium1, () {
      emit(BlockCheckIsClosedInitial());
    });

    await Future<void>.delayed(const Duration(seconds: 1));

    if (isClosed) {
      return;
    }

    emit(BlockCheckIsClosedInitial());

    await Future.delayed(Durations.medium2);

    // expect_lint: bloc_check_is_closed
    emit(BlockCheckIsClosedInitial());

  }

  void _test() {}
}
