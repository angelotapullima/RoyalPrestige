import 'package:flutter/material.dart';
import 'package:royal_prestige/src/utils/calendar.dart';

class AgendaPage extends StatelessWidget {
  const AgendaPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomCalendar(),
    );
  }
}
