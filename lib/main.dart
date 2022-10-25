import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:mic_stream/mic_stream.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Micro stay alive'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Stream<Uint8List>? stream;
  StreamSubscription<Uint8List>? listener;
  String text = "Microphone is not activated.";

  Future<void> _startListen() async {
    stream = await MicStream.microphone(
      sampleRate: 30000,
      channelConfig: ChannelConfig.CHANNEL_IN_MONO,
    );
    setState(() {
      text = "Microphone is activated.";
    });

    listener = stream!.listen(
      (samples) {
        debugPrint('===> [Microphone] is listening');
      },
      onDone: () {
        debugPrint('===> [Microphone] onDone');
      },
      onError: (_, __) {
        debugPrint('===> [Microphone] onError');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                text,
              ),
            ),
            ElevatedButton(
                onPressed: _startListen, child: const Text("Start 🎙"))
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    listener?.cancel();
    super.dispose();
  }
}
