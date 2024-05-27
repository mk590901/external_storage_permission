import 'package:flutter_bloc/flutter_bloc.dart';
import 'banner_events.dart';
import 'banner_states.dart';

class BannerBloc extends Bloc<BannerEvent, BannerState> {
  BannerBloc() : super(BannerHidden()) {
    on<ShowBanner>((event, emit) {
      emit(BannerVisible());
    });
    on<HideBanner>((event, emit) {
      emit(BannerHidden());
    });
  }
}


