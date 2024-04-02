import 'package:equatable/equatable.dart';

enum HomeStatus {
  loading,
  done;
}

class HomeState extends Equatable {
  final HomeStatus status;

  const HomeState({
    required this.status,
  });

  factory HomeState.ds() => const HomeState(status: HomeStatus.loading);

  HomeState copyWith({
    HomeStatus? status,
  }) {
    return HomeState(
      status: status ?? this.status,
    );
  }
  
  @override
  List<Object?> get props => [status];
}
