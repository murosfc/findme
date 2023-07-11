import 'package:findme/colors/VisualIdColors.dart';
import 'package:findme/model/LocationHandler.dart';
import 'package:flutter/material.dart';
import 'package:localization/localization.dart';
import 'package:permission_handler/permission_handler.dart';

import '../api/ResponseStatusCode.dart';
import '../components/AddContact.dart';
import '../model/Contact.dart';
import '../model/Notifications.dart';
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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Notifications.requestFirebaseMessagingPermission();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Notifications.initInfo(context);
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
    switch (value) {
      case 'request_location':
        PermissionStatus status = await Permission.location.request();
        if (status.isGranted) {
          int responseStatusCode =
              await LocationHandler().requestLocation(contact);

          if (responseStatusCode == ResponseStatusCode.SUCCESS) {
            // ignore: use_build_context_synchronously
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => FindnMeHome()),
            );
          } else if (responseStatusCode == ResponseStatusCode.BAD_CREDENTIALS) {
            print("Error");
          } else {
            print("Error");
          }
        }
        break;
      case 'block_user':
        //TODO
        break;
      case 'delete_contact':
        //TODO
        break;
      case 'approve_request':
        print ("ID do contato: $contact.id");
        if (await User().approveRequest(contact)) {
          setState(() {
            requests.remove(contact);            
          });
        }
        break;
      case 'remove_request':
        //TODO
        break;
      case 'unblock_user':
        //TODO
        break;
    }
  }  

  Widget buildContactsList(List<Contact> list, int activeTab) {           
    List<PopupMenuEntry<String>> menuItems = [];

    var requestLocation = PopupMenuItem<String>(
      value: 'request_location',
      child: Text('request-location'.i18n()),
    );
    var blockUser = PopupMenuItem<String>(
      value: 'block_contact',
      child: Text('block-contact'.i18n()),
    );
    var deleteUser = PopupMenuItem<String>(
      value: 'delete_contact',
      child: Text('delete-contact'.i18n()),
    ); 

    if (activeTab == 0) {      
        menuItems.addAll([
          requestLocation,
          blockUser,
          deleteUser,
        ]);
    }else if (activeTab == 1) {
        menuItems.addAll([
          PopupMenuItem<String>(
            value: 'approve_request',
            child: Text('approve-request'.i18n()),
          ),
          blockUser,
          deleteUser,
        ]);
    }else if (activeTab == 2) {
        menuItems.addAll([
          PopupMenuItem<String>(
            value: 'remove_request',
            child: Text('remove-request'.i18n()),
          ),
        ]);
      }else if (activeTab == 3) {
        menuItems.addAll([
          PopupMenuItem<String>(
            value: 'unblock_contact',
            child: Text('unblock-contact'.i18n()),
          ),
        ]);
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
                  //backgroundImage: NetworkImage(list[index].pictureURL), adicionar depois de implementar o login do google para salvar a foto do usuário
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
                    PopupMenuButton<String>(
                      itemBuilder: (BuildContext context) => menuItems,
                      onSelected: (String value) {
                        handleSelectedUserOption(value, list[index]);
                      },
                      icon: const Icon(Icons.more_vert),
                    ),
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
                      : buildContactsList(normal, 0),
                  requests.isEmpty
                      ? Center(
                          child: Text(
                            'no-contacts-request'.i18n(),
                            style: const TextStyle(color: Colors.white),
                          ),
                        )
                      : buildContactsList(requests, 1),
                  pending.isEmpty
                      ? Center(
                          child: Text(
                            'no-pending-approval'.i18n(),
                            style: const TextStyle(color: Colors.white),
                          ),
                        )
                      : buildContactsList(pending, 2),
                  blocked.isEmpty
                      ? Center(
                          child: Text(
                            'no-contacts-blocked'.i18n(),
                            style: const TextStyle(color: Colors.white),
                          ),
                        )
                      : buildContactsList(blocked, 3),
                ],
              ),
        drawer: Drawer(
          child: MainDrawer(),
        ),
      ),
    );
  }
}
