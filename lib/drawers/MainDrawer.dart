import 'package:findme/colors/VisualIdColors.dart';
import 'package:flutter/material.dart';
import 'package:localization/localization.dart';

class MainDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: VisualIdColors.colorBlue(),
      child: Column(
        children: [
          Container(
            color: VisualIdColors.colorBlue(),
            child: Padding(
              padding: const EdgeInsets.only(top: 50.0, left: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: const [
                  Text(
                    "Menu",
                    style: TextStyle(
                      fontSize: 25.0,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                    //textAlign: TextAlign.left,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 20.0,
          ),
          ListTile(
            onTap: () {},
            leading: const Icon(
              Icons.add,
              color: Colors.white70,
            ),
            title: const Text("Adicionar contato",
                style: TextStyle(color: Colors.white70)),
          ),
          ListTile(
            onTap: () {},
            leading: const Icon(
              Icons.star_border,
              color: Colors.white70,
            ),
            title: const Text("Gerenciar favoritos",
                style: TextStyle(color: Colors.white70)),
          ),
          ListTile(
            onTap: () {},
            leading: const Icon(
              Icons.lock,
              color: Colors.white70,
            ),
            title: const Text("Permissões",
                style: TextStyle(color: Colors.white70)),
          ),
          ListTile(
            onTap: () {},
            leading: const Icon(
              Icons.settings,
              color: Colors.white70,
            ),
            title: const Text("Configurações",
                style: TextStyle(color: Colors.white70)),
          ),
        ],
      ),
    );
  }
}
