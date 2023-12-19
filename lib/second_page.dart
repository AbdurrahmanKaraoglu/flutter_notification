import 'package:flutter/material.dart';
import 'package:flutter_call_notification_test/service/notification_service.dart';

class SecondPage extends StatefulWidget {
  const SecondPage(
    this.payload, {
    Key? key,
    this.notiID,
    this.isRoute,
  }) : super(key: key);

  static const String routeName = '/secondPage';

  final String? payload;
  final int? notiID;
  final bool? isRoute;

  @override
  State<StatefulWidget> createState() => SecondPageState();
}

class SecondPageState extends State<SecondPage> {
  String? _payload;

  @override
  void initState() {
    super.initState();
    debugPrint('SecondPage initState isRoute: ${widget.isRoute!}');
    debugPrint('SecondPage initState notiID: ${widget.notiID!}');

    notiCancel();
    _payload = widget.payload;
  }

  Future<void> notiCancel() async {
    if (widget.notiID == null) {
      return;
    }
    await flutterLocalNotificationsPlugin.cancel(widget.notiID!);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Second Screen'),
        ),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text('payload ${_payload ?? ''}'),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Go back!'),
              ),
            ],
          ),
        ),
      );
}
