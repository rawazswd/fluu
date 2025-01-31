



import 'package:hhh/main.dart'; // Ensure this path is correct.
import 'package:provider/provider.dart'; // Add this import

import 'package:flutter/services.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:intl/intl.dart';

void main() {

  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(), // تەنظیمیەکەی ThemeProvider ڕوونی بکەوە بەرەوە
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context); // بەدەستهێنانی ThemeProvider بۆ ئەم فریمەوە

    return MaterialApp(
      title: 'City Assistant', // ناوی بەرنامە
      debugShowCheckedModeBanner: false, // پەیامی دیباگ نەخشە بکەوە
      theme: ThemeData.light(), // تێما کۆمەڵایەتی ڕوونی
      darkTheme: ThemeData.dark(), // تێما کۆمەڵایەتی تاریکی
      themeMode: themeProvider.themeMode, // بەکاربردنی تێمەكەی تایبەتی بە گەرمی
      home: LoginPage(), // بەرواری بەکارهێنانی پەڕەی داخڵکردن
    );
  }
}

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light; // تێمە بە شێوەی ڕوونی دامەزراندراوە

  ThemeMode get themeMode => _themeMode; // ڕووکاری گەڕاندنەوەی تێمە

  void toggleTheme(bool isDarkMode) {
    _themeMode = isDarkMode ? ThemeMode.dark : ThemeMode.light; // هەڵگرتنی تێمە کە بە شێوەی تاریک یان ڕوونی
    notifyListeners(); // ئاگادارییەکە بەوەیە کە ڕووکاری نوێی تێمە هەیە و وەیە
  }
}
// پەڕەی LoginPage تایبەتی بەرەوە بۆ پاراستنی وضعیتەکانی داخڵکردن
class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isLoggedIn = false; // پاراستنەکەی ئەگەر بەکارهێنەر داخڵە یان نا

  final TextEditingController usernameController = TextEditingController(); // فیلدی ناوی بەکارهێنەر
  final TextEditingController passwordController = TextEditingController(); // فیلدی وشەی نهێنی

  ThemeMode _themeMode = ThemeMode.light; // تێم بە شێوەی ڕوونی دامەزراندراوە

  // فەرمی ڕووکاری تێمە کە بە شێوەی تاریک یان ڕوونی دەگرێت
  void toggleTheme(bool isDarkMode) {
    setState(() {
      _themeMode = isDarkMode ? ThemeMode.dark : ThemeMode.light;
    });
  }
 // بۆ گۆرینی رەنگی لۆگین باکگراوند
  @override
  Widget build(BuildContext context) {
    return isLoggedIn
        ? HomePage() // ئەگەر بەکارهێنەر داخڵ بووە، پەڕەی خانە نیشان بدە
        : Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.grey, Colors.black54], // تێمەی وەرزی تاریکی
          ),
        ),
        child: _page(), // پەڕەی داخڵکردن نمایش دەدات
      ),
    );
  }

  // پەڕەیەکی تایبەتی بەرەوەی مەحتوای ناوەندیەکە
  Widget _page() {
    return Padding(
      padding: const EdgeInsets.all(35.0),
      child: Center(
        child: Column(
          children: <Widget>[
            const SizedBox(height: 150), // فاصلەی زیادکردن
            _image(), // نیشاندانی وێنە
            const SizedBox(height: 50),
            _inputField("ناوی بەکارهێنەر", usernameController), // فیلدی ناو
            const SizedBox(height: 20),
            _inputField("وشەی نهێنی", passwordController, isPassword: true), // فیلدی وشەی نهێنی
            const SizedBox(height: 50),
            _loginBtn(), // تەنیشت کردنی تەنظیمی تۆماری تایبەتی
            const SizedBox(height: 50),
            _extraText(), // تێبینی تایبەتی بەرەوە
          ],
        ),
      ),
    );
  }

  // وێنەی تایبەتی لە پەڕەیەکە
  Widget _image() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white, width: 3),
        shape: BoxShape.circle,
      ),
      child: ClipOval(
        child: Image.asset(
          'assets/image/jan.png', // ڕێگاکەی وێنە دابنێ
          width: 200,
          height: 200,
          fit: BoxFit.cover, // ئیشی چاککردنی وێنە
        ),
      ),
    );
  }

  // فیلدی تایبەتی نووسین بۆ ناو و وشەی نهێنی
  Widget _inputField(String hintText, TextEditingController controller,
      {bool isPassword = false}) {
    var border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(18),
      borderSide: const BorderSide(color: Colors.white),
    );

    return TextField(
      style: const TextStyle(color: Colors.white), // فۆنتەکە ڕوونیە
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.white),
        enabledBorder: border,
        focusedBorder: border,
      ),
      obscureText: isPassword, // ئیشی پێوەندیدانی وشەی نهێنی
    );
  }

  // کرتە کردن بۆ داخڵکردن
  Widget _loginBtn() {
    return ElevatedButton(
      onPressed: () {
        String username = usernameController.text;
        String password = passwordController.text;

        // هەڵگرتنی ئەوەی ناو و وشەی نهێنی هەیە یان نە
        if ((username == 'rawaz mustafa' && password == '12345') ||
            (username == 'Lara ismail' && password == 'Lara123') ||
            (username == 'Aland alan' && password == 'Aland3322') ||
            (username == 'Rakan  ari' && password == 'Rakan4')) {
          setState(() {
            isLoggedIn = true; // کەس بە شێوەیەکی تایبەتی داخڵ دەکەوێت
          });
        } else {
          // نیشاندانی پەیامی هەڵەیەک
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('ناوی بەکارهێنەر یان وشەی نهێنی هەڵەیە')),// پەیامی هەڵە
          );
        }
      },
      child: const SizedBox(
        width: double.infinity,
        child: Text(
          "چوونە ژوورەوە", // ناوی پەیوەندیداری
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20, color: Colors.black),
        ),
      ),
      style: ElevatedButton.styleFrom(
        shape: const StadiumBorder(),
        backgroundColor: Colors.grey,
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
    );
  }

  // تێبینی تایبەتی بەرەوە
  Widget _extraText() {
    return const Text(
      "تکایە بەچی ناوێک و وشەی نهێنیەک تۆمار بوویت ئەوە بەکاربێنە",
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Colors.white,
        fontSize: 16,
      ),
    );
  }
}

