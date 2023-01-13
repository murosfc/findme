import 'dart:ui';

import 'package:findme/colors/VisualIdColors.dart';
import 'package:flutter/material.dart';

import 'drawers/MainDrawer.dart';
import 'drawers/SearchBar.dart';
import 'model/Contacts.dart';

class FindnMeHome extends StatefulWidget {
  @override
  _FindnMeHomeState createState() => _FindnMeHomeState();
}

class _FindnMeHomeState extends State<FindnMeHome> {
  final contacts = <Contacts>[];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Find'n Me"),
        elevation: 0.7,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.person_add),
            onPressed: () {
              setState(() {
                contacts.add(Contacts(name: "Novo contato"));
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(context: context, delegate: SearchBar());
            },
          ),
        ],
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16.0),
        itemCount: contacts.length,
        itemBuilder: (context, index) => ClipRRect(
          borderRadius: BorderRadius.circular(15.0),
          child: Container(
            color: VisualIdColors.colorBlue(),
            child: Column(children: [
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: VisualIdColors.colorGreen(),
                  child: Text(contacts[index].getFirstNameLetter()),
                ),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Text(contacts[index].name,
                        style: const TextStyle(color: Colors.white)),
                    const SizedBox(
                      width: 80, //TEMPORÁRIO
                    ),
                    IconButton(
                      icon: const Icon(Icons.favorite),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: const Icon(Icons.more_vert),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
            ]),
          ),
        ),
        separatorBuilder: (BuildContext context, int index) => const SizedBox(
          height: 10,
        ),
      ),
      drawer: Drawer(
        child: MainDrawer(),
      ),
    );
  }
}
