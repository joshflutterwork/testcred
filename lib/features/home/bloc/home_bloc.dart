import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:testcreditbook/features/detail/data/pokemon_detail_model.dart';
import 'package:testcreditbook/features/home/data/pokemon_model.dart';
import 'package:testcreditbook/features/home/domain/home_repository.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeRepository homeRepository = HomeRepository();
  HomeBloc() : super(HomeInitial()) {
    on<GetPokemonList>(_getPokemon);
    on<GetPokemonDetail>(_getPokemonDetail);
  }

  _getPokemon(GetPokemonList event, Emitter<HomeState> emit) async {
    try {
      PokemonModel pokemonModel = await homeRepository.getPokemonModel();
      if (pokemonModel != null) {
        emit(PokemonLoaded(pokemonModel: pokemonModel));
      }
    } catch (e) {}
  }

  _getPokemonDetail(GetPokemonDetail event, Emitter<HomeState> emit) async {
    try {
      PokemonDetail pokemonDetail =
          await homeRepository.getPokemonDetailModel(event.urlDetail!);
      if (pokemonDetail != null) {
        emit(PokemonDetailLoaded(pokemonDetail: pokemonDetail));
      }
    } catch (e) {}
  }
}
