import 'package:flutter/material.dart';
import 'package:banksampah/global.dart';
import 'package:banksampah/components/screen_arguments.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() => runApp(Test());

class Test extends StatefulWidget {
  @override
  TestState createState() => TestState();
}

class TestState extends State<Test> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var string = AppLocalizations.of(context);
    final args = ModalRoute.of(context)!.settings.arguments as ScreenArguments;
    print("ARGUMENTS:");
    print(args);
    return Text("This is Test page.");
  }
}
