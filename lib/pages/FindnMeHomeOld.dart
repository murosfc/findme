import 'dart:ui';

import 'package:findme/colors/VisualIdColors.dart';
import 'package:flutter/material.dart';

import '../drawers/MainDrawer.dart';
import '../drawers/SearchBar.dart';
import '../model/Contacts.dart';

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
                contacts.add(Contacts(
                    012357354367,
                    "Novo contato",
                    "novo@gmail.com",
                    "https://upload.wikimedia.org/wikipedia/commons/thumb/3/34/Elon_Musk_Royal_Society_%28crop2%29.jpg/1200px-Elon_Musk_Royal_Society_%28crop2%29.jpg"));
              });
              print(contacts[contacts.length - 1].getFirstNameLetter());
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
                  backgroundImage: NetworkImage(contacts[index].pictureURL),
                  child: Text(contacts[index].getFirstNameLetter(),
                      style: const TextStyle(color: Colors.white)),
                ),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Text(contacts[index].name,
                        style: const TextStyle(color: Colors.white)),
                    const Spacer(),
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
