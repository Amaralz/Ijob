import 'package:flutter/material.dart';
import 'package:ijob/Core/Entities/profileUser.dart';
import 'package:ijob/Core/services/geralUse/profileUserList.dart';
import 'package:provider/provider.dart';

class topBarPrimaryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Profileuser user = Provider.of<Profileuserlist>(context).profile;
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
                        user.url ??
                            "https://thumbs.dreamstime.com/b/default-profile-picture-avatar-photo-placeholder-vector-illustration-default-profile-picture-avatar-photo-placeholder-vector-189495158.jpg",
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
                      user.nome!,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
