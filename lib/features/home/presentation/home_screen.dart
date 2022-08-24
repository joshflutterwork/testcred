import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:testcreditbook/features/detail/presentation/detail_screen.dart';
import 'package:testcreditbook/features/home/bloc/home_bloc.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  HomeBloc homeBloc = HomeBloc();
  int _counter = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    homeBloc.add(GetPokemonList());
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
              Icons.download,
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

  final pdf = pw.Document();

  Future<Uint8List> getPDFData() async {
    return await pdf.save();
  }

  Future<File> _getLocalFile(String pathFlie) async {
    final root = await getApplicationDocumentsDirectory();
    final path = "$root" + '/fileNew.pdf';
    return File(path).create(recursive: true);
  }

  getDocument(PokemonLoaded state) async {
    pdf.addPage(pw.Page(
      pageFormat: PdfPageFormat.letter,
      build: (pw.Context context) {
        return pw.ListView.builder(
            itemBuilder: (_, index) {
              return pw.Container(
                padding: pw.EdgeInsets.all(8),
                child: pw.Container(
                  child: pw.Container(
                      padding: pw.EdgeInsets.only(
                          top: 16, bottom: 16, left: 16, right: 16),
                      child: pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Text(
                            state.pokemonModel!.results![index].name!
                                .toUpperCase(),
                            style: pw.TextStyle(
                                fontSize: 16,
                                fontWeight: pw.FontWeight.bold,
                                letterSpacing: 0.2),
                          ),
                        ],
                      )),
                ),
              );
            },
            itemCount: state.pokemonModel!.results!.length);
      },
    )); //

    final root = await getApplicationDocumentsDirectory();

    final file = File(root.path + '/fileNew.pdf')
      ..writeAsBytes(await pdf.save());

    OpenFile.open(file.path);
  }

  Widget listOfPokemon(PokemonLoaded state) {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: state.pokemonModel!.results!.length,
        itemBuilder: (_, index) {
          return Container(
            padding: EdgeInsets.all(8),
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
              elevation: 2,
              color: Colors.teal[50],
              child: Container(
                  padding:
                      EdgeInsets.only(top: 16, bottom: 16, left: 16, right: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        state.pokemonModel!.results![index].name!.toUpperCase(),
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.2),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DetailScreen(
                                      url: state
                                          .pokemonModel!.results![index].url,
                                    )),
                          );
                        },
                        child: Container(
                            padding: EdgeInsets.all(8),
                            child: Card(
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30)),
                                color: Colors.teal.withOpacity(0.2),
                                child: Container(
                                  width: 70,
                                  height: 30,
                                  alignment: Alignment.center,
                                  child: Text(
                                    'Detail',
                                    textAlign: TextAlign.center,
                                  ),
                                ))),
                      ),
                    ],
                  )),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.teal[100],
          title: Text("Pokemon List"),
        ),
        body: BlocConsumer<HomeBloc, HomeState>(
          bloc: homeBloc,
          listener: (context, state) {
            // TODO: implement listener
          },
          builder: (context, state) {
            if (state is PokemonLoaded)
              return Column(
                children: [
                  Container(
                      padding: EdgeInsets.all(16),
                      child: button(context, onTap: () {
                        getDocument(state);
                      }, text: "Download")),
                  Expanded(child: listOfPokemon(state))
                ],
              );
            else
              return Container();
          },
        ));
  }
}
