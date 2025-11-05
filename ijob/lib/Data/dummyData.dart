import 'package:ijob/Entities/categor.dart';
import 'package:ijob/Entities/servicer.dart';

final DummyServicer = [
  Servicer(
    id: '1',
    nome: 'Carlos',
    category: [
      Categor(id: "srtrkNDIUSAwi-12pddas2", name: "Pintura"),
      Categor(id: "skadnISDAskSO2SODfpddas2", name: "Eletricista"),
    ],
    url:
        "https://thumbs.dreamstime.com/b/eletricista-nos-macac%C3%B5es-cercados-com-fontes-e-ferramentas-da-eletricidade-103748791.jpg",
  ),
  Servicer(
    id: '3',
    nome: 'Tiago',
    category: [Categor(id: "skadnISDAskSO2SODfpddas2", name: "Eletricista")],
    url:
        "https://thumbs.dreamstime.com/b/eletricista-nos-macac%C3%B5es-cercados-com-fontes-e-ferramentas-da-eletricidade-103748791.jpg",
  ),
];
