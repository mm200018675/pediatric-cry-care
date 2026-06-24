// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
// ignore: unused_import
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

const Color mainColor = Color(0xFF20B8B3);
const Color bgColor = Color(0xFFEAFBFF);
const Color darkText = Color(0xFF102A43);
const Color medicalBlue = Color(0xFF4A90E2);
const Color softPink = Color(0xFFFFD6E7);
const Color softYellow = Color(0xFFFFE8A3);
const Color successColor = Color(0xFF2ECC71);
const Color warningColor = Color(0xFFFF9800);
const Color dangerColor = Color(0xFFE74C3C);


const String babyImage = "assets/baby.png";

const String doctorImage =
    "assets/baby doctor.webp";

class ChatMessage {
  final String sender;
  final String message;
  final bool isDoctor;

  ChatMessage({
    required this.sender,
    required this.message,
    required this.isDoctor,
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Pediatric Cry Care",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: mainColor,
        scaffoldBackgroundColor: bgColor,
        fontFamily: "Arial",
        colorScheme: ColorScheme.fromSeed(seedColor: mainColor),
        useMaterial3: true,
      ),
      home: const RoleScreen(),
    );
  }
}

/* ===================== BACKGROUND ===================== */

class BabyBg extends StatelessWidget {
  final Widget child;
  const BabyBg({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: bgColor,
      child: Stack(
        children: [
          Positioned(
            top: -45,
            left: -35,
            child: circle(155, mainColor.withOpacity(.13)),
          ),
          Positioned(
            top: 75,
            right: -30,
            child: circle(125, softPink.withOpacity(.50)),
          ),
          Positioned(
            bottom: -40,
            left: 20,
            child: circle(150, medicalBlue.withOpacity(.12)),
          ),
          Positioned(
            bottom: 90,
            right: 25,
            child: circle(95, softYellow.withOpacity(.55)),
          ),
          const Positioned(
            top: 75,
            left: 28,
            child: Icon(Icons.cloud, color: Colors.white, size: 58),
          ),
          const Positioned(
            top: 135,
            right: 40,
            child: Icon(Icons.cloud, color: Colors.white, size: 48),
          ),
          const Positioned(
            bottom: 80,
            left: 32,
            child: Icon(Icons.cloud, color: Colors.white, size: 62),
          ),
          const Positioned(
            top: 170,
            left: 55,
            child: Icon(Icons.star, color: Color(0xFFFFC857), size: 18),
          ),
          const Positioned(
            top: 230,
            right: 60,
            child: Icon(Icons.favorite, color: Color(0xFFFF8FAB), size: 18),
          ),
          const Positioned(
            bottom: 170,
            left: 70,
            child: Icon(Icons.local_hospital, color: mainColor, size: 22),
          ),
          const Positioned(
            bottom: 130,
            right: 70,
            child: Icon(Icons.monitor_heart, color: mainColor, size: 22),
          ),
          SafeArea(child: child),
        ],
      ),
    );
  }

  Widget circle(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}

/* ===================== REUSABLE WIDGETS ===================== */

Widget mainButton(
  String text,
  IconData icon,
  VoidCallback onTap, {
  Color color = mainColor,
}) {
  return SizedBox(
    width: double.infinity,
    height: 55,
    child: ElevatedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, color: Colors.white),
      label: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 17,
          fontWeight: FontWeight.bold,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
      ),
    ),
  );
}

InputDecoration inputField(String hint, IconData icon) {
  return InputDecoration(
    prefixIcon: Icon(icon, color: mainColor),
    hintText: hint,
    filled: true,
    fillColor: Colors.white,
    contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 18),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide.none,
    ),
  );
}

Widget backButton(BuildContext context) {
  return Align(
    alignment: Alignment.centerLeft,
    child: IconButton(
      icon: const Icon(Icons.arrow_back, color: darkText),
      onPressed: () => Navigator.pop(context),
    ),
  );
}

Widget networkCircleImage({
  required String url,
  required IconData fallbackIcon,
  double size = 130,
}) {
  return Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      border: Border.all(color: mainColor, width: 4),
      boxShadow: [
        BoxShadow(
          color: mainColor.withOpacity(.18),
          blurRadius: 18,
          offset: const Offset(0, 8),
        ),
      ],
    ),
    child: ClipOval(
      child: Image.network(
        url,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return ColoredBox(
            color: const Color(0xFFE7FAF9),
            child: Icon(fallbackIcon, color: mainColor, size: size * .45),
          );
        },
      ),
    ),
  );
}

Widget sectionTitle(String title) {
  return Align(
    alignment: Alignment.centerLeft,
    child: Text(
      title,
      style: const TextStyle(
        fontSize: 21,
        fontWeight: FontWeight.bold,
        color: darkText,
      ),
    ),
  );
}

