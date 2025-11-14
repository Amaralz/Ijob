import 'package:flutter/material.dart';
import 'package:ijob/components/categoryGridPrimaryPage.dart';
import 'package:ijob/components/topBarPrimaryPage.dart';
import 'package:ijob/components/topServicersList.dart';
import 'package:ijob/Entities/categorList.dart';
import 'package:ijob/components/side_bar.dart';
import 'package:ijob/pages/editar_perfil_page.dart';
import 'package:ijob/services/perfil_provider.dart';
import 'package:ijob/utils/routes.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PerfilProvider>().carregarPerfil(context);
    });
    Provider.of<Categorlist>(context, listen: false).loadCategors().then((_) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  Widget placerText(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, left: 15, top: 2),
      child: Text(
        text,
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
      ),
    );
  }

  void _abrirEditarPerfil() async {
    Navigator.pushNamed(context, Routes.EDITARPERFIL);
  }

  @override
  Widget build(BuildContext context) {
    final appbar = AppBar();

    final availableHeight =
        MediaQuery.of(context).size.height -
        appbar.preferredSize.height -
        MediaQuery.of(context).padding.top;

    return Scaffold(
      drawer: Sidebar(),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: Colors.blue))
          : SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  GestureDetector(
                    onTap: _abrirEditarPerfil,
                    child: topBarPrimaryPage(),
                    //height: availableHeight * 0.2,
                    //width: double.maxFinite,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 15.0),
                    child: SizedBox(
                      height: availableHeight * 0.7,
                      child: SizedBox(
                        width: double.maxFinite,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            placerText("Escolha por Categoria"),
                            SizedBox(
                              height: 100,
                              child: Categorygridprimarypage(),
                            ),
                            placerText("Top Serviços"),
                            Expanded(child: Topservicerslist()),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
