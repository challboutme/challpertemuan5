// pertemuan10.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

/// ==================== KONFIGURASI API ====================
/// Ganti sesuai alamat server XAMPP kamu.
/// - Jika dijalankan di Android Emulator, "localhost" komputer = "10.0.2.2"
/// - Jika dijalankan di HP fisik / device nyata, pakai IP komputer kamu,
///   misalnya "192.168.1.5", dan pastikan HP & komputer 1 jaringan WiFi.
/// - Jika dijalankan di Chrome/Web atau Windows Desktop, "localhost" bisa dipakai langsung.
class ApiConfig {
  static const String baseUrl = "http://localhost/api";
}

/// ==================== MODEL ====================
class Mahasiswa {
  int? id;
  String nim;
  String nama;
  String jurusan;

  Mahasiswa({
    this.id,
    required this.nim,
    required this.nama,
    required this.jurusan,
  });

  Map<String, dynamic> toMap() {
    return {'id': id, 'nim': nim, 'nama': nama, 'jurusan': jurusan};
  }

  factory Mahasiswa.fromMap(Map<String, dynamic> map) {
    return Mahasiswa(
      id: map['id'] is String ? int.parse(map['id']) : map['id'],
      nim: map['nim'],
      nama: map['nama'],
      jurusan: map['jurusan'],
    );
  }
}

/// ==================== API HELPER ====================
class ApiHelper {
  static final ApiHelper instance = ApiHelper._internal();
  ApiHelper._internal();

  // READ (semua data)
  Future<List<Mahasiswa>> getAllMahasiswa() async {
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/get_mahasiswa.php'),
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      if (body['success'] == true) {
        final List list = body['data'];
        return list.map((item) => Mahasiswa.fromMap(item)).toList();
      }
    }
    throw Exception('Gagal mengambil data mahasiswa');
  }

  // CREATE
  Future<void> insertMahasiswa(Mahasiswa mhs) async {
    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}/tambah_mahasiswa.php'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(mhs.toMap()),
    );

    final body = jsonDecode(response.body);
    if (body['success'] != true) {
      throw Exception(body['message'] ?? 'Gagal menambah data');
    }
  }

  // UPDATE
  Future<void> updateMahasiswa(Mahasiswa mhs) async {
    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}/update_mahasiswa.php'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(mhs.toMap()),
    );

    final body = jsonDecode(response.body);
    if (body['success'] != true) {
      throw Exception(body['message'] ?? 'Gagal memperbarui data');
    }
  }

  // DELETE
  Future<void> deleteMahasiswa(int id) async {
    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}/hapus_mahasiswa.php'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'id': id}),
    );

    final body = jsonDecode(response.body);
    if (body['success'] != true) {
      throw Exception(body['message'] ?? 'Gagal menghapus data');
    }
  }
}

/// ==================== UI ====================
class Pertemuan10 extends StatefulWidget {
  const Pertemuan10({super.key});

  @override
  State<Pertemuan10> createState() => _Pertemuan10State();
}

class _Pertemuan10State extends State<Pertemuan10> {
  static const Color maroon = Color(0xFF800020);
  static const Color maroonLight = Color(0xFFA0324A);
  static const Color maroonBg = Color(0xFFFBEFF1);

  final ApiHelper _apiHelper = ApiHelper.instance;
  final _formKey = GlobalKey<FormState>();

  final _nimController = TextEditingController();
  final _namaController = TextEditingController();
  final _jurusanController = TextEditingController();

  List<Mahasiswa> _daftarMahasiswa = [];
  int? _editingId;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _nimController.dispose();
    _namaController.dispose();
    _jurusanController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final data = await _apiHelper.getAllMahasiswa();
      setState(() {
        _daftarMahasiswa = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      _showSnackBar('Gagal memuat data: $e', Icons.error_outline);
    }
  }

  void _clearForm() {
    _nimController.clear();
    _namaController.clear();
    _jurusanController.clear();
    _editingId = null;
  }

  Future<void> _simpanData() async {
    if (!_formKey.currentState!.validate()) return;

    final mhs = Mahasiswa(
      id: _editingId,
      nim: _nimController.text.trim(),
      nama: _namaController.text.trim(),
      jurusan: _jurusanController.text.trim(),
    );

    try {
      if (_editingId == null) {
        await _apiHelper.insertMahasiswa(mhs);
        _showSnackBar('Data berhasil ditambahkan', Icons.check_circle_outline);
      } else {
        await _apiHelper.updateMahasiswa(mhs);
        _showSnackBar('Data berhasil diperbarui', Icons.edit_outlined);
      }

      _clearForm();
      if (mounted) Navigator.pop(context); // tutup bottom sheet
      await _loadData();
    } catch (e) {
      _showSnackBar('Gagal menyimpan data: $e', Icons.error_outline);
    }
  }

