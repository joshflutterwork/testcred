import 'package:dio/dio.dart';
import 'package:testcreditbook/core/network.dart';
import 'package:testcreditbook/features/detail/data/pokemon_detail_model.dart';
import 'package:testcreditbook/features/home/data/pokemon_model.dart';

class HomeRepository {
  Future<PokemonModel> getPokemonModel() async {
    Response resp = await NetworkApp.get(
        url: "https://pokeapi.co/api/v2/pokemon/?limit=100");

    return PokemonModel.fromJson(resp.data);
  }

  Future<PokemonDetail> getPokemonDetailModel(String url) async {
    Response resp = await NetworkApp.get(url: url);

    return PokemonDetail.fromJson(resp.data);
  }
}
