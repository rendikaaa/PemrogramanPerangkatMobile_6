import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:rendika_apk/employee_model.dart';


class ApiService {
  static const String baseUrl = 'https://67345125a042ab85d1199e03.mockapi.io/karyawan/v2/karyawan';

  // Fetch all employees
  Future<List<Employee>> getEmployees() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      List data = json.decode(response.body);
      return data.map((json) => Employee.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load employees');
    }
  }

  // Add a new employee
  Future<void> createEmployee(Employee employee) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(employee.toJson()),
    );
    if (response.statusCode != 201) {
      throw Exception('Failed to create employee');
    }
  }

  // Update an existing employee
  Future<void> updateEmployee(Employee employee) async {
    final response = await http.put(
      Uri.parse('$baseUrl/${employee.id}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(employee.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update employee');
    }
  }

  // Delete an employee
  Future<void> deleteEmployee(String id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));
    if (response.statusCode != 200) {
      throw Exception('Failed to delete employee');
    }
  }
}
