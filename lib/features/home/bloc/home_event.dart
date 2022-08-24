part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class GetPokemonList extends HomeEvent {
  GetPokemonList();

  @override
  List<Object> get props => [];
}

class GetPokemonDetail extends HomeEvent {
  String? urlDetail;
  GetPokemonDetail({this.urlDetail});

  @override
  List<Object> get props => [urlDetail!];
}
