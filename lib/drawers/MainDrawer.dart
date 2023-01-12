import 'package:findme/colors/VisualIdColors.dart';
import 'package:flutter/material.dart';

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
              padding: EdgeInsets.only(top: 50.0, left: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
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
          SizedBox(
            height: 20.0,
          ),
          ListTile(
            onTap: () {},
            leading: Icon(
              Icons.add,
              color: Colors.white70,
            ),
            title: Text("Adicionar contato",
                style: TextStyle(color: Colors.white70)),
          ),
          ListTile(
            onTap: () {},
            leading: Icon(
              Icons.star_border,
              color: Colors.white70,
            ),
            title: Text("Gerenciar favoritos",
                style: TextStyle(color: Colors.white70)),
          ),
          ListTile(
            onTap: () {},
            leading: Icon(
              Icons.lock,
              color: Colors.white70,
            ),
            title: Text("Permissões", style: TextStyle(color: Colors.white70)),
          ),
          ListTile(
            onTap: () {},
            leading: Icon(
              Icons.settings,
              color: Colors.white70,
            ),
            title:
                Text("Configurações", style: TextStyle(color: Colors.white70)),
          ),
        ],
      ),
    );
  }
}
