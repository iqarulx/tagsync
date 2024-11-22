import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nfc_manager/nfc_manager.dart';
import '/utils/loading.dart';
import '/utils/snackbar.dart';

class Writer extends StatefulWidget {
  const Writer({super.key});

  @override
  State<Writer> createState() => _WriterState();
}

class _WriterState extends State<Writer> {
  final TextEditingController _message = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
        ),
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20),
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('NFC Writer'),
        leading: IconButton(
          tooltip: "Back",
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _message,
                decoration: InputDecoration(
                  labelText: "Message",
                  labelStyle: TextStyle(color: Theme.of(context).primaryColor),
                  border: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Theme.of(context).primaryColor),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Theme.of(context).primaryColor),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Theme.of(context).primaryColor),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                FocusManager.instance.primaryFocus!.unfocus();
                _startNFCWriting(context);
              },
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
              child: const Text(
                'Start NFC Writing',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _startNFCWriting(context) async {
    try {
      futureLoading(context);
      if (_message.text.isNotEmpty) {
        bool isAvailable = await NfcManager.instance.isAvailable();

        if (isAvailable) {
          NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
            try {
              NdefMessage message =
                  NdefMessage([NdefRecord.createText(_message.text)]);
              await Ndef.from(tag)?.write(message);
              Snackbar.showSnackBar(context,
                  content: 'Data emitted successfully', isSuccess: true);
              Uint8List payload = message.records.first.payload;
              String text = String.fromCharCodes(payload);
              Snackbar.showSnackBar(context,
                  content: 'Written data: $text', isSuccess: true);
              NfcManager.instance.stopSession();
            } catch (e) {
              Snackbar.showSnackBar(context,
                  content: 'Error emitting NFC data: $e', isSuccess: false);
            }
          });
        } else {
          Snackbar.showSnackBar(context,
              content: 'ENFC not available.', isSuccess: false);
        }
      } else {
        Snackbar.showSnackBar(context,
            content: 'Message cannot be empty', isSuccess: false);
      }
      Navigator.pop(context);
    } catch (e) {
      Navigator.pop(context);
      Snackbar.showSnackBar(context,
          content: 'Error writing to NFC: $e', isSuccess: false);
    }
  }
}
