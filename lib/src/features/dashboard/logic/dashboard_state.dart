import 'package:equatable/equatable.dart';

enum DashboardStatus {
  loading,
  done;
}

class DashboardState extends Equatable {
  final DashboardStatus status;

  const DashboardState({
    required this.status,
  });

  factory DashboardState.ds() => const DashboardState(status: DashboardStatus.loading);

  DashboardState copyWith({
    DashboardStatus? status,
  }) {
    return DashboardState(
      status: status ?? this.status,
    );
  }
  
  @override
  List<Object?> get props => [status];
}