// پەڕەی تایبەتی HomePage بۆ نیشاندانی هەریمەکان و زانیاریەکان
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0; // پاراستنەکەی کە کەیەک لە هەریمەکانە بەرەوە دەست کردووە

  final List<Widget> _pages = [ // لیستی پەڕەکان بەرەوە
    SingleChildScrollView(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start, // تایبەتمەندی ردیفی پەڕەکان
          crossAxisAlignment: CrossAxisAlignment.center, // تایبەتمەندی کۆنترۆڵی نیشاندانی پەڕەکان
          children: [
            const SizedBox(height: 20), // فاصلەی زیادکردن
            Image.asset('assets/image/mamosa.jpg', width: double.infinity, height: 250, fit: BoxFit.cover), // وێنەی تایبەتی
            const SizedBox(height: 16),
            const Text(
              'بە ناوی خوای گەورە', // ناوی پڕۆژەیەک
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'لە بەرواری ( ٢٤/٢/٢٠١٥ ) پڕۆژەی شاری مامۆستایان کراوەتەوە کە یەکێک لە ھەرە پڕۆژە جوانەکانی شارەکەمان کە تێیدا چەندن خزمەت گوزاری پێشکەش کردووە بە ڕوی ھاوڵاتیان دا',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16  ),
              ),
            ),
            const SizedBox(height: 16),
            Image.asset('assets/image/mzgawt.jpg', width: double.infinity, height: 250, fit: BoxFit.cover), // وێنەی تایبەتی
            const SizedBox(height: 16),
            const Text(
              'کە یەکێک لەوانە مزگەوتە جوانەکەی (شێخ کەریم باوە شێخی چنارە) یە ',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Image.asset('assets/image/shool.jpg', width: double.infinity, height: 250, fit: BoxFit.cover), // وێنەی تایبەتی
            const SizedBox(height: 16),
            const Text(
              'یەکێکی کەش لەو خزمەت گوزاریانە قوتابخانەی (جمال عبدول)  کە لە ٢٨/١/٢٠٢١ دا بەردی بناغەی دانراوە ئێستا لە خزمەتی خوێندکاران دایە ',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Image.asset('assets/image/yare.jpg', width: double.infinity, height: 250, fit: BoxFit.cover), // وێنەی تایبەتی
            const SizedBox(height: 16),
            const Text(
              'هەروەها لە ناو پرۆژەکەیا شاری یاری بۆ منداڵان دابین کراوە',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Image.asset('assets/image/taxi.jpg', width: double.infinity, height: 250, fit: BoxFit.cover), // وێنەی تایبەتی
            const SizedBox(height: 16),
            const Text(
              'هەروەها تەکسیش بۆ دانیشتوانی پرۆژەکە دابین کراوە ',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    ),
    ServicePage(), // پەڕەی خزمەتی
    ShopPage(), // پەڕەی بازاڕ
    Emergensy(), // پەڕەی فریاکەوتن
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("City Assistant")), // سرپەڕەی بەرنامە
      drawer: DrawerScreen(), // پەڕەی منو
      body: _pages[_selectedIndex], // نیشاندانی پەڕەی هەریمەکان
      bottomNavigationBar: Container(
        color: Colors.grey, // ڕووی پەڕەی فوتر
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5), // فاصلەی تەنظیمی فوتر
          child: GNav(
            backgroundColor: Colors.grey, // ڕەنگی پەڕەی فوتر
            color: Colors.white54, // ڕەنگی فۆنتەکان
            activeColor: Colors.black, // ڕەنگی فۆنتەکان ئەگەر پەیوەندیدە
            tabBackgroundColor: Colors.red.shade800.withOpacity(0.54), // ڕەنگی پەیوەندیداری بە شێوەی چەندین رەنگ
            gap: 8, // فاصلەی تەنظیمی لە نێوان هەریمەکان
            padding: const EdgeInsets.all(16), // فاصلەی تایبەتی تەنظیم
            onTabChange: (index) { // ڕووکاری گۆڕینی پەڕە
              setState(() {
                _selectedIndex = index; // گۆڕینی هەریمە تایبەتی
              });
            },
            tabs: const [
              GButton(icon: Icons.home, text: 'سەرەکی'), // هەریمەی سەرەکی
              GButton(icon: Icons.support_agent, text: 'خزمەتگوزاری'), // هەریمەی خزمەتگوزاری
              GButton(icon: Icons.shop, text: 'بازاڕ'), // هەریمەی بازاڕ
              GButton(icon: Icons.emergency, text: 'فریاکەوتن'), // هەریمەی فریاکەوتن
            ],
          ),
        ),
      ),
    );
  }
}



