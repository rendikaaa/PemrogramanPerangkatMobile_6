import 'package:flutter/material.dart';
import 'employee_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Employee App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: EmployeePage(),
    );
  }
}
