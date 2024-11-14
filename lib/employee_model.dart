class Employee {
  final String id;
  final String nama;
  final String tanggalLahir;
  final String alamat;
  final String foto;

  Employee({required this.id, required this.nama, required this.tanggalLahir, required this.alamat, required this.foto});

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      id: json['id'],
      nama: json['nama'],
      tanggalLahir: json['tanggalLahir'],
      alamat: json['alamat'],
      foto: json['foto'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nama': nama,
      'tanggalLahir': tanggalLahir,
      'alamat': alamat,
      'foto': foto,
    };
  }
}
