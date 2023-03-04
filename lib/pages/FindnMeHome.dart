import 'dart:ui';

import 'package:findme/colors/VisualIdColors.dart';
import 'package:flutter/material.dart';
import 'package:localization/localization.dart';

import '../components/AddContact.dart';
import '../model/Contact.dart';
import '../components/MainDrawer.dart';
import '../components/SearchBar.dart';

class FindnMeHome extends StatefulWidget {
  @override
  _FindnMeHomeState createState() => _FindnMeHomeState();
}

class _FindnMeHomeState extends State<FindnMeHome> {
  List<Contact> normal = <Contact>[],
      pending = <Contact>[],
      blocked = <Contact>[];
  final List<Tab> tabs = <Tab>[
    Tab(text: 'contacts'.i18n()),
    Tab(text: 'pending'.i18n()),
    Tab(text: 'blocked'.i18n()),
  ];

  bool _isLoading = true;
  Contact _newContactAdd = Contact(0, '', '', '');

  @override
  void initState() {
    super.initState();
    loadContactList();
  }

  Future<void> loadContactList() async {
    normal = await Contact.getContactList("NORMAL");
    pending = await Contact.getContactList("PENDING");
    blocked = await Contact.getContactList("BLOCKED");
    setState(() {
      _isLoading = false;
    });
  }

  void _handleAddContact(Contact _newContactAdd) {
    print(_newContactAdd.name);
    if (_newContactAdd.id != 0) {
      setState(() {
        pending.add(_newContactAdd);
      });
      //_newContactAdd = Contact(0, '', '', '');
    }
  }

  Future<Contact> _showAddContactDialog() async {
    return await showDialog(
      context: context,
      builder: (_) => AddContactDialog(onAddContact: _handleAddContact),
    );
  }

  Widget buildContactsList(List<Contact> list) {
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
                child: Text(
                    list[index].pictureURL == ""
                        ? list[index].getFirstNamesLetters()
                        : "",
                    style: const TextStyle(color: Colors.white)),
              ),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Text("${list[index].name} ${list[index].familyName}",
                      style: const TextStyle(color: Colors.white)),
                  const Spacer(),
                  /*IconButton(
                    icon: const Icon(Icons.favorite),
                    onPressed: () {},
                  ), TO*/
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
              onPressed: () async {
                _newContactAdd = await _showAddContactDialog();
              },
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
        body: _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : TabBarView(
                children: [
                  buildContactsList(normal),
                  buildContactsList(pending),
                  buildContactsList(blocked),
                ],
              ),
        drawer: Drawer(
          child: MainDrawer(),
        ),
      ),
    );
  }
}
