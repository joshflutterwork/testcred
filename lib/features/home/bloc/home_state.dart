part of 'home_bloc.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

class HomeInitial extends HomeState {}

class PokemonLoaded extends HomeState {
  final PokemonModel? pokemonModel;
  PokemonLoaded({this.pokemonModel});

  @override
  List<Object> get props => [pokemonModel!];
}

class PokemonDetailLoaded extends HomeState {
  final PokemonDetail? pokemonDetail;
  PokemonDetailLoaded({this.pokemonDetail});

  @override
  List<Object> get props => [pokemonDetail!];
}
