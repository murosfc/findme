import 'dart:ui';

import 'package:findme/colors/VisualIdColors.dart';
import 'package:flutter/material.dart';
import 'package:localization/localization.dart';

import '../components/AddContact.dart';
import '../model/Contact.dart';
import '../model/User.dart';
import '../components/MainDrawer.dart';
import '../components/SearchBar.dart';

class FindnMeHome extends StatefulWidget {
  @override
  _FindnMeHomeState createState() => _FindnMeHomeState();
}

class _FindnMeHomeState extends State<FindnMeHome> {
  List<Contact> normal = <Contact>[];
  List<Contact> requests = <Contact>[];
  List<Contact> pending = <Contact>[];
  List<Contact> blocked = <Contact>[];
  final List<Tab> tabs = <Tab>[
    Tab(text: 'contacts'.i18n()),
    Tab(text: 'contact-requests'.i18n()),
    Tab(text: 'pending'.i18n()),
    const Tab(icon: Icon(Icons.block)),
  ];

  bool _isLoading = true;
  Contact _newContactAdd = Contact(0, '', '', '');

  @override
  void initState() {
    super.initState();
    loadContactList();
  }

  Future<void> loadContactList() async {
    normal = await User().getContactList("NORMAL");
    requests = await User().getContactList("REQUESTS");
    pending = await User().getContactList("PENDING");
    blocked = await User().getContactList("BLOCKED");
    setState(() {
      _isLoading = false;
    });
  }

  void _handleAddContact(Contact newContactAdd) {
    if (newContactAdd.id != 0) {
      setState(() {
        pending.add(newContactAdd);
      });
      _newContactAdd = Contact(0, '', '', '');
    }
  }

  Future<Contact> _showAddContactDialog() async {
    return await showDialog(
      context: context,
      builder: (_) => AddContactDialog(onAddContact: _handleAddContact),
    );
  }

  Future<void> handleSelectedUserOption(String value, Contact contact) async {
    if (value == 'request_location') {
      //aqui eu acho que vai enviar o id e o token da pessoa que pediu para localizar e o id da pessoa que ta sendo
      // requisitado a localizacao
      //enviar essas infos pra api em python?
    } else if (value == 'block_user') {
      //bloquear o usuario
    } else if (value == 'delete_user') {
      //deletar o usuario
    }
  }

  Widget _buildEmptyListPlaceholder() {
    return Center(
      child: Text(
        'no-contacts'.i18n(),
        style: const TextStyle(fontSize: 18.0),
      ),
    );
  }

  Widget buildContactsList(List<Contact> list) {
    if (list.isEmpty) {
      return _buildEmptyListPlaceholder();
    }
    return ListView.separated(
      padding: const EdgeInsets.all(16.0),
      itemCount: list.length,
      itemBuilder: (context, index) => ClipRRect(
        borderRadius: BorderRadius.circular(15.0),
        child: Container(
          color: VisualIdColors.colorBlue(),
          child: Column(
            children: [
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: VisualIdColors.colorGreen(),
                  backgroundImage: NetworkImage(list[index].pictureURL),
                  child: Text(
                    list[index].pictureURL == ""
                        ? list[index].getFirstNamesLetters()
                        : "",
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      "${list[index].name} ${list[index].familyName}",
                      style: const TextStyle(color: Colors.white),
                    ),
                    const Spacer(),
                    // IconButton(
                    //   icon: const Icon(Icons.more_vert),
                    //   onPressed: () {},
                    // ),
                    Container(
                      child: PopupMenuButton<String>(
                        itemBuilder: (BuildContext context) =>
                            <PopupMenuEntry<String>>[
                          const PopupMenuItem<String>(
                            value: 'request_location',
                            child: Text('Request location'),
                          ),
                          const PopupMenuItem<String>(
                            value: 'block_user',
                            child: Text('Block user'),
                          ),
                          const PopupMenuItem<String>(
                            value: 'delete_user',
                            child: Text('Delete User'),
                          ),
                          // Add more items as needed
                        ],
                        onSelected: (String value) {
                          // Send the information of the user that was clicked on
                          handleSelectedUserOption(value, list[index]);
                        },
                        icon: const Icon(Icons.more_vert),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      separatorBuilder: (BuildContext context, int index) =>
          const SizedBox(height: 10),
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
            isScrollable: true,
            indicatorColor: Colors.white,
            indicatorSize: TabBarIndicatorSize.label,
            tabs: tabs,
          ),
        ),
        body: _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : TabBarView(
                children: [
                  normal.isEmpty
                      ? Center(
                          child: Text(
                            'no-contacts'.i18n(),
                            style: const TextStyle(color: Colors.white),
                          ),
                        )
                      : buildContactsList(normal),
                  requests.isEmpty
                      ? Center(
                          child: Text(
                            'no-contacts-request'.i18n(),
                            style: const TextStyle(color: Colors.white),
                          ),
                        )
                      : buildContactsList(requests),
                  pending.isEmpty
                      ? Center(
                          child: Text(
                            'no-pending-approval'.i18n(),
                            style: const TextStyle(color: Colors.white),
                          ),
                        )
                      : buildContactsList(pending),
                  blocked.isEmpty
                      ? Center(
                          child: Text(
                            'no-contacts-blocked'.i18n(),
                            style: const TextStyle(color: Colors.white),
                          ),
                        )
                      : buildContactsList(blocked),
                ],
              ),
        drawer: Drawer(
          child: MainDrawer(),
        ),
      ),
    );
  }
}
