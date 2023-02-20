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
  final List<Tab> tabs = <Tab>[
    Tab(text: 'Contatos'),
    Tab(text: 'Aguardando Aprovação'),
    Tab(text: 'Bloqueados'),
  ];
  final List<List<Contacts>> contactLists = <List<Contacts>>[];

  @override
  void initState() {
    super.initState();
    contactLists.addAll([
      contacts,
      <Contacts>[],
      <Contacts>[],
    ]);
  }

  void addToContactsList() {
    setState(() {
      contacts.add(Contacts(12357354367, "Novo contato", "novo@gmail.com",
          "https://upload.wikimedia.org/wikipedia/commons/thumb/3/34/Elon_Musk_Royal_Society_%28crop2%29.jpg/1200px-Elon_Musk_Royal_Society_%28crop2%29.jpg"));
    });
    print(contacts[contacts.length - 1].getFirstNameLetter());
  }

  Widget buildContactsList(List<Contacts> list) {
    return ListView.separated(
      padding: const EdgeInsets.all(16.0),
      itemCount: list.length,
      itemBuilder: (context, index) => ClipRRect(
        borderRadius: BorderRadius.circular(15.0),
        child: Container(
          color: VisualIdColors.colorBlue(),
          child: Column(children: [
            ListTile(
              leading: CircleAvatar(
                backgroundColor: VisualIdColors.colorGreen(),
                backgroundImage: NetworkImage(list[index].pictureURL),
                child: Text(list[index].getFirstNameLetter(),
                    style: const TextStyle(color: Colors.white)),
              ),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Text(list[index].name,
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Find'n Me"),
          elevation: 0.7,
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.person_add),
              onPressed: addToContactsList,
            ),
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                showSearch(context: context, delegate: SearchBar());
              },
            ),
          ],
          bottom: TabBar(
            tabs: tabs,
          ),
        ),
        body: TabBarView(
          children: [
            buildContactsList(contactLists[0]),
            buildContactsList(contactLists[1]),
            buildContactsList(contactLists[2]),
          ],
        ),
        drawer: Drawer(
          child: MainDrawer(),
        ),
      ),
    );
  }
}
