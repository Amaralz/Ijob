import 'package:flutter/material.dart';
import 'package:ijob/Entities/servicer.dart';

class Middlelistservices extends StatelessWidget {
  final List<Servicer> servicers;

  Middlelistservices(this.servicers);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.symmetric(vertical: 8),
      height: 300,
      child: ListView.builder(
        itemCount: servicers.length,
        itemBuilder: (ctx, index) {
          final servicer = servicers[index];
          return Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadiusGeometry.circular(10),
            ),
            child: ListTile(
              leading: CircleAvatar(
                radius: 30,
                backgroundImage: servicer.url == null
                    ? NetworkImage(
                        "https://thumbs.dreamstime.com/b/default-profile-picture-avatar-photo-placeholder-vector-illustration-default-profile-picture-avatar-photo-placeholder-vector-189495158.jpg",
                      )
                    : NetworkImage(servicer.url!),
              ),
              title: Text(
                servicer.nome!,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(servicer.category!.name!),
            ),
          );
        },
      ),
    );
  }
}
