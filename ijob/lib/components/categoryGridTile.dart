import 'package:flutter/material.dart';
import 'package:ijob/Core/Entities/categor.dart';
import 'package:ijob/Core/utils/icnoMap.dart';
import 'package:ijob/Core/utils/routes.dart';

class Categorygridtile extends StatelessWidget {
  final Categor? categoria;

  const Categorygridtile({@required this.categoria});

  @override
  Widget build(BuildContext context) {
    Icon corvertIcon(String iconName) {
      IconData iconData = Icnomap.getIconData(iconName);
      return Icon(
        iconData,
        size: 40,
        color: Theme.of(context).unselectedWidgetColor,
      );
    }

    // TODO: implement build
    return Card(
      elevation: 1,
      child: ElevatedButton(
        onPressed: () => Navigator.of(
          context,
        ).pushNamed(Routes.SERVICOSFILTRADOS, arguments: categoria),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusGeometry.circular(10),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            corvertIcon(categoria!.icon.toString()),
            Container(
              alignment: Alignment.center,
              width: 90,
              child: Text(
                categoria!.name![0].toUpperCase() +
                    categoria!.name!.substring(1),
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