Widget smallStatCard(
  String number,
  String label,
  IconData icon,
  Color color,
) {
  return Expanded(
    child: Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Icon(icon, color: color),
            const SizedBox(height: 5),
            Text(
              number,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(label, style: const TextStyle(fontSize: 11)),
          ],
        ),
      ),
    ),
  );
}

Widget featureCard({
  required IconData icon,
  required String title,
  required String subtitle,
  required Color color,
}) {
  return Card(
    elevation: 5,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          CircleAvatar(
            radius: 27,
            backgroundColor: color.withOpacity(.15),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: darkText,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(subtitle, style: const TextStyle(color: Colors.grey)),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

/* ===================== ROLE SCREEN ===================== */

class RoleScreen extends StatelessWidget {
  const RoleScreen({super.key});

  Widget roleButton(
    BuildContext context,
    String title,
    String sub,
    IconData icon,
    Widget page,
    Color color,
  ) {
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => page));
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(.25),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.white,
              child: Icon(icon, color: color, size: 32),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    sub,
                    style: const TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, color: Colors.white),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BabyBg(
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              networkCircleImage(
                url: babyImage,
                fallbackIcon: Icons.child_care,
                size: 125,
              ),
              const SizedBox(height: 15),
              const Text(
                "Pediatric Cry Care",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                  color: darkText,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Smart baby health monitoring 💙",
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
              const SizedBox(height: 35),
              roleButton(
                context,
                "Mother / User",
                "Monitor your baby's health",
                Icons.person,
                const LoginScreen(),
                mainColor,
              ),
              roleButton(
                context,
                "Doctor",
                "Register as pediatric doctor",
                Icons.medical_services,
                const DoctorRegisterScreen(),
                medicalBlue,
              ),
              roleButton(
                context,
                "Admin",
                "Approve doctors and manage system",
                Icons.admin_panel_settings,
                const AdminScreen(),
                const Color(0xFF8E6AD8),
              ),
            ],
          ),
        ),
      ),
    );
  }
  } 
  /* ===================== LOGIN SCREEN ===================== */

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  Future<void> login() async {

  final userResult = await FirebaseFirestore.instance
      .collection('users')
      .where('email', isEqualTo: emailController.text.trim())
      .where('password', isEqualTo: passwordController.text.trim())
      .get();

  if (userResult.docs.isNotEmpty) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const MainNavigationScreen(),
      ),
    );
    return;
  }

  final doctorResult = await FirebaseFirestore.instance
      .collection('doctors')
      .where('email', isEqualTo: emailController.text.trim())
      .get();

  if (doctorResult.docs.isNotEmpty) {
    final doctor = doctorResult.docs.first.data();

    if (doctor['approved'] == true) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const DoctorDashboardScreen(),
        ),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const PendingApprovalScreen(),
        ),
      );
    }
    return;
  }

  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text("Wrong email or password"),
    ),
  );
}

  Future<void> register() async {
  await FirebaseFirestore.instance.collection('users').add({
    'email': emailController.text.trim(),
    'password': passwordController.text.trim(),
    'role': 'mother',
    'createdAt': DateTime.now(),
  });

  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text("Account saved successfully")),
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BabyBg(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(25),
            child: Column(
              children: [
                backButton(context),
                const Icon(Icons.health_and_safety, size: 85, color: mainColor),
                const SizedBox(height: 12),
                const Text(
                  "Welcome Back!",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: darkText,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Login to your account",
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 25),
                Card(
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(25),
                    child: Column(
                      children: [
                        TextField(
                          controller: emailController,
                          decoration: inputField("Email", Icons.email),
                        ),
                        const SizedBox(height: 15),
                        TextField(
                          controller: passwordController,
                          obscureText: true,
                          decoration: inputField("Password", Icons.lock_outline),
                        ),
                        const SizedBox(height: 25),
                        mainButton("Login", Icons.login, login),
                        const SizedBox(height: 12),
                        TextButton(
                          onPressed: register,
                          child: const Text("Create New Account"),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/* ===================== MAIN NAVIGATION ===================== */

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    final screens = [
      HomeScreen(onTabSelected: (i) => setState(() => index = i)),
      const InfantProfileScreen(),
      const HistoryScreen(),
      const SubscriptionScreen(),
      const NotificationsScreen(),
    ];

    return Scaffold(
      body: screens[index],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        selectedItemColor: mainColor,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        onTap: (v) => setState(() => index = v),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.child_care),
            label: "Profile",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: "History",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: "Consult",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: "Alerts",
          ),
        ],
      ),
    );
  }
}

/* ===================== HOME SCREEN ===================== */

class HomeScreen extends StatelessWidget {
  final Function(int) onTabSelected;
  const HomeScreen({super.key, required this.onTabSelected});

  Widget quickCard(
    IconData icon,
    String title,
    Color color,
    VoidCallback onTap,
  ) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: 105,
          margin: const EdgeInsets.symmetric(horizontal: 5),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(.06),
                blurRadius: 10,
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 34),
              const SizedBox(height: 8),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget navTile(IconData icon, String title, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.04),
              blurRadius: 8,
            ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: mainColor.withOpacity(.12),
              child: Icon(icon, color: mainColor),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: darkText,
                ),
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16),
          ],
        ),
      ),
    );
  }

  Widget aiStatsCard() {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: const [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.psychology, color: mainColor),
                SizedBox(width: 8),
                Text(
                  "AI Model Statistics",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: darkText,
                  ),
                ),
              ],
            ),
            SizedBox(height: 15),
            Text("Dataset: Donate A Cry"),
            Text("Accuracy: 87%"),
            Text("Classes: Hungry • Pain • Sleepy • Discomfort"),
          ],
        ),
      ),
    );
  }

  Widget statusCard() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFFE8FFF5),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: successColor.withOpacity(.2)),
      ),
      child: const Column(
        children: [
          Text(
            "Baby Status",
            style: TextStyle(fontWeight: FontWeight.bold, color: darkText),
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Icon(Icons.favorite, color: successColor),
              SizedBox(width: 5),
              Text(
                "Healthy",
                style: TextStyle(
                  color: successColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            "All signals normal",
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BabyBg(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Expanded(
                  child: Text(
                    "Hello, Mom 👋",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: darkText,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.logout, color: dangerColor),
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const RoleScreen()),
                      (route) => false,
                    );
                  },
                ),
              ],
            ),
            const Text(
              "Let's take care of your baby",
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 25),

            Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(.08),
                    blurRadius: 15,
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        networkCircleImage(
                          url: babyImage,
                          fallbackIcon: Icons.child_care,
                          size: 145,
                        ),
                        const Positioned(
                          right: 18,
                          bottom: 15,
                          child: CircleAvatar(
                            backgroundColor: Colors.white,
                            child: Icon(Icons.monitor_heart, color: medicalBlue),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 15),
                  statusCard(),
                ],
              ),
            ),

            const SizedBox(height: 25),
            sectionTitle("Quick Actions"),
            const SizedBox(height: 12),

            Row(
              children: [
                quickCard(
                  Icons.mic,
                  "Start\nRecording",
                  mainColor,
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ResultScreen()),
                    );
                  },
                ),
                quickCard(
                  Icons.favorite,
                  "Heart\nRate",
                  Colors.redAccent,
                  () {},
                ),
                quickCard(
                  Icons.thermostat,
                  "Temperature\nCheck",
                  Colors.purple,
                  () {},
                ),
              ],
            ),

            const SizedBox(height: 20),
            mainButton(
              "Start Recording",
              Icons.mic,
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ResultScreen()),
                );
              },
            ),

            const SizedBox(height: 20),
            aiStatsCard(),

            const SizedBox(height: 20),
            navTile(Icons.child_care, "Infant Profile", () => onTabSelected(1)),
            navTile(Icons.history, "Monitoring History", () => onTabSelected(2)),
            navTile(Icons.medical_services, "Doctor Consultation", () => onTabSelected(3)),
            navTile(Icons.notifications, "Notifications", () => onTabSelected(4)),
          ],
        ),
      ),
    );
  }
} 
/* ===================== INFANT PROFILE SCREEN ===================== */

