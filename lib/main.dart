import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:pertemuan_listview/pertemuan/pertemuan1.dart';
import 'package:pertemuan_listview/pertemuan/pertemuan2.dart';
import 'package:pertemuan_listview/pertemuan/pertemuan3.dart';
import 'package:pertemuan_listview/pertemuan/pertemuan4.dart';
import 'package:pertemuan_listview/pertemuan/pertemuan5.dart';
import 'package:pertemuan_listview/pertemuan/pertemuan6.dart';
import 'package:pertemuan_listview/pertemuan/pertemuan7.dart';
import 'package:pertemuan_listview/pertemuan/pertemuan8.dart';
import 'package:pertemuan_listview/pertemuan/pertemuan9.dart';
import 'package:pertemuan_listview/pertemuan/pertemuan10.dart';
import 'package:pertemuan_listview/firebase_options.dart';
import 'package:pertemuan_listview/auth/auth_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Authentication',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: AuthPage(),
    );
  }
}

// Dashboard "Aplikasi Ujian Tengah Semester" — ditampilkan SETELAH login berhasil.
// Ini dipanggil dari login_page.dart / register_page.dart, bukan langsung dari MyApp,
// karena MaterialApp hanya boleh ada satu (di MyApp), widget lain cukup Scaffold biasa.
class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int currentIndex = 0;

  final Color primaryColor = Color(0xFF800020); // Maroon
  final Color secondaryColor = Color(0xFFB22222); // Firebrick
  final Color backgroundColor = Color(0xFFF5EDED);

  final List<Map<String, dynamic>> menuItems = [
    {
      "title": "Pertemuan 1",
      "icon": Icons.auto_stories,
      "page": HelloWorldPage(),
    },
    {"title": "Pertemuan 2", "icon": Icons.shopping_cart, "page": Produkform()},
    {
      "title": "Pertemuan 3",
      "icon": Icons.notifications_active,
      "page": ButtonPage(),
    },
    {
      "title": "Pertemuan 4",
      "icon": Icons.notifications_active,
      "page": Toast_Alert(),
    },
    {"title": "Pertemuan 5", "icon": Icons.list_alt, "page": ListviewPage()},
    {"title": "Pertemuan 6", "icon": Icons.check_box, "page": CheckboxPage()},
    {
      "title": "Pertemuan 7",
      "icon": Icons.radio_button_checked,
      "page": RadiobuttonPage(),
    },
    {
      "title": "Pertemuan 8",
      "icon": Icons.radio_button_checked,
      "page": Pert8(),
    },
    {
      "title": "Pertemuan 9",
      "icon": Icons.radio_button_checked,
      "page": Pert9(),
    },
    {
      "title": "Aplikasi CRUD",
      "icon": Icons.radio_button_checked,
      "page": Pertemuan10(),
    },
  ];

  @override
  Widget build(BuildContext context) {
    List<Widget> pages = [
      // HOME PAGE
      Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [primaryColor, secondaryColor],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.military_tech_outlined,
                color: Colors.white,
                size: 100,
              ),
              SizedBox(height: 20),
              Text(
                "Selamat Datang",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                "Aplikasi Ujian Akhir Semester",
                style: TextStyle(color: Colors.white70, fontSize: 18),
              ),
            ],
          ),
        ),
      ),

      // PROFILE PAGE
      Container(
        color: backgroundColor,
        child: Center(
          child: Card(
            elevation: 10,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
            child: Padding(
              padding: EdgeInsets.all(25),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    radius: 65,
                    backgroundImage: AssetImage("assets/CHALL.jpg"),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Fikri Haichal",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                  Divider(thickness: 1.5, color: secondaryColor),
                  SizedBox(height: 10),
                  ListTile(
                    leading: Icon(Icons.badge, color: primaryColor),
                    title: Text("241011700472"),
                    subtitle: Text("NIM"),
                  ),
                  ListTile(
                    leading: Icon(Icons.class_, color: primaryColor),
                    title: Text("04SIFE007"),
                    subtitle: Text("Kelas"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),

      // LIST PAGE
      Container(
        color: backgroundColor,
        child: ListView.builder(
          padding: EdgeInsets.all(12),
          itemCount: menuItems.length,
          itemBuilder: (context, index) {
            return Container(
              margin: EdgeInsets.only(bottom: 12),
              child: Card(
                elevation: 6,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: ListTile(
                  contentPadding: EdgeInsets.all(15),
                  leading: CircleAvatar(
                    backgroundColor: primaryColor,
                    child: Icon(menuItems[index]["icon"], color: Colors.white),
                  ),
                  title: Text(
                    menuItems[index]["title"],
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text("Klik untuk membuka halaman"),
                  trailing: Icon(Icons.arrow_forward_ios, color: primaryColor),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => menuItems[index]["page"],
                      ),
                    );
                  },
                ),
              ),
            );
          },
        ),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Aplikasi Ujian Akhir Semester",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [primaryColor, secondaryColor]),
          ),
        ),
        // Tombol logout kembali ke AuthPage
        actions: [
          IconButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              if (context.mounted) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => AuthPage()),
                );
              }
            },
            icon: const Icon(Icons.logout, color: Colors.white),
          ),
        ],
      ),
      body: AnimatedSwitcher(
        duration: Duration(milliseconds: 400),
        child: pages[currentIndex],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(blurRadius: 10, color: Colors.black12)],
        ),
        child: SalomonBottomBar(
          currentIndex: currentIndex,
          onTap: (i) => setState(() => currentIndex = i),
          items: [
            SalomonBottomBarItem(
              icon: Icon(Icons.home),
              title: Text("Home"),
              selectedColor: primaryColor,
            ),
            SalomonBottomBarItem(
              icon: Icon(Icons.person),
              title: Text("Profile"),
              selectedColor: Colors.red,
            ),
            SalomonBottomBarItem(
              icon: Icon(Icons.list),
              title: Text("List"),
              selectedColor: Colors.deepOrange,
            ),
          ],
        ),
      ),
    );
  }
}
