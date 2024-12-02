part of 'home_cubit.dart';

@immutable
sealed class HomeState {}

final class HomeInitial extends HomeState {}


final class ChangeSwitcher extends HomeState {}
final class PickTimeState extends HomeState {}


final class RequestPermissionState extends HomeState {}
final class ShowNotificationState extends HomeState {}
final class FetchPendingNotificationsState extends HomeState {}
