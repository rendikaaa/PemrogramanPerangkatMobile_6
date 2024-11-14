import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rendika_apk/api_service.dart';
import 'employee_model.dart';

class EmployeePage extends StatefulWidget {
  @override
  _EmployeePageState createState() => _EmployeePageState();
}

class _EmployeePageState extends State<EmployeePage> {
  final ApiService apiService = ApiService();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController birthdateController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  File? _image;
  final picker = ImagePicker();
  bool _isFormVisible = false;
  String? _currentEmployeeId;

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  Future<void> _addOrUpdateEmployee(String? id) async {
    String photoUrl = _image != null ? _image!.path : '';

    final employee = Employee(
      id: id ?? '',
      nama: nameController.text,
      tanggalLahir: birthdateController.text,
      alamat: addressController.text,
      foto: photoUrl,
    );

    if (id == null) {
      await apiService.createEmployee(employee);
    } else {
      await apiService.updateEmployee(employee);
    }
    _refreshPage();
    _clearFields();
  }

  void _clearFields() {
    nameController.clear();
    birthdateController.clear();
    addressController.clear();
    _image = null;
    _currentEmployeeId = null;
  }

  void _refreshPage() {
    setState(() {});
  }

  Future<void> _deleteEmployee(String id) async {
    await apiService.deleteEmployee(id);
    _refreshPage();
  }

  void _editEmployee(Employee employee) {
    setState(() {
      nameController.text = employee.nama;
      birthdateController.text = employee.tanggalLahir;
      addressController.text = employee.alamat;
      _image = File(employee.foto);
      _currentEmployeeId = employee.id;
      _isFormVisible = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar Karyawan'),
      ),
      body: Column(
        children: [
          if (_isFormVisible)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  TextField(controller: nameController, decoration: InputDecoration(labelText: 'Nama')),
                  TextField(controller: birthdateController, decoration: InputDecoration(labelText: 'Tanggal Lahir')),
                  TextField(controller: addressController, decoration: InputDecoration(labelText: 'Alamat')),
                  SizedBox(height: 10),
                  _image == null
                      ? Text('No image selected.')
                      : Image.file(_image!, height: 100, width: 100),
                  TextButton.icon(icon: Icon(Icons.image), label: Text("Pilih Gambar"), onPressed: _pickImage),
                  ElevatedButton(
                    onPressed: () => _addOrUpdateEmployee(_currentEmployeeId),
                    child: Text(_currentEmployeeId == null ? 'Tambahkan Karyawan' : 'Perbarui Karyawan'),
                  ),
                ],
              ),
            ),
          if (!_isFormVisible)
            Expanded(
              child: FutureBuilder<List<Employee>>(
                future: apiService.getEmployees(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
                  final employeeList = snapshot.data!;
                  return ListView.builder(
                    itemCount: employeeList.length,
                    itemBuilder: (context, index) {
                      final employee = employeeList[index];
                      return ListTile(
                        leading: employee.foto.isNotEmpty
                            ? Image.file(File(employee.foto), height: 50, width: 50, fit: BoxFit.cover)
                            : Icon(Icons.image, size: 50),
                        title: Text(employee.nama),
                        subtitle: Text(employee.tanggalLahir),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(icon: Icon(Icons.edit), onPressed: () => _editEmployee(employee)),
                            IconButton(icon: Icon(Icons.delete), onPressed: () => _deleteEmployee(employee.id)),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _isFormVisible = !_isFormVisible;
            if (!_isFormVisible) _clearFields();
          });
        },
        child: Icon(_isFormVisible ? Icons.close : Icons.add),
      ),
    );
  }
}
