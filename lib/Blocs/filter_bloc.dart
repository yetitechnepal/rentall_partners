import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FilterBloc {
  String searchKey = "";
  int orderTypeId = 0;
  DateTime startDate = DateTime.now().subtract(const Duration(days: 30)),
      endDate = DateTime.now();
  reset() {
    searchKey = "";
    orderTypeId = 0;
  }
}

class FliterBlocCubit extends Cubit<FilterBloc> {
  FliterBlocCubit() : super(FilterBloc());
  setDateRange(DateTimeRange range) {
    FilterBloc newState = FilterBloc();
    newState.searchKey = state.searchKey;
    newState.orderTypeId = state.orderTypeId;
    newState.startDate = range.start;
    newState.endDate = range.end;
    emit(newState);
  }

  setOrderTypeId(int id) {
    FilterBloc newState = FilterBloc();
    newState.searchKey = state.searchKey;
    newState.orderTypeId = id;
    newState.startDate = state.startDate;
    newState.endDate = state.endDate;
    emit(newState);
  }

  setSearch(String key) {
    FilterBloc newState = FilterBloc();
    newState.searchKey = key;
    newState.orderTypeId = state.orderTypeId;
    newState.startDate = state.startDate;
    newState.endDate = state.endDate;
    emit(newState);
  }

  reset() {
    FilterBloc newState = FilterBloc();
    newState.searchKey = "";
    newState.orderTypeId = 0;
    newState.startDate = state.startDate;
    newState.endDate = state.endDate;
    emit(newState);
  }
}
