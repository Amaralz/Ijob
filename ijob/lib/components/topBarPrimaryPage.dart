import 'package:flutter/material.dart';
import 'package:ijob/Components/barSearchPrimaryPage.dart';

class topBarPrimaryPage extends StatelessWidget {
  final void Function(String) _funct;

  topBarPrimaryPage(this._funct);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: const Color.fromARGB(255, 20, 20, 20),
        boxShadow: [
          BoxShadow(color: Colors.black, spreadRadius: 1, blurRadius: 3),
        ],
      ),
      height: 250,
      child: Row(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(7.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 370,
                  height: 100,
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage(
                        "https://pt.quizur.com/_image?href=https://img.quizur.com/f/img5f0c80e0bd9d08.31973740.jpg?lastEdited=1594654954&w=600&h=600&f=webp",
                      ),
                    ),
                    title: Text(
                      "Bem Vindo!",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    subtitle: Text(
                      " Seu nome",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                barSearchPrimaryPage(_funct),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