  Future<void> _hapusData(int id, String nama) async {
    final konfirmasi = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: Row(
          children: const [
            Icon(Icons.warning_amber_rounded, color: maroon),
            SizedBox(width: 8),
            Text('Konfirmasi Hapus'),
          ],
        ),
        content: Text('Apakah kamu yakin ingin menghapus data "$nama"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: maroon,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (konfirmasi == true) {
      try {
        await _apiHelper.deleteMahasiswa(id);
        _showSnackBar('Data berhasil dihapus', Icons.delete_outline);
        await _loadData();
      } catch (e) {
        _showSnackBar('Gagal menghapus data: $e', Icons.error_outline);
      }
    }
  }

  void _showSnackBar(String message, IconData icon) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(width: 10),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: maroon,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _bukaForm({Mahasiswa? mhs}) {
    if (mhs != null) {
      _editingId = mhs.id;
      _nimController.text = mhs.nim;
      _namaController.text = mhs.nama;
      _jurusanController.text = mhs.jurusan;
    } else {
      _clearForm();
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Icon(
                        _editingId == null
                            ? Icons.person_add_alt_1_rounded
                            : Icons.edit_note_rounded,
                        color: maroon,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _editingId == null
                            ? 'Tambah Mahasiswa'
                            : 'Edit Mahasiswa',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: maroon,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  _buildTextField(
                    controller: _nimController,
                    label: 'NIM',
                    icon: Icons.numbers_rounded,
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 14),
                  _buildTextField(
                    controller: _namaController,
                    label: 'Nama Lengkap',
                    icon: Icons.person_outline_rounded,
                  ),
                  const SizedBox(height: 14),
                  _buildTextField(
                    controller: _jurusanController,
                    label: 'Jurusan',
                    icon: Icons.school_outlined,
                  ),

                  const SizedBox(height: 24),

                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton.icon(
                      onPressed: _simpanData,
                      icon: const Icon(Icons.save_rounded),
                      label: Text(
                        _editingId == null ? 'Simpan' : 'Perbarui',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: maroon,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: maroonBg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: maroon),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: maroonLight.withOpacity(0.3)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: maroon, width: 2),
          ),
        ),
        validator: (value) =>
            value == null || value.trim().isEmpty ? '$label wajib diisi' : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: maroonBg,
      appBar: AppBar(
        title: const Text(
          'CRUD',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 4,
        backgroundColor: maroon,
        actions: [
          IconButton(
            onPressed: _loadData,
            icon: const Icon(Icons.refresh_rounded, color: Colors.white),
            tooltip: 'Muat ulang',
          ),
        ],
      ),
      body: Column(
        children: [
          _headerSection(),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator(color: maroon))
                : _daftarMahasiswa.isEmpty
                ? _buildEmptyState()
                : RefreshIndicator(
                    color: maroon,
                    onRefresh: _loadData,
                    child: ListView.separated(
                      padding: const EdgeInsets.fromLTRB(16, 4, 16, 90),
                      itemCount: _daftarMahasiswa.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final mhs = _daftarMahasiswa[index];
                        return _buildMahasiswaCard(mhs);
                      },
                    ),
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _bukaForm(),
        backgroundColor: maroon,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_rounded),
        label: const Text(
          'Tambah',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _headerSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Row(
        children: [
          Icon(Icons.storage_rounded, color: maroon, size: 26),
          const SizedBox(width: 8),
          const Text(
            'Data Mahasiswa',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: maroon,
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: maroon,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '${_daftarMahasiswa.length} data',
              style: const TextStyle(fontSize: 12, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.inbox_rounded,
            size: 72,
            color: maroonLight.withOpacity(0.4),
          ),
          const SizedBox(height: 12),
          Text(
            'Belum ada data mahasiswa',
            style: TextStyle(fontSize: 15, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 4),
          Text(
            'Tekan tombol + untuk menambahkan',
            style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }

  Widget _buildMahasiswaCard(Mahasiswa mhs) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      elevation: 3,
      shadowColor: maroon.withOpacity(0.15),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => _bukaForm(mhs: mhs),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [maroonLight, maroon],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.person_rounded,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      mhs.nama,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'NIM: ${mhs.nim}',
                      style: TextStyle(
                        fontSize: 12.5,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: maroonBg,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        mhs.jurusan,
                        style: const TextStyle(fontSize: 11, color: maroon),
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  IconButton(
                    onPressed: () => _bukaForm(mhs: mhs),
                    icon: const Icon(
                      Icons.edit_outlined,
                      color: maroon,
                      size: 20,
                    ),
                    tooltip: 'Edit',
                    constraints: const BoxConstraints(),
                    padding: const EdgeInsets.all(4),
                  ),
                  const SizedBox(height: 6),
                  IconButton(
                    onPressed: () => _hapusData(mhs.id!, mhs.nama),
                    icon: const Icon(
                      Icons.delete_outline_rounded,
                      color: Colors.red,
                      size: 20,
                    ),
                    tooltip: 'Hapus',
                    constraints: const BoxConstraints(),
                    padding: const EdgeInsets.all(4),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
