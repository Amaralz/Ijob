import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ijob/Components/toastMessage.dart';
import 'package:ijob/Core/services/geralUse/categorList.dart';
import 'package:ijob/Core/Entities/chat.dart';
import 'package:ijob/Core/Entities/profileUser.dart';
import 'package:ijob/Core/services/geralUse/profileUserList.dart';
import 'package:ijob/Core/Entities/servicer.dart';
import 'package:ijob/Core/services/chat/chatServices.dart';
import 'package:ijob/pages/mapPage.dart';
import 'package:ijob/Core/utils/icnoMap.dart';
import 'package:provider/provider.dart';

class Prestadorpage extends StatelessWidget {
  Future<void> _createNewChat(
    BuildContext context,
    Servicer servicer,
    Profileuser user,
  ) async {
    if (user.id == null || servicer.id == null) return;

    bool? check = await Chatservices().checkExistingChat(user.id, servicer.id);

    if (check == true) {
      Toastmessage(
        title: "Conversa já existe",
        subtitle: "Conversa com ${servicer.nome} já está em suas conversas!",
        primaryColor: Colors.red,
        icon: Icon(Icons.message),
      ).toast(context);
    } else {
      try {
        await Chatservices().createChat(
          Chat(
            createdAt: DateTime.now(),
            id: '',
            participants: [servicer.id!, user.id!],
            servicerId: servicer.id!,
            userName: user.nome!,
            situation: "Ativa",
          ),
        );

        Toastmessage(
          title: "Conversa criada!",
          subtitle: "Conversa com ${servicer.nome} foi adicionada à conversas",
          primaryColor: Theme.of(context).secondaryHeaderColor,
          icon: Icon(Icons.message),
        ).toast(context);
      } catch (error) {
        throw "Erro inesperado ao juntar dados para criação do chat";
      }
    }
  }

  Icon corvertIcon(String iconName, BuildContext context) {
    IconData iconData = Icnomap.getIconData(iconName);
    return Icon(iconData, size: 20, color: Theme.of(context).primaryColor);
  }

  @override
  Widget build(BuildContext context) {
    final catProvider = Provider.of<Categorlist>(context, listen: false);
    final user = Provider.of<Profileuserlist>(context, listen: false).profile;

    final Servicer servicer =
        ModalRoute.of(context)!.settings.arguments as Servicer;

    final bool hasAddress = servicer.endereco != null;

    final String _address = hasAddress
        ? "${servicer.endereco!.locality}, ${servicer.endereco!.route}, ${servicer.endereco!.number}"
        : "Sem endereço";
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
                      backgroundImage: servicer.url != null
                          ? NetworkImage(servicer.url!)
                          : null,
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
                                  cat?.name ?? "Categoria",
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                corvertIcon(
                                  cat?.icon.toString() ?? "default",
                                  context,
                                ),
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
                      onPressed: (hasAddress)
                          ? () async {
                              LatLng _userp =
                                  user.endereco?.latilong ?? LatLng(0, 0);
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => Mappage(
                                    initial: servicer.endereco!.latilong,
                                    userp: _userp,
                                  ),
                                  fullscreenDialog: true,
                                ),
                              );
                            }
                          : null,
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
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadiusGeometry.circular(15),
            ),
            backgroundColor: Theme.of(context).secondaryHeaderColor,
          ),
          onPressed: () async {
            return await _createNewChat(context, servicer, user);
          },
          child: Text(
            "Iniciar Pedido",
            style: TextStyle(color: Theme.of(context).primaryColor),
          ),
        ),
      ),
    );
  }
}
