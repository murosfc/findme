import 'package:findme/model/RealTimeLocation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../../model/LocationHandler.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class LocationConfirmationPage extends StatefulWidget {
  @override
  _LocationConfirmationPageState createState() =>
      _LocationConfirmationPageState();
}

class _LocationConfirmationPageState extends State<LocationConfirmationPage> {
  late RealTimeLocation realTimeLocation;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Compartilhar Localização'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Deseja compartilhar sua localização?'),
            ElevatedButton(
              child: Text('Sim'),
              onPressed: () {
                _shareLocation(true);
              },
            ),
            ElevatedButton(
              child: Text('Não'),
              onPressed: () {
                _shareLocation(false);
              },
            ),
            ElevatedButton(
              child: Text('Desconectar'),
              onPressed: () {
                _disconnect();
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _disconnect() async {
    realTimeLocation.disconnect();
  }

  Future<void> _shareLocation(share_location) async {
    if (share_location) {
      //criar rooom para enviar localizacao
      PermissionStatus status = await Permission.location.request();

      if (status.isGranted) {
        realTimeLocation = new RealTimeLocation();
        //Gerar um id aleátorio para a room
        String roomId = realTimeLocation.generateRoomId();
        realTimeLocation.connect();
        realTimeLocation.close();

        //Entrar em uma sala
        realTimeLocation.joinRoom(roomId);
        realTimeLocation.shareLocation(roomId);
        int responseStatusCode =
            await LocationHandler().locationFeedBack(true, roomId);

        print(responseStatusCode);
      }
    } else {
      int responseStatusCode =
          await LocationHandler().locationFeedBack(false, "none");
    }
  }
}
