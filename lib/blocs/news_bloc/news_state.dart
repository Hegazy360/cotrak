import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class NewsState extends Equatable {
  NewsState([List props = const []]) : super(props);
}

class NewsUninitialized extends NewsState {
  @override
  String toString() => 'NewsUninitialized';
}

class NewsError extends NewsState {
  @override
  String toString() => 'NewsError';
}

class NewsLoaded extends NewsState {
  final List climateNewsList;

  NewsLoaded(this.climateNewsList)
      : super([climateNewsList]);

  @override
  String toString() {
    return 'NewsLoaded { News: $climateNewsList }';
  }
}

class InitialNewstate extends NewsState {}
