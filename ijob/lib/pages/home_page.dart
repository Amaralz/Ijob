import 'package:flutter/material.dart';
import 'package:ijob/Components/bodyPrimaryPage.dart';
import 'package:ijob/Components/topBarPrimaryPage.dart';
import 'package:ijob/components/side_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  test(String objeto) {}

  @override
  Widget build(BuildContext context) {
    final appbar = AppBar();

    final availableHeight =
        MediaQuery.of(context).size.height -
        appbar.preferredSize.height -
        MediaQuery.of(context).padding.top;

    return Scaffold(
      drawer: const Sidebar(), //adicionar lugares para navegar futuramente
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              height: availableHeight * 0.2,
              width: double.maxFinite,
              child: topBarPrimaryPage(),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: Container(
                height: availableHeight * 0.87,
                child: Bodyprimarypage(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
