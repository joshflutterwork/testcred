import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:testcreditbook/features/home/bloc/home_bloc.dart';

class DetailScreen extends StatefulWidget {
  String? url;
  DetailScreen({Key? key, this.url}) : super(key: key);

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  HomeBloc homeBloc = HomeBloc();
  ScreenshotController _screenshotController = ScreenshotController();
  Uint8List? _imageResultScreenshot;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    homeBloc.add(GetPokemonDetail(urlDetail: widget.url));
  }

  shareProfile() async {
    await _screenshotController.capture(pixelRatio: 1.0).then((screenshot) {
      setState(() {
        _imageResultScreenshot = screenshot;
      });
    });
    final globalKey = GlobalKey();
    showDialog(
        context: context,
        useSafeArea: true,
        builder: (_) => Dialog(
                child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                height: MediaQuery.of(context).size.height / 4,
                child: ListView(
                  children: [
                    Image.memory(_imageResultScreenshot!),
                    SizedBox(
                      height: 8,
                    ),
                    InkWell(
                      onTap: () async {
                        final root = await getApplicationDocumentsDirectory();

                        final file = await File(root.path + 'fileName.png')
                          ..writeAsBytesSync(_imageResultScreenshot!);

                        // Navigator.of(context).pop();
                        print("object");

                        await Share.shareFiles([file.path]);
                      },
                      child: Container(
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            width: 1,
                            color: Colors.teal,
                          ),
                          borderRadius: BorderRadius.all(
                            Radius.circular(100.0),
                          ),
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                              color: Colors.grey[300]!,
                              blurRadius: 5.0,
                              offset: Offset(0.0, 2.0),
                            ),
                          ],
                        ),
                        child: Text(
                          'Share',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )));
  }

  Widget button(BuildContext context, {String? text, Function()? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 50,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            gradient:
                LinearGradient(colors: const [Colors.teal, Colors.tealAccent]),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 2,
                offset: Offset(0, 1), // changes position of shadow
              ),
            ]),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.share,
              color: Colors.white,
            ),
            Text(
              text!,
              textAlign: TextAlign.center,
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.teal[100],
        title: Text("Pokemon Detail"),
      ),
      body: BlocConsumer<HomeBloc, HomeState>(
        bloc: homeBloc,
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          if (state is PokemonDetailLoaded)
            return Column(
              children: [
                Container(
                    padding: EdgeInsets.all(16),
                    child: button(context, onTap: () {
                      shareProfile();
                    }, text: "Share")),
                Screenshot(
                  controller: _screenshotController,
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                    elevation: 2,
                    color: Colors.teal[50],
                    child: Container(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Image.network(
                              state.pokemonDetail!.sprites!.frontDefault!),
                          Container(
                            child: Row(
                              children: [
                                Text("ID Pokemon : "),
                                Text(
                                  state.pokemonDetail!.id!.toString(),
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Container(
                            child: Row(
                              children: [
                                Text("Name : "),
                                Text(
                                  state.pokemonDetail!.name!,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Container(
                            child: Row(
                              children: [
                                Text("Move Name : "),
                                Text(
                                  state.pokemonDetail!.moves![0].move!.name!,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Container(
                            child: Row(
                              children: [
                                Text("Ability Name : "),
                                Text(
                                  state.pokemonDetail!.abilities![0].ability!
                                      .name!,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Container(
                            child: Row(
                              children: [
                                Text("Base Experience : "),
                                Text(
                                  state.pokemonDetail!.baseExperience
                                      .toString(),
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          else
            return Container();
        },
      ),
    );
  }
}
