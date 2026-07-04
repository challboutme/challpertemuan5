import 'package:flutter/material.dart';

class ProdukDetail extends StatefulWidget {
  final String kodeProduk;
  final String namaProduk;
  final int harga;

  const ProdukDetail({
    super.key,
    required this.kodeProduk,
    required this.namaProduk,
    required this.harga,
  });

  @override
  _ProdukDetailState createState() => _ProdukDetailState();
}

class _ProdukDetailState extends State<ProdukDetail> {
  static const Color maroon = Color(0xFF800020);
  static const Color maroonLight = Color(0xFFA0324A);
  static const Color maroonBg = Color(0xFFFBEFF1);

  String _formatHarga(int harga) {
    final str = harga.toString();
    final buffer = StringBuffer();
    for (int i = 0; i < str.length; i++) {
      final posFromEnd = str.length - i;
      buffer.write(str[i]);
      if (posFromEnd > 1 && posFromEnd % 3 == 1) {
        buffer.write('.');
      }
    }
    return 'Rp $buffer';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: maroonBg,
      appBar: AppBar(
        title: const Text(
          'Detail Produk',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 4,
        backgroundColor: maroon,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Header dengan ikon produk
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 32),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [maroonLight, maroon],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: maroon.withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.inventory_2_rounded,
                      size: 48,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    widget.namaProduk.isEmpty ? '-' : widget.namaProduk,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      widget.kodeProduk.isEmpty ? '-' : widget.kodeProduk,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Card informasi detail
            Card(
              elevation: 8,
              shadowColor: maroon.withOpacity(0.2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 4,
                          height: 22,
                          decoration: BoxDecoration(
                            color: maroon,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Icon(
                          Icons.info_outline_rounded,
                          size: 20,
                          color: maroon,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Informasi Produk',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade800,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    _infoTile(
                      icon: Icons.qr_code_rounded,
                      label: 'Kode Produk',
                      value: widget.kodeProduk.isEmpty
                          ? '-'
                          : widget.kodeProduk,
                    ),
                    const SizedBox(height: 14),
                    _infoTile(
                      icon: Icons.shopping_bag_outlined,
                      label: 'Nama Produk',
                      value: widget.namaProduk.isEmpty
                          ? '-'
                          : widget.namaProduk,
                    ),
                    const SizedBox(height: 14),
                    _infoTile(
                      icon: Icons.attach_money_rounded,
                      label: 'Harga',
                      value: _formatHarga(widget.harga),
                      valueColor: maroon,
                      valueBold: true,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              height: 48,
              child: OutlinedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back_rounded, color: maroon),
                label: const Text(
                  'Kembali',
                  style: TextStyle(
                    color: maroon,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: maroon, width: 1.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoTile({
    required IconData icon,
    required String label,
    required String value,
    Color valueColor = Colors.black87,
    bool valueBold = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: maroonBg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: maroon, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: valueBold ? FontWeight.bold : FontWeight.w500,
                    color: valueColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
