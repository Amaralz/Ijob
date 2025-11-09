import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ijob/Core/Entities/categorList.dart';
import 'package:ijob/Core/Entities/servicer.dart';
import 'package:ijob/pages/mapPage.dart';
import 'package:ijob/Core/utils/icnoMap.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';

class Prestadorpage extends StatelessWidget {
  Future<LatLng> getUserPosition() async {
    final position = await Location().getLocation();
    return LatLng(position.latitude!, position.longitude!);
  }

  @override
  Widget build(BuildContext context) {
    final catProvider = Provider.of<Categorlist>(context);

    Icon corvertIcon(String iconName) {
      IconData iconData = Icnomap.getIconData(iconName);
      return Icon(iconData, size: 20, color: Theme.of(context).primaryColor);
    }

    final Servicer servicer =
        ModalRoute.of(context)!.settings.arguments as Servicer;

    final String _address =
        "${servicer.endereco!.locality}, ${servicer.endereco!.route}, ${servicer.endereco!.number}";
    // TODO: implement build
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 50,
            pinned: true,
            title: Text(
              servicer.nome.toString(),
              style: TextStyle(color: Theme.of(context).secondaryHeaderColor),
            ),
            centerTitle: true,
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(servicer.url!),
                      radius: 70,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: servicer.category!.map((category) {
                      final cat = catProvider.categoryById(category);
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).hintColor,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Text(
                                  cat!.name!,
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                corvertIcon(cat.icon.toString()),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  SizedBox(
                    width: 300,
                    child: TextButton.icon(
                      onPressed: () async {
                        LatLng _userp = await getUserPosition();
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => Mappage(
                              initial: servicer.endereco!.latilong,
                              userp: _userp,
                            ),
                            fullscreenDialog: true,
                          ),
                        );
                      },
                      label: Text(_address, overflow: TextOverflow.ellipsis),
                      icon: Icon(Icons.add_location),
                    ),
                  ),
                ],
              ),
            ]),
          ),
        ],
      ),
      bottomNavigationBar: SizedBox(
        width: double.maxFinite,
        height: 50,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadiusGeometry.circular(15),
            ),
            backgroundColor: Theme.of(context).secondaryHeaderColor,
          ),
          onPressed: () {},
          child: Text(
            "Iniciar Pedido",
            style: TextStyle(color: Theme.of(context).primaryColor),
          ),
        ),
      ),
    );
  }
}