//


// فۆنکشنەکەی NewRow کە دروست دەکات ڕووتەکان
class NewRow extends StatelessWidget {
  // ڕووتەکان پارامەترەکان
  final String text; // نوسی تێکسەتی
  final IconData icon; // ئایکۆنی تێکسەتی
  final VoidCallback onTap; // ڕووتەیەکی تێکەڵ کردنی نیشانی
  final bool showDarkModeToggle; // گۆڕینی ڕووتەی حاڵەتی تاریک

  // ئەم فۆنکشنە پارامەترەکانیش تایبەتمەندی تایبەتی تایبەتی دارە
  const NewRow({
    required this.text,
    required this.icon,
    required this.onTap,
    this.showDarkModeToggle = false,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // بەکارهێنانی ThemeProvider بۆ ئەوەی چەندێکی شێوە تایبەتی بیەینین
    final themeProvider = Provider.of<ThemeProvider>(context);

    // بەکارهێنانی GestureDetector بۆ ئاگاداری و تێکەڵکردن لە تەنیشتێکەکان
    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // ئایکۆنەکە
              Icon(icon, color: Colors.white, size: 30),
              const SizedBox(width: 10),
              // تێکستی نووسراو
              Text(
                text,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          // ڕووتەیەکی تایبەتی بۆ حاڵەتی تاریک
          if (showDarkModeToggle)
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: ListTile(
                leading: const Icon(Icons.nightlight_round, ),
                title: const Text('حاڵەتی تاریک'),
                trailing: Switch(
                  value: themeProvider.themeMode == ThemeMode.dark,
                  onChanged: (value) {
                    themeProvider.toggleTheme(value); // گۆڕینی شێوە
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// فۆنکشنەکەی DrawerScreen کە دیزاینی مێنۆی پەیوەندیدارە

class DrawerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context); // Access the existing provider

    return Container(
      // رەنگی دراوەر سکرریین
      color: Colors.blueGrey,
      child: Padding(
        padding: const EdgeInsets.only(top: 50, left: 40, bottom: 70),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // User Info Section
            Row(
              children: <Widget>[
                CircleAvatar(
                  radius: 30,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: Image.asset(
                      'assets/image/jan.png', // Verify the file exists in assets
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.error, color: Colors.red),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                const Text(
                  'City Assistant ',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
            // Options Section
            Expanded(
              child: ListView(
                children: <Widget>[
                  NewRow(
                    text: 'فرۆشتن',
                    icon: Icons.sell,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SellPage()),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  NewRow(
                    text: 'تاکسی',
                    icon: Icons.local_taxi,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => TaxiPage()),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  NewRow(
                    text: 'وەرزش',
                    icon: Icons.sports_gymnastics,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => GymPage()),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  NewRow(
                    text: 'قوتابخانە',
                    icon: Icons.school,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ShoolPage()),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  NewRow(
                    text: 'دەربارە',
                    icon: Icons.info,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AboutPage()),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  Material(
                    color: Colors.transparent, // Keep background consistent with your theme
                    child: ListTile(
                      leading:
                      const Icon(Icons.nightlight_round, color: Colors.grey),
                      title: const Text('حاڵەتی تاریک'),
                      trailing: Switch(
                        value: themeProvider.themeMode == ThemeMode.dark,
                        onChanged: (value) {
                          themeProvider.toggleTheme(value);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}



// پۆلی SellPage دروست دەکات کە ڕووکاری فرۆشتن پیشان دەدات
class SellPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // دەستپێک بە هێڵی سەرەوەی ئەپ (AppBar)
      appBar: AppBar(
        backgroundColor: Colors.red, // ڕەنگی سوور بۆ AppBar
        title: Text("لاپەڕەی فرۆشتن"), // ناونیشانی لاپەڕەکە
      ),
      // بەشێکی ناوەوەی لاپەڕەکە (Body)
      body: Padding(
        padding: const EdgeInsets.all(16.0), // هێڵدان بە ناوەوە
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center, // هاوپێچکردنی ناوەوە بە ناوەند
          children: [
            SizedBox(height: 300), // بەشێکی بەتاڵ بۆ فاصلە
            Text(
              "لە داهاتوودا دەکەوێتە کار", // دەقێکی پیشاندەردەوە
              style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold), // ڕووشتی دەقەکە
            )
          ],
        ),
      ),
    );
  }
}

// پۆلی GymPage دروست دەکات بۆ پیشاندانی بەرنامەی وەرزش
class GymPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // دەستپێک بە AppBar کە ناونیشان دەبەخشی لاپەڕەکە
      appBar: AppBar(
        backgroundColor: Colors.red, // ڕەنگی سوور
        title: Text("ڵاپەڕەی وەرزش"), // ناونیشانی لاپەڕەکە
      ),
      // بەشە ناوەوەی لاپەڕەکە
      body: Padding(
        padding: EdgeInsets.all(16.0), // هێڵدان بە ناوەوە
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // هاوپێچکردنی ناوەوە بە لای چەپ
          children: [
            // ڕێکخستن و پیشاندانی هەر یەک لە بەرنامەکانی وەرزش
            _buildBox(
              title: 'Core', // ناونیشان
              subtitle: '8 Exercises 3 Mins', // زانیاری دەربارەی ڕاوێژەکان
              imagePath: 'assets/image/core.png', // وێنەی پەیوەندیدار
            ),
            SizedBox(height: 16), // فاصلەی نیوان بنەماکان
            _buildBox(
              title: 'Bridges',
              subtitle: '6 Exercises 5 Mins',
              imagePath: 'assets/image/Bridges.png',
            ),
            SizedBox(height: 16),
            _buildBox(
              title: 'Squat',
              subtitle: '10 Exercises 7 Mins',
              imagePath: 'assets/image/squat.png',
            ),
            SizedBox(height: 16),
            _buildBox(
              title: 'Donkey Kik',
              subtitle: '12 Exercises 10 Mins',
              imagePath: 'assets/image/donkey.png',
            ),
            SizedBox(height: 16),
            _buildBox(
              title: 'Dead Lift',
              subtitle: '5 Exercises 4 Mins',
              imagePath: 'assets/image/deadlift.png',
            ),
          ],
        ),
      ),
    );
  }

  // فۆنکشنی _buildBox کە هەر یەک لە بەرنامەکانی وەرزش دروست دەکات
  Widget _buildBox({
    required String title, // ناونیشانی بەرنامەکە
    required String subtitle, // زانیاری زیادە
    required String imagePath, // ڕێچکەی وێنەکە
  }) {
    return Container(
      padding: EdgeInsets.all(16.0), // هێڵدان بە ناوەوە
      decoration: BoxDecoration(
        color: Colors.lightBlue[50], // ڕەنگی شینی تەواو بۆ پشتەوە
        borderRadius: BorderRadius.circular(12.0), // گۆشە چەماوە
      ),
      width: 300, // درێژی بۆکسی بەرنامەکە
      height: 100, // بەرزی بۆکسی بەرنامەکە
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, // پەیکهێنانی ناوەوە بە یەک
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start, // هاوپێچکردن لە لای چەپ
            mainAxisAlignment: MainAxisAlignment.center, // سنووردان بە ناوەند
            children: [
              Text(
                title, // ناونیشان
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8), // فاصلە نیوان ناونیشان و ناوەوە
              Text(
                subtitle, // زانیاری زیادەی بەرنامەکە
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[700], // ڕەنگی شەوی
                ),
              ),
            ],
          ),
          // وێنەی بەرنامەکە
          ClipRRect(
            borderRadius: BorderRadius.circular(8.0), // گۆشە چەماوە بۆ وێنەکە
            child: Image.asset(
              imagePath, // ڕێچکەی وێنەکە
              width: 80, // درێژی وێنە
              height: 80, // بەرزی وێنە
              fit: BoxFit.cover, // پڕکردنەوەی وێنە لە بۆکسەکەدا
            ),
          ),
        ],
      ),
    );
  }
}

class ShoolPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // شێوازی پاشبنەما ڕەنگی سپی
      appBar: AppBar(
        backgroundColor: Colors.brown, // ڕەنگی سەرپەڕە قاوەیی
        title: Text("ڵاپەڕەی قوتابخانە"), // ناوی سەرپەڕە
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0), // هێڵکانی ناوەڕۆک
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center, // سنووردان لە ناوەڕاست
          children: [
            SizedBox(height: 300), // بەشێکی بەتاڵ بۆ خاڵی‌کردنەوە
            Text(
              "لە داهاتوودا دەکەوێتە کار", // دەقی دەقی لە ناوەڕۆکدا
              style: TextStyle(
                fontSize: 35,
                fontWeight: FontWeight.bold, // قەڵەوکردنی دەق
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TaxiPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text("لاپەڕەی تاکسی"),
        backgroundColor: Colors.yellow,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Text(
              "ژمارە تاکسیەکان",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Card(
              child: ListTile(
                leading: Icon(Icons.local_taxi, color: Colors.yellowAccent),
                title: Text(
                  "CROLLA :   21 A 22334 :   ",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                trailing: Text("0772 6480101",
                    style:
                    TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
              ),
            ),
            Card(
              child: ListTile(
                leading: Icon(Icons.local_taxi, color: Colors.yellowAccent),
                title: Text(
                  "SANNY : 22 I 2275 :  : ",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                trailing: Text("07718909275",
                    style:
                    TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
              ),
            ),
            Card(
              child: ListTile(
                leading: Icon(Icons.local_taxi, color: Colors.yellowAccent),
                title: Text(
                  "SHKODA : 21 Y 11225 : ",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                trailing: Text("07709479003",
                    style:
                    TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
              ),
            ),
            Card(
              child: ListTile(
                leading: Icon(Icons.local_taxi, color: Colors.yellowAccent),
                title: Text(
                  "ALTIMA : 22 R 33446 : ",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                trailing: Text("07701411844",
                    style:
                    TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
              ),
            ),
            Card(
              child: ListTile(
                leading: Icon(Icons.local_taxi, color: Colors.yellowAccent),
                title: Text(
                  "TIDA : 22 A 39292 :  ",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                trailing: Text("07715444072",
                    style:
                    TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

}
class ShopPage extends StatefulWidget {
  @override
  _ShopPageState createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  List<Map<String, dynamic>> products = [
    {'name': 'کۆکا کۆلا', 'price': 1.2, 'image': 'assets/image/cola.png'},
    {'name': 'نووتێلا', 'price': 4.5, 'image': 'assets/image/notella.png'},
    {'name': 'شیر', 'price': 3, 'image': 'assets/image/milk.png'},
    {'name': 'کۆکا کۆلا', 'price': 1.5, 'image': 'assets/image/colla.png'},
    {'name': 'واف ئەپ', 'price': 0.95, 'image': 'assets/image/wafeup.png'},
    {'name': 'واف ئەپ', 'price': 1, 'image': 'assets/image/wafeupp.png'},
  ];

  List<Map<String, dynamic>> cart = [];
   // ئەمە نرخەکان کۆ دەکاتەوە
  double get totalPrice =>
      cart.fold(0.0, (sum, item) => sum + item['price']);
//ئادی ئەکات بۆ ناو جانتاکە
  void addToCart(Map<String, dynamic> product) {
    setState(() {
      cart.add(product);
    });
  }
  // بۆ سرینەوەی شتەکان

  void removeFromCart(Map<String, dynamic> product) {
    setState(() {
      cart.remove(product);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('لاپەڕەی فرۆشتن'),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_bag),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text('کارتەکە'),
                      content: cart.isEmpty
                          ? const Text('کارتەکەت بەتاڵە!')
                          : Column(
                        mainAxisSize: MainAxisSize.min,
                        children: cart.map((item) {
                          return ListTile(
                            leading: Image.asset(
                              item['image'],
                              width: 40,
                              height: 40,
                            ),
                            title: Text(item['name']),
                            subtitle: Text(
                                '\$${item['price'].toStringAsFixed(2)}'),
                            trailing: IconButton(
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                              onPressed: () => removeFromCart(item),
                            ),
                          );
                        }).toList(),
                      ),

                    ),
                  );
                },
              ),
              if (cart.isNotEmpty)
                Positioned(
                  right: 4,
                  top: 4,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      '${cart.length}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return ListTile(
                  leading: Image.asset(
                    product['image'],
                    width: 50,
                    height: 50,
                  ),
                  title: Text(product['name']),
                  subtitle: Text('\$${product['price'].toStringAsFixed(2)}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.shopping_cart),
                    onPressed: () => addToCart(product),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: Colors.grey.shade300)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'کۆی گشتی:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  '\$${totalPrice.toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AboutPage extends StatelessWidget { // دروستکردنی کلاسێکی `StatelessWidget` بۆ ڕووکاری زانیاری
  @override
  Widget build(BuildContext context) {
    return Scaffold( // `Scaffold` کۆنتەینەرێکە بۆ دروستکردنی ڕووکاری ئاسایی بۆ بەرنامە
      appBar: AppBar( // `AppBar` بۆ نیشاندانی سەردێڕی لاپەڕە
        title: const Text("ڵاپەڕەی زانیاری "), // تایتڵی لاپەڕە
        backgroundColor: Colors.red.shade800, // ڕەنگی پشتەوەی `AppBar`
      ),

      body: SingleChildScrollView( // `SingleChildScrollView` بۆ ڕێگادان بە سکڕۆڵکردن لە ناوەرۆکەکە
        padding: const EdgeInsets.all(16.0), // زیادکردنی بۆشایی ناوەوە بە هێندەی 16px
        child: Column( // `Column` بۆ ڕیزکردنەوەی ئەلیکمەنتەکان بۆ یەک یەک
          crossAxisAlignment: CrossAxisAlignment.start, // سەرەتا نیشاندان بە لای چەپ
          children: [

            const SizedBox(height: 24), // بۆ دانانی بۆشایی بە درێژی 24px

            Container( // `Container` بۆ پێشکەشکردنی بڵۆکێک بە شێوەی دیزاین کراو
              decoration: BoxDecoration( // `BoxDecoration` بۆ زیادکردنی شێواز
                color: Colors.red.shade50, // ڕەنگی پشتەوەی کۆنتەینەرەکە
                borderRadius: BorderRadius.circular(10), // گۆشە گردکردن بە 10px
              ),
              padding: const EdgeInsets.all(16), // بۆشایی ناوەوەی 16px

              child: const Text( // تێکستی ناو کۆنتەینەرەکە
                'ئەم بەرنامەیە بۆ کار ئاسانی هاوڵاتیان بەکاردێت کە شێوازی بەکارھێنانی بە شێوازێکی ئاسان بەکاردێت.\n\n'
                    '      بەرنامەکامان پێکهاتووە لە بەشی لۆگین، دوای ئەوە لاپەرەی سەرەکی و لاپەرەی خەدەمات، مارکێت، بەشی فریاکەوتن، فرۆشتن، وەرزش، قوتابخانە و بەشی زانیاری.کە بەکارهێنەر دەتوانێت ئاگای لەسەرجەم خزمەتگووزارییەکانی  نا پرۆژەکە  ئاگەدەار بێت کە بۆیان دابین کراوە',
                style: TextStyle(fontSize: 18, height: 1.5), // فۆنتی تێکست و بەرزی هێڵەکان
                textAlign: TextAlign.right, // نیشاندانی تێکست بە لای چەپ
              ),
            ),
          ],
        ),
      ),
    );
  }
}

 // دروستکردنی کلاسێک کە بڵۆکی تێکست پیشان دەدات بە خاڵ

class Emergensy extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200], // شێوازی پاشبەند کردنی ڕەنگی پاشبنەما

      body: Padding(
        padding: const EdgeInsets.all(16.0), // دانانی ڕوودا بۆ ناوەڕۆک
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // پێواندی لێکدان بە لای چەپ
          children: [
            SizedBox(height: 20), // بۆ دانانی بەشێکی بۆشایی نێوان ناوەڕۆک
            Text(
              "ژمارەکانی ئیمەرجەنسی", // ناونیشانی ناوەڕۆک
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),

            // کارتی پۆلیس
            Card(
              child: ListTile(
                leading: Icon(Icons.local_police, color: Colors.blue), // وێنەی پۆلیس
                title: Text("پۆلیس"), // ناوی دامەزراندن
                trailing: Text("104",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)), // ژمارەی پۆلیس
              ),
            ),

            // کارتی ئاگرکوژێنەوە
            Card(
              child: ListTile(
                leading: Icon(Icons.local_fire_department, color: Colors.red), // وێنەی ئاگرکوژێنەوە
                title: Text("ئاگرکوژێنەوە"),
                trailing: Text("115",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)), // ژمارەی ئاگرکوژێنەوە
              ),
            ),

            // کارتی نەخۆشخانە
            Card(
              child: ListTile(
                leading: Icon(Icons.local_hospital, color: Colors.green), // وێنەی نەخۆشخانە
                title: Text("نەخۆشخانە"),
                trailing: Text("122",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)), // ژمارەی نەخۆشخانە
              ),
            ),

            // کارتی خزمەتگوزاری
            Card(
              child: ListTile(
                leading: Icon(Icons.support_agent, color: Colors.blue), // وێنەی خزمەتگوزاری
                title: Text("خزمەتگوزاری"),
                trailing: Text("07700846824",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)), // ژمارەی خزمەتگوزاری
              ),
            ),

            SizedBox(height: 20), // بۆ دانانی فاصلە نێوان ناوەڕۆک

            // دەقی تێبینی بۆ بەکارهێنەر
            Center(
              child: Text(
                "لە کاتی حاڵەتی پێوەیست تەلەفەن بکەن بۆ ئەم ژمارانەی سەرەوە",
                style: TextStyle(fontSize: 15, fontStyle: FontStyle.italic ,fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ServicePage extends StatefulWidget {
  @override
  _ServicePageState createState() => _ServicePageState();
}

class _ServicePageState extends State<ServicePage> {
  late String _formattedDateTime; // بۆ هەڵگرتنی بەروار و کات بە فۆرماتی ڕوون
  late Timer _timer; // تایمەر بۆ نوێکردنەوەی کات بە شێوەی خوکار

  @override
  void initState() {
    super.initState();
    _updateDateTime(); // کاتی سەرەتا هەڵبگرە
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      _updateDateTime(); // هەر چرکەیەک نوێ بکەرەوە
    });
  }

  @override
  void dispose() {
    _timer.cancel(); // وشاندنەوەی تایمەر بۆ پیشگیری لە بڕزبوونی بیرگە
    super.dispose();
  }

  // فۆنکشنی نوێکردنەوەی کات
  void _updateDateTime() {
    setState(() {
      _formattedDateTime =
          DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
    });
  }

  // فۆنکشنی یارمەتیدەر بۆ دروستکردنی هێڵی ناونیشانەکان
  Widget _buildLabelRow(List<String> labels) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween, // بڵاوکردنەوەی ناونیشانەکان
      children: labels.map((label) {
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0), // دانانی بۆشایی لەنێوان ناونیشانەکان
            child: Container(
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey), // دانانی سنوور بۆ ناونیشانەکان
                borderRadius: BorderRadius.circular(5.0), // گۆشەگۆشکردن
              ),
              child: Text(
                label,
                textAlign: TextAlign.center, // ناونیشانەکان ببە لەناوەوە
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF808080), // ڕەنگی پاشبنەما

      appBar: AppBar(
        backgroundColor: Color(0xFF808080), // ڕەنگی AppBar
        title: Center(
            child: Text('ڵاپەرەی خەدەمات', style: TextStyle(fontSize: 30 , fontWeight: FontWeight.bold))), // ناونیشانی لاپەرەکە
      ),

      body: Scrollbar(
        thumbVisibility: true, // پیشاندانی سکرۆڵ باری هەمیشەیی
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(10.0), // دانانی ڕوودا بۆ ناوەڕۆک
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center, // جیاکردنەوەی ناوەڕۆک بە سنووری ناوەوە
            mainAxisAlignment: MainAxisAlignment.center, // ناوەڕۆک ببە لەناوەوە بە شێوەی ڕیزبەندی
            children: [
              SizedBox(height: 10),
              Text(
                '$_formattedDateTime', // پیشاندانی کات بە شێوەی خوکار
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),

              // ناونیشانەکان بۆ خزمەتگوزاری
              _buildLabelRow(['جۆری  خەدەمات', 'کۆی یەکە', 'نرخی یەکە', 'پارەی خەدەمات']),
              SizedBox(height: 20),

              // داتاکانی خزمەتگوزاری کارەبا
              _buildLabelRow(['کارەبا', '11', '4', '44']),
              SizedBox(height: 20),

              // داتاکانی خزمەتگوزاری غاز
              _buildLabelRow(['غاز', '11', '22', '242']),
              SizedBox(height: 20),

              // داتاکانی خزمەتگوزاری ئاو
              _buildLabelRow(['ئاو', '31', '7', '217']),
              SizedBox(height: 80),

              // خزمەتگوزاری گشتی
              _buildLabelRow(['خەدەماتی گشتی', 'کۆی گشتی']),
              SizedBox(height: 10),
              _buildLabelRow(['40', '543']),
            ],
          ),
        ),
      ),
    );
  }
}
