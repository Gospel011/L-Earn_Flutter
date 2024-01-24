import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'timer_state.dart';

class TimerCubit extends Cubit<TimerState> {
  TimerCubit() : super(TimerInitial());

  void setTimer({required Duration duration}) {
    emit(TimerInitial());

    Future.delayed(duration, () {
      emit(TimerEnded());
    });
  }
}
