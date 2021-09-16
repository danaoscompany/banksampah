import 'package:flutter/material.dart';
import 'package:banksampah/global.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() => runApp(Template());

class Template extends StatefulWidget {
  @override
  TemplateState createState() => TemplateState();
}

class TemplateState extends State<Template> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var string = AppLocalizations.of(context);
    return Container(color: Colors.white);
  }
}
