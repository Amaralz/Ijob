import 'package:flutter/material.dart';
import 'package:ijob/Entities/servicer.dart';

class Servicerlisttile extends StatelessWidget {
  final Servicer? servicer;

  Servicerlisttile({@required this.servicer});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Card(
      clipBehavior: Clip.hardEdge,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusGeometry.circular(10),
      ),
      child: Expanded(
        child: ElevatedButton(
          onPressed: () => (),
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.all(2),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadiusGeometry.circular(10),
            ),
          ),
          child: ListTile(
            leading: CircleAvatar(
              radius: 30,
              backgroundImage: servicer!.url == null
                  ? NetworkImage(
                      "https://thumbs.dreamstime.com/b/default-profile-picture-avatar-photo-placeholder-vector-illustration-default-profile-picture-avatar-photo-placeholder-vector-189495158.jpg",
                    )
                  : NetworkImage(servicer!.url!),
            ),
            title: Text(
              servicer!.nome!,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(servicer!.category!.name!),
          ),
        ),
      ),
    );
  }
}
