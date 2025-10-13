import 'package:flutter/material.dart';
import 'package:ijob/Entities/categor.dart';
import 'package:ijob/Entities/servicer.dart';

final DummyCategor = [
  Categor(id: '1', name: "Eletricista", icon: Icons.electric_bolt_outlined),
  Categor(id: '2', name: "Pintura", icon: Icons.format_paint),
  Categor(id: '3', name: "Encanação", icon: Icons.bathroom),
  Categor(id: '4', name: "Limpeza", icon: Icons.water_drop_outlined),
  Categor(id: '5', name: "Tutoria", icon: Icons.menu_book),
  Categor(id: '6', name: "Mudança", icon: Icons.fire_truck_sharp),
];

final DummyServicer = [
  Servicer(
    id: '1',
    nome: 'Carlos',
    category: Categor(id: '2', name: "Pintura"),
    url:
        "https://thumbs.dreamstime.com/b/eletricista-nos-macac%C3%B5es-cercados-com-fontes-e-ferramentas-da-eletricidade-103748791.jpg",
  ),
  Servicer(
    id: '3',
    nome: 'Tiago',
    category: Categor(id: '1', name: "Eletricista"),
    url:
        "https://thumbs.dreamstime.com/b/eletricista-nos-macac%C3%B5es-cercados-com-fontes-e-ferramentas-da-eletricidade-103748791.jpg",
  ),
  Servicer(
    id: '4',
    nome: 'Simão',
    category: Categor(id: '4', name: "Limpeza"),
    url:
        "https://thumbs.dreamstime.com/b/eletricista-nos-macac%C3%B5es-cercados-com-fontes-e-ferramentas-da-eletricidade-103748791.jpg",
  ),
  Servicer(
    id: '5',
    nome: 'Sônia',
    category: Categor(id: '5', name: "Tutoria"),
    url:
        "https://thumbs.dreamstime.com/b/eletricista-nos-macac%C3%B5es-cercados-com-fontes-e-ferramentas-da-eletricidade-103748791.jpg",
  ),
  Servicer(
    id: '6',
    nome: 'Jorge',
    category: Categor(id: '3', name: "Encanação"),
    url:
        "https://thumbs.dreamstime.com/b/eletricista-nos-macac%C3%B5es-cercados-com-fontes-e-ferramentas-da-eletricidade-103748791.jpg",
  ),
  Servicer(
    id: '7',
    nome: 'Matheus',
    category: Categor(id: '3', name: "Encanação"),
    url:
        "https://thumbs.dreamstime.com/b/eletricista-nos-macac%C3%B5es-cercados-com-fontes-e-ferramentas-da-eletricidade-103748791.jpg",
  ),
];