class InfantProfileScreen extends StatefulWidget {
  const InfantProfileScreen({super.key});

  @override
  State<InfantProfileScreen> createState() => _InfantProfileScreenState();
}

class _InfantProfileScreenState extends State<InfantProfileScreen> {
  String gender = "Boy";
  String medicalHistory = "No";

  @override
  Widget build(BuildContext context) {
    return BabyBg(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(25),
        child: Column(
          children: [
            const Text(
              "Infant Profile",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: darkText,
              ),
            ),
            const SizedBox(height: 20),
            networkCircleImage(
              url: babyImage,
              fallbackIcon: Icons.child_care,
              size: 120,
            ),
            const SizedBox(height: 20),
            Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              child: Padding(
                padding: const EdgeInsets.all(22),
                child: Column(
                  children: [
                    TextField(
                      decoration: inputField("Baby Name", Icons.person),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      decoration: inputField("Age (months)", Icons.cake),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: gender,
                      decoration: inputField("Gender", Icons.wc),
                      items: const [
                        DropdownMenuItem(value: "Boy", child: Text("Boy")),
                        DropdownMenuItem(value: "Girl", child: Text("Girl")),
                      ],
                      onChanged: (v) {
                        setState(() {
                          gender = v!;
                        });
                      },
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      decoration: inputField(
                        "Weight (kg)",
                        Icons.monitor_weight,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      decoration: inputField(
                        "Temperature (°C)",
                        Icons.thermostat,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      decoration: inputField(
                        "Last Feeding Time",
                        Icons.access_time,
                      ),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: medicalHistory,
                      decoration: inputField(
                        "Previous Diseases?",
                        Icons.local_hospital,
                      ),
                      items: const [
                        DropdownMenuItem(value: "No", child: Text("No")),
                        DropdownMenuItem(value: "Yes", child: Text("Yes")),
                      ],
                      onChanged: (v) {
                        setState(() {
                          medicalHistory = v!;
                        });
                      },
                    ),
                    if (medicalHistory == "Yes") ...[
                      const SizedBox(height: 12),
                      TextField(
                        decoration: inputField(
                          "Write disease details",
                          Icons.edit_note,
                        ),
                      ),
                    ],
                    const SizedBox(height: 20),
                    mainButton(
                      "Save Profile",
                      Icons.save,
                      () {},
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/* ===================== HISTORY SCREEN ===================== */

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  Widget item(String type, String date, String status, Color color) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 14),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(.15),
          child: Icon(Icons.monitor_heart, color: color),
        ),
        title: Text(
          type,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(date),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: color.withOpacity(.15),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            status,
            style: TextStyle(color: color, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BabyBg(
      child: ListView(
        padding: const EdgeInsets.all(25),
        children: [
          const Text(
            "Monitoring History",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: darkText,
            ),
          ),
          const SizedBox(height: 20),
          item("Hunger", "24 May 2026 - 09:32 AM", "Normal", successColor),
          item("Discomfort", "23 May 2026 - 07:15 PM", "Attention", warningColor),
          item("Pain", "22 May 2026 - 11:10 AM", "Alert", dangerColor),
        ],
      ),
    );
  }
}

/* ===================== SUBSCRIPTION SCREEN ===================== */

class SubscriptionScreen extends StatelessWidget {
  const SubscriptionScreen({super.key});

  Widget planCard(
    String title,
    String price,
    String subtitle,
    IconData icon,
    Color color,
  ) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: color.withOpacity(.15),
              child: Icon(icon, color: color),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: darkText,
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    ),
                  ),
                  Text(subtitle, style: const TextStyle(color: Colors.grey)),
                ],
              ),
            ),
            Text(
              price,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BabyBg(
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(25),
          child: Column(
            children: [
              const Icon(Icons.medical_services, size: 85, color: mainColor),
              const SizedBox(height: 15),
              const Text(
                "Doctor Consultation",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 27,
                  fontWeight: FontWeight.bold,
                  color: darkText,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Subscribe to access trusted pediatric doctors.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 22),
              planCard(
                "Monthly Plan",
                "150 EGP",
                "Chat + appointments + reports",
                Icons.workspace_premium,
                mainColor,
              ),
              planCard(
                "Yearly Plan",
                "1200 EGP",
                "Best value for continuous care",
                Icons.verified,
                medicalBlue,
              ),
              const SizedBox(height: 20),
              mainButton(
                "Subscribe Now",
                Icons.workspace_premium,
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ConsultationScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              mainButton(
                "Search Doctor",
                Icons.search,
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const DoctorSearchScreen(),
                    ),
                  );
                },
                color: medicalBlue,
              ),
              const SizedBox(height: 12),
              mainButton(
                "Book Appointment",
                Icons.calendar_month,
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const AppointmentScreen(),
                    ),
                  );
                },
                color: warningColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/* ===================== DOCTOR SEARCH SCREEN ===================== */

class DoctorSearchScreen extends StatefulWidget {
  const DoctorSearchScreen({super.key});

  @override
  State<DoctorSearchScreen> createState() => _DoctorSearchScreenState();
}

class _DoctorSearchScreenState extends State<DoctorSearchScreen> {
  final TextEditingController searchController = TextEditingController();

  final List<Map<String, String>> doctors = const [
    {
      "name": "Dr. Ahmed Mohamed",
      "specialization": "Pediatrician",
      "experience": "8 years",
      "rating": "4.8",
    },
    {
      "name": "Dr. Sara Ali",
      "specialization": "Pediatrician",
      "experience": "6 years",
      "rating": "4.7",
    },
    {
      "name": "Dr. Mostafa Hassan",
      "specialization": "Neonatologist",
      "experience": "10 years",
      "rating": "4.9",
    },
  ];

  @override
  Widget build(BuildContext context) {
    final filtered = doctors.where((doctor) {
      final query = searchController.text.toLowerCase();
      return doctor["name"]!.toLowerCase().contains(query) ||
          doctor["specialization"]!.toLowerCase().contains(query);
    }).toList();

    return Scaffold(
      body: BabyBg(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  backButton(context),
                  const Text(
                    "Search Doctor",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: darkText,
                    ),
                  ),
                  const SizedBox(height: 15),
                  TextField(
                    controller: searchController,
                    onChanged: (_) => setState(() {}),
                    decoration: inputField(
                      "Search by name or specialization",
                      Icons.search,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: filtered.length,
                itemBuilder: (context, index) {
                  final doctor = filtered[index];
                  return Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: mainColor.withOpacity(.15),
                        child: const Icon(Icons.medical_services, color: mainColor),
                      ),
                      title: Text(
                        doctor["name"]!,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        "${doctor["specialization"]} • ${doctor["experience"]}",
                      ),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 20),
                          Text(doctor["rating"]!),
                        ],
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => DoctorProfileScreen(doctor: doctor),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
} 
/* ===================== DOCTOR PROFILE SCREEN ===================== */

class DoctorProfileScreen extends StatelessWidget {
  final Map<String, String> doctor;

  const DoctorProfileScreen({
    super.key,
    required this.doctor,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BabyBg(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(25),
          child: Column(
            children: [
              backButton(context),
              networkCircleImage(
                url: doctorImage,
                fallbackIcon: Icons.medical_services,
                size: 125,
              ),
              const SizedBox(height: 15),
              Text(
                doctor["name"]!,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 27,
                  fontWeight: FontWeight.bold,
                  color: darkText,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                doctor["specialization"]!,
                style: const TextStyle(color: Colors.grey, fontSize: 16),
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  smallStatCard(
                    doctor["rating"]!,
                    "Rating",
                    Icons.star,
                    Colors.amber,
                  ),
                  smallStatCard(
                    doctor["experience"]!,
                    "Experience",
                    Icons.work,
                    medicalBlue,
                  ),
                  smallStatCard(
                    "120",
                    "Patients",
                    Icons.people,
                    mainColor,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              featureCard(
                icon: Icons.verified,
                title: "Verified Pediatric Doctor",
                subtitle: "Approved by admin after certificate review",
                color: successColor,
              ),
              featureCard(
                icon: Icons.school,
                title: "Certificate",
                subtitle: "Medical certificate and license are uploaded",
                color: medicalBlue,
              ),
              featureCard(
                icon: Icons.access_time,
                title: "Available Today",
                subtitle: "Online consultation from 7 PM to 10 PM",
                color: warningColor,
              ),
              const SizedBox(height: 15),
              mainButton(
                "Start Chat",
                Icons.chat,
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ConsultationScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              mainButton(
                "Book Appointment",
                Icons.calendar_month,
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const AppointmentScreen(),
                    ),
                  );
                },
                color: medicalBlue,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/* ===================== CONSULTATION / REAL CHAT SCREEN ===================== */

class ConsultationScreen extends StatefulWidget {
  const ConsultationScreen({super.key});

  @override
  State<ConsultationScreen> createState() => _ConsultationScreenState();
}

class _ConsultationScreenState extends State<ConsultationScreen> {
  final TextEditingController messageController = TextEditingController();
  

   Future<void> sendMessage({required bool isDoctor}) async {
  if (messageController.text.trim().isEmpty) return;

  await FirebaseFirestore.instance
      .collection('chat_rooms')
      .doc('room_general')
      .collection('messages')
      .add({
    'sender': isDoctor ? 'Doctor' : 'Mother',
    'message': messageController.text.trim(),
    'isDoctor': isDoctor,
    'createdAt': FieldValue.serverTimestamp(),
  });

  messageController.clear();
}
  Widget chatBubble(Map<String, dynamic> msg) {
    final bool isDoctor = msg['isDoctor'] == true;

    return Align(
      alignment: isDoctor ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        constraints: const BoxConstraints(maxWidth: 290),
        decoration: BoxDecoration(
          color: isDoctor ? Colors.white : mainColor,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              msg['sender'] ?? '',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isDoctor ? darkText : Colors.white,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              msg['message'] ?? '',
              style: TextStyle(
                color: isDoctor ? Colors.black87 : Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BabyBg(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              backButton(context),
              Row(
                children: [
                  networkCircleImage(
                    url: doctorImage,
                    fallbackIcon: Icons.medical_services,
                    size: 60,
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Doctor Chat",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: darkText,
                          ),
                        ),
                        Text(
                          "Online now • Pediatrician",
                          style: TextStyle(color: successColor),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.verified, color: medicalBlue),
                ],
              ),
              const SizedBox(height: 15),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('chat_rooms')
                      .doc('room_general')
                      .collection('messages')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final messages = snapshot.data!.docs;

                    return ListView.builder(
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        final data =
                            messages[index].data() as Map<String, dynamic>;
                        return chatBubble(data);
                      },
                    );
                  },
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: messageController,
                      decoration: inputField(
                        "Type your message...",
                        Icons.chat,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),

IconButton(
  icon: const Icon(Icons.send),
  onPressed: () => sendMessage(isDoctor: false),
),

IconButton(
  icon: const Icon(Icons.medical_services),
  onPressed: () => sendMessage(isDoctor: true),
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

/* ===================== APPOINTMENT SCREEN ===================== */

class AppointmentScreen extends StatefulWidget {
  const AppointmentScreen({super.key});

  @override
  State<AppointmentScreen> createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> {
  String selectedTime = "7:00 PM";
  String selectedDoctor = "Dr. Ahmed Mohamed";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BabyBg(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(25),
          child: Card(
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
            child: Padding(
              padding: const EdgeInsets.all(25),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  backButton(context),
                  const Icon(Icons.calendar_month, size: 80, color: mainColor),
                  const SizedBox(height: 20),
                  const Text(
                    "Book Appointment",
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: darkText,
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    decoration: inputField(
                      "Select Date",
                      Icons.calendar_today,
                    ),
                  ),
                  const SizedBox(height: 15),
                  DropdownButtonFormField<String>(
                    value: selectedTime,
                    decoration: inputField(
                      "Select Time",
                      Icons.access_time,
                    ),
                    items: const [
                      DropdownMenuItem(value: "7:00 PM", child: Text("7:00 PM")),
                      DropdownMenuItem(value: "8:00 PM", child: Text("8:00 PM")),
                      DropdownMenuItem(value: "9:00 PM", child: Text("9:00 PM")),
                    ],
                    onChanged: (v) {
                      setState(() {
                        selectedTime = v!;
                      });
                    },
                  ),
                  const SizedBox(height: 15),
                  DropdownButtonFormField<String>(
                    value: selectedDoctor,
                    decoration: inputField(
                      "Select Doctor",
                      Icons.medical_services,
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: "Dr. Ahmed Mohamed",
                        child: Text("Dr. Ahmed Mohamed"),
                      ),
                      DropdownMenuItem(
                        value: "Dr. Sara Ali",
                        child: Text("Dr. Sara Ali"),
                      ),
                    ],
                    onChanged: (v) {
                      setState(() {
                        selectedDoctor = v!;
                      });
                    },
                  ),
                  const SizedBox(height: 25),
                  mainButton(
                    "Confirm Booking",
                    Icons.event_available,
                    () {},
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/* ===================== RESULT SCREEN ===================== */

class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key});

  Widget resultRow(IconData icon, String title, String value, Color color) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(title),
      trailing: Text(
        value,
        style: TextStyle(fontWeight: FontWeight.bold, color: color),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BabyBg(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(25),
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              child: Padding(
                padding: const EdgeInsets.all(25),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    backButton(context),
                    const Icon(Icons.star, size: 90, color: Color(0xFFFFC857)),
                    const SizedBox(height: 10),
                    const Text(
                      "Cry Type",
                      style: TextStyle(color: Colors.grey),
                    ),
                    const Text(
                      "Hunger",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: mainColor,
                      ),
                    ),
                    resultRow(Icons.percent, "Confidence", "87%", mainColor),
                    resultRow(Icons.warning_amber, "Risk Level", "Low", successColor),
                    resultRow(Icons.lightbulb, "Recommendation", "Try feeding", warningColor),
                    const SizedBox(height: 15),
                    mainButton(
                      "View Medical Report",
                      Icons.description,
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const MedicalReportScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/* ===================== MEDICAL REPORT SCREEN ===================== */

class MedicalReportScreen extends StatelessWidget {
  const MedicalReportScreen({super.key});

  Widget reportItem(String title, String value, IconData icon) {
    return ListTile(
      leading: Icon(icon, color: mainColor),
      title: Text(title),
      trailing: Text(
        value,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: darkText,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BabyBg(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(25),
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              child: Padding(
                padding: const EdgeInsets.all(25),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    backButton(context),
                    const Icon(Icons.description, size: 80, color: mainColor),
                    const SizedBox(height: 20),
                    const Text(
                      "Cry Analysis Report",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: darkText,
                      ),
                    ),
                    const SizedBox(height: 15),
                    reportItem("Baby Name", "Adam", Icons.child_care),
                    reportItem("Cry Type", "Hunger", Icons.analytics),
                    reportItem("Confidence", "87%", Icons.percent),
                    reportItem("Risk Level", "Low", Icons.warning_amber),
                    reportItem("Recommendation", "Try feeding", Icons.lightbulb),
                    const SizedBox(height: 15),
                    mainButton(
                      "Download Report",
                      Icons.download,
                      () {},
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
/* ===================== DOCTOR REGISTER SCREEN ===================== */

class DoctorRegisterScreen extends StatefulWidget {
  const DoctorRegisterScreen({super.key});

  @override
  State<DoctorRegisterScreen> createState() => _DoctorRegisterScreenState();
}

class _DoctorRegisterScreenState extends State<DoctorRegisterScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final specializationController = TextEditingController();
  final licenseController = TextEditingController();
  final experienceController = TextEditingController();

  Future<void> submitDoctor() async {
    await FirebaseFirestore.instance.collection('doctors').add({
      'name': nameController.text.trim(),
      'email': emailController.text.trim(),
      'specialization': specializationController.text.trim(),
      'licenseId': licenseController.text.trim(),
      'experience': experienceController.text.trim(),
      'certificate': 'Uploaded',
      'approved': false,
      'createdAt': DateTime.now(),
    });

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const PendingApprovalScreen()),
    );
  }

  Widget uploadCertificateBox() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: mainColor.withOpacity(.3)),
      ),
      child: const Row(
        children: [
          Icon(Icons.upload_file, color: mainColor),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              "Upload Certificate / Graduation Proof",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Text("Choose File", style: TextStyle(color: medicalBlue)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BabyBg(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(25),
          child: Card(
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
            child: Padding(
              padding: const EdgeInsets.all(25),
              child: Column(
                children: [
                  backButton(context),
                  networkCircleImage(
                    url: doctorImage,
                    fallbackIcon: Icons.medical_services,
                    size: 115,
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    "Doctor Registration",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: darkText,
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: nameController,
                    decoration: inputField("Doctor Full Name", Icons.person),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: emailController,
                    decoration: inputField("Email", Icons.email),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: specializationController,
                    decoration: inputField("Specialization", Icons.medical_services),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: licenseController,
                    decoration: inputField("Medical License ID", Icons.badge),
                  ),
                  const SizedBox(height: 12),
                  uploadCertificateBox(),
                  const SizedBox(height: 12),
                  TextField(
                    controller: experienceController,
                    decoration: inputField("Years of Experience", Icons.work),
                  ),
                  const SizedBox(height: 20),
                  mainButton(
                    "Submit for Admin Approval",
                    Icons.upload,
                    submitDoctor,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
/* ===================== PENDING APPROVAL SCREEN ===================== */

class PendingApprovalScreen extends StatelessWidget {
  const PendingApprovalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BabyBg(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(25),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                backButton(context),
                const Icon(
                  Icons.hourglass_top,
                  size: 90,
                  color: mainColor,
                ),
                const SizedBox(height: 20),
                const Text(
                  "Waiting for Admin Approval",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: darkText,
                  ),
                ),
                const SizedBox(height: 15),
                const Text(
                  "Your doctor account and certificate are under review.",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/* ===================== ADMIN SCREEN ===================== */

class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  Widget doctorRequest(BuildContext context, QueryDocumentSnapshot doctor) {
    final data = doctor.data() as Map<String, dynamic>;

    return Card(
      elevation: 5,
      margin: const EdgeInsets.only(bottom: 15),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            ListTile(
              leading: const Icon(Icons.medical_services, color: mainColor),
              title: Text(
                data['name'] ?? 'No Name',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                "License: ${data['licenseId'] ?? 'No License'}\n"
                "Specialization: ${data['specialization'] ?? 'No specialization'}\n"
                "Certificate: ${data['certificate'] ?? 'Uploaded'}",
              ),
              trailing: TextButton(
                onPressed: () {},
                child: const Text("View Cert."),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      await FirebaseFirestore.instance
                          .collection('doctors')
                          .doc(doctor.id)
                          .update({'approved': true});

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Doctor approved")),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: successColor,
                    ),
                    child: const Text(
                      "Approve",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      await FirebaseFirestore.instance
                          .collection('doctors')
                          .doc(doctor.id)
                          .delete();

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Doctor rejected")),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: dangerColor,
                    ),
                    child: const Text(
                      "Reject",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget smallStatCard(String count, String title, IconData icon, Color color) {
    return Expanded(
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            children: [
              Icon(icon, color: color),
              const SizedBox(height: 6),
              Text(
                count,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: color,
                  fontSize: 18,
                ),
              ),
              Text(title),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BabyBg(
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('doctors')
              .where('approved', isEqualTo: false)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            final pendingDoctors = snapshot.data!.docs;

            return ListView(
              padding: const EdgeInsets.all(25),
              children: [
                backButton(context),
                const Icon(
                  Icons.admin_panel_settings,
                  size: 80,
                  color: mainColor,
                ),
                const SizedBox(height: 15),
                const Text(
                  "Admin Dashboard",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: darkText,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    smallStatCard(
                      pendingDoctors.length.toString(),
                      "Pending",
                      Icons.pending_actions,
                      warningColor,
                    ),
                    smallStatCard(
                      "0",
                      "Approved",
                      Icons.verified,
                      successColor,
                    ),
                    smallStatCard(
                      "0",
                      "Rejected",
                      Icons.cancel,
                      dangerColor,
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                if (pendingDoctors.isEmpty)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(30),
                      child: Text("No pending doctors"),
                    ),
                  ),
                ...pendingDoctors.map((doctor) {
                  return doctorRequest(context, doctor);
                // ignore: unnecessary_to_list_in_spreads
                }).toList(),
              ],
            );
          },
        ),
      ),
    );
  }
}

/* ===================== DOCTOR DASHBOARD SCREEN ===================== */

class DoctorDashboardScreen extends StatelessWidget {
  const DoctorDashboardScreen({super.key});

  Widget doctorReplyBox() {
    return Card(
  
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            const Text(
              "Reply to Mother",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: darkText,
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              maxLines: 3,
              decoration: inputField(
                "Write medical advice...",
                Icons.reply,
              ),
            ),
            const SizedBox(height: 12),
            mainButton(
              "Send Reply",
              Icons.send,
              () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget consultationCard(
    String babyName,
    String issue,
    String risk,
    Color color,
  ) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(.15),
          child: Icon(Icons.child_care, color: color),
        ),
        title: Text(
          babyName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(issue),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: color.withOpacity(.15),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            risk,
            style: TextStyle(color: color, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BabyBg(
        child: ListView(
          padding: const EdgeInsets.all(25),
          children: [
            backButton(context),
            Row(
              children: [
                networkCircleImage(
                  url: doctorImage,
                  fallbackIcon: Icons.medical_services,
                  size: 70,
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    "Doctor Dashboard",
                    style: TextStyle(
                      fontSize: 27,
                      fontWeight: FontWeight.bold,
                      color: darkText,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.logout, color: dangerColor),
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const RoleScreen()),
                      (route) => false,
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                smallStatCard("25", "Patients", Icons.people, mainColor),
                smallStatCard("6", "Pending", Icons.pending_actions, warningColor),
                smallStatCard("12", "Today", Icons.calendar_month, successColor),
              ],
            ),
            const SizedBox(height: 18),
            sectionTitle("Consultation Requests"),
            const SizedBox(height: 10),
            consultationCard(
              "Baby: Adam",
              "Repeated crying after feeding",
              "New",
              mainColor,
            ),
            consultationCard(
              "Baby: Laila",
              "High temperature and discomfort",
              "Urgent",
              dangerColor,
            ),
            const SizedBox(height: 12),
            featureCard(
              icon: Icons.monitor_heart,
              title: "Patient Info",
              subtitle: "Age: 6 months • Temp: 37°C • Weight: 7kg",
              color: mainColor,
            ),
            featureCard(
              icon: Icons.analytics,
              title: "Cry Analysis",
              subtitle: "Cry Type: Hunger • Confidence: 87%",
              color: medicalBlue,
            ),
            doctorReplyBox(),
          ],
        ),
      ),
    );
  }
}

/* ===================== NOTIFICATIONS SCREEN ===================== */

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  Widget notificationItem(
    IconData icon,
    String title,
    String sub,
    Color color,
  ) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 14),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(.15),
          child: Icon(icon, color: color),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(sub),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BabyBg(
      child: ListView(
        padding: const EdgeInsets.all(25),
        children: [
          const Text(
            "Notifications",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: darkText,
            ),
          ),
          const SizedBox(height: 20),
          notificationItem(
            Icons.notifications_active,
            "Cry Alert",
            "Baby crying detected for more than 15 minutes.",
            warningColor,
          ),
          notificationItem(
            Icons.medical_services,
            "Doctor Reply",
            "Dr. Ahmed replied to your consultation.",
            mainColor,
          ),
          notificationItem(
            Icons.calendar_month,
            "Appointment Reminder",
            "Your appointment is today at 7:00 PM.",
            medicalBlue,
          ),
          notificationItem(
            Icons.description,
            "Report Ready",
            "New cry analysis report is available.",
            successColor,
          ),
        ],
      ),
    );
  }
}