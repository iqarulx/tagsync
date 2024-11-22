import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nfc_manager/nfc_manager.dart';
import '/screens/writer.dart';
import '/utils/loading.dart';
import '/utils/snackbar.dart';

class Reader extends StatefulWidget {
  const Reader({super.key});

  @override
  State<Reader> createState() => _ReaderState();
}

class _ReaderState extends State<Reader> {
  String _nfcData = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Padding(
          padding: EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundImage: AssetImage('assets/images/logo.png'),
          ),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
        ),
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20),
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('NFC Reader'),
        actions: [
          IconButton(
            tooltip: "NFC Writer",
            icon: const Icon(Icons.edit_rounded),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return const Writer();
              }));
            },
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(
                  Theme.of(context).primaryColor,
                ),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                shape: WidgetStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              onPressed: () {
                _startNFCReading(context);
              },
              child: const Text(
                'Start NFC Reading',
                style: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(height: 10),
            if (_nfcData.isNotEmpty)
              Text(
                "Nfc Data : $_nfcData",
                textAlign: TextAlign.center,
              )
          ],
        ),
      ),
    );
  }

  void _startNFCReading(context) async {
    try {
      futureLoading(context);
      bool isAvailable = await NfcManager.instance.isAvailable();

      if (isAvailable) {
        NfcManager.instance.startSession(
          onDiscovered: (NfcTag tag) async {
            Snackbar.showSnackBar(context,
                content: "NFC Tag Detected", isSuccess: true);
            _nfcData = json.encode(tag.data);
          },
        );
        NfcManager.instance.stopSession();
      } else {
        Snackbar.showSnackBar(context,
            content: "NFC not available.", isSuccess: false);
      }

      Navigator.pop(context);
      setState(() {});
    } catch (e) {
      Navigator.pop(context);
      Snackbar.showSnackBar(context,
          content: "Error reading NFC: $e", isSuccess: false);
    }
  }
}
