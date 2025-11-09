import 'package:flutter/material.dart';
import 'package:ijob/Core/Entities/categorList.dart';
import 'package:ijob/Core/Entities/servicer.dart';
import 'package:ijob/Core/utils/routes.dart';
import 'package:provider/provider.dart';

class Servicerlisttile extends StatelessWidget {
  final Servicer? servicer;

  const Servicerlisttile({this.servicer});

  @override
  Widget build(BuildContext context) {
    final String _address =
        "${servicer!.endereco!.route}, ${servicer!.endereco!.number}";
    final provider = Provider.of<Categorlist>(context);
    // TODO: implement build
    return Card(
      clipBehavior: Clip.hardEdge,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusGeometry.circular(10),
      ),
      child: ElevatedButton(
        onPressed: () => Navigator.of(
          context,
        ).pushNamed(Routes.PRESTADOR, arguments: servicer),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusGeometry.circular(10),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            spacing: 10,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(servicer!.url!),
                ),
              ),
              Column(
                spacing: 2,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    servicer!.nome!,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Row(
                    spacing: 3,
                    children: [
                      SizedBox(
                        width: 120,
                        child: Text(
                          _address,
                          style: TextStyle(color: Colors.white),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Icon(Icons.circle, size: 5, color: Colors.grey),
                      Icon(Icons.star, size: 15),
                      Text(servicer!.rating.toString(), style: TextStyle()),
                    ],
                  ),

                  servicer!.category != null && servicer!.category!.isNotEmpty
                      ? Wrap(
                          spacing: 6,
                          runSpacing: 4,
                          children: servicer!.category!
                              .map(
                                (category) => Container(
                                  decoration: BoxDecoration(
                                    color: const Color.fromARGB(
                                      52,
                                      158,
                                      158,
                                      158,
                                    ),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  padding: const EdgeInsets.all(3),
                                  child: SizedBox(
                                    height: 18,
                                    child: Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: FittedBox(
                                        alignment: AlignmentGeometry.center,
                                        child: Text(
                                          provider
                                              .categoryById(category)!
                                              .name!,
                                          style: TextStyle(
                                            color: const Color.fromARGB(
                                              255,
                                              173,
                                              173,
                                              173,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        )
                      : const SizedBox.shrink(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
