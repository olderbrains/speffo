import 'package:flutter_bloc/flutter_bloc.dart';

part 'home_stay_event.dart';
part 'home_stay_states.dart';

class HomeStayBloc extends Bloc<HomeStayEvent, HomeStayStates> {
  HomeStayBloc() : super(HomeStayStateInitial()) {
    on<GetInitHomeStay>((event, emit) {});
  }
}
