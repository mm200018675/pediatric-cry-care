// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

const Color mainColor = Color(0xFF20B8B3);
const Color bgColor = Color(0xFFEAFBFF);
const Color darkText = Color(0xFF102A43);
const Color medicalBlue = Color(0xFF4A90E2);
const Color softPink = Color(0xFFFFD6E7);
const Color softYellow = Color(0xFFFFE8A3);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: RoleScreen(),
    );
  }
}

class BabyBg extends StatelessWidget {
  final Widget child;
  const BabyBg({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: bgColor,
      child: Stack(
        children: [
          Positioned(top: -40, left: -35, child: circle(150, mainColor.withOpacity(.15))),
          Positioned(top: 70, right: -25, child: circle(120, softPink.withOpacity(.45))),
          Positioned(bottom: -35, left: 20, child: circle(150, medicalBlue.withOpacity(.12))),
          Positioned(bottom: 80, right: 25, child: circle(95, softYellow.withOpacity(.55))),
          const Positioned(top: 80, left: 30, child: Icon(Icons.cloud, color: Colors.white, size: 55)),
          const Positioned(top: 130, right: 45, child: Icon(Icons.cloud, color: Colors.white, size: 45)),
          const Positioned(bottom: 80, left: 30, child: Icon(Icons.cloud, color: Colors.white, size: 60)),
          const Positioned(top: 170, left: 55, child: Icon(Icons.star, color: Color(0xFFFFC857), size: 18)),
          const Positioned(top: 230, right: 60, child: Icon(Icons.favorite, color: Color(0xFFFF8FAB), size: 18)),
          const Positioned(bottom: 170, left: 70, child: Icon(Icons.local_hospital, color: mainColor, size: 22)),
          const Positioned(bottom: 130, right: 70, child: Icon(Icons.monitor_heart, color: mainColor, size: 22)),
          SafeArea(child: child),
        ],
      ),
    );
  }

  Widget circle(double size, Color color) {
    return Container(width: size, height: size, decoration: BoxDecoration(color: color, shape: BoxShape.circle));
  }
}

Widget mainButton(String text, IconData icon, VoidCallback onTap) {
  return SizedBox(
    width: double.infinity,
    height: 55,
    child: ElevatedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, color: Colors.white),
      label: Text(text, style: const TextStyle(color: Colors.white, fontSize: 17)),
      style: ElevatedButton.styleFrom(
        backgroundColor: mainColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
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
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
  );
}

class RoleScreen extends StatelessWidget {
  const RoleScreen({super.key});

  Widget roleButton(BuildContext context, String title, String sub, IconData icon, Widget page, Color color) {
    return InkWell(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => page)),
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [BoxShadow(color: color.withOpacity(.25), blurRadius: 15, offset: const Offset(0, 8))],
        ),
        child: Row(
          children: [
            CircleAvatar(radius: 28, backgroundColor: Colors.white, child: Icon(icon, color: color, size: 30)),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                  Text(sub, style: const TextStyle(color: Colors.white70, fontSize: 13)),
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
              const Icon(Icons.child_care, size: 95, color: mainColor),
              const SizedBox(height: 15),
              const Text("Pediatric Cry Care", textAlign: TextAlign.center, style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold, color: darkText)),
              const SizedBox(height: 8),
              const Text("Smart baby health monitoring 💙", style: TextStyle(color: Colors.grey, fontSize: 16)),
              const SizedBox(height: 35),
              roleButton(context, "Mother / User", "Monitor your baby's health", Icons.person, const LoginScreen(), mainColor),
              roleButton(context, "Doctor", "Register as pediatric doctor", Icons.medical_services, const DoctorRegisterScreen(), medicalBlue),
              roleButton(context, "Admin", "Approve doctors and manage system", Icons.admin_panel_settings, const AdminScreen(), const Color(0xFF8E6AD8)),
            ],
          ),
        ),
      ),
    );
  }
}

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BabyBg(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(25),
            child: Column(
              children: [
                const Icon(Icons.health_and_safety, size: 90, color: mainColor),
                const SizedBox(height: 15),
                const Text("Welcome Back!", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: darkText)),
                const SizedBox(height: 8),
                const Text("Login to your account", style: TextStyle(color: Colors.grey)),
                const SizedBox(height: 30),
                Card(
                  elevation: 10,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                  child: Padding(
                    padding: const EdgeInsets.all(25),
                    child: Column(
                      children: [
                        TextField(decoration: inputField("Username", Icons.person_outline)),
                        const SizedBox(height: 15),
                        TextField(obscureText: true, decoration: inputField("Password", Icons.lock_outline)),
                        const SizedBox(height: 25),
                        mainButton("Login", Icons.login, () {
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const MainNavigationScreen()));
                        }),
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
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.child_care), label: "Profile"),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: "History"),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: "Consult"),
        ],
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  final Function(int) onTabSelected;
  const HomeScreen({super.key, required this.onTabSelected});

  Widget quickCard(IconData icon, String title, Color color) {
    return Expanded(
      child: Container(
        height: 100,
        margin: const EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black.withOpacity(.06), blurRadius: 10)]),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(title, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
          ],
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
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
        child: Row(
          children: [
            Icon(icon, color: mainColor),
            const SizedBox(width: 12),
            Expanded(child: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: darkText))),
            const Icon(Icons.arrow_forward_ios, size: 16),
          ],
        ),
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
            const Text("Hello, Mom 👋", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: darkText)),
            const Text("Let's take care of your baby", style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 25),
            Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(28), boxShadow: [BoxShadow(color: Colors.black.withOpacity(.08), blurRadius: 15)]),
              child: Row(
                children: [
                  Expanded(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 145,
                          height: 145,
                          decoration: BoxDecoration(color: const Color(0xFFE7FAF9), shape: BoxShape.circle, border: Border.all(color: mainColor, width: 4)),
                        ),
                        const Icon(Icons.child_care, size: 75, color: mainColor),
                        const Positioned(right: 20, bottom: 18, child: CircleAvatar(backgroundColor: Colors.white, child: Icon(Icons.monitor_heart, color: medicalBlue))),
                      ],
                    ),
                  ),
                  const SizedBox(width: 15),
                  Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(color: const Color(0xFFE8FFF5), borderRadius: BorderRadius.circular(20)),
                    child: const Column(
                      children: [
                        Text("Baby Status", style: TextStyle(fontWeight: FontWeight.bold, color: darkText)),
                        SizedBox(height: 10),
                        Row(children: [Icon(Icons.favorite, color: Colors.green), SizedBox(width: 5), Text("Healthy", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold))]),
                        SizedBox(height: 8),
                        Text("All signals normal", style: TextStyle(fontSize: 12, color: Colors.grey)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),
            const Text("Quick Actions", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: darkText)),
            const SizedBox(height: 12),
            Row(
              children: [
                quickCard(Icons.mic, "Start\nRecording", mainColor),
                quickCard(Icons.favorite, "Heart\nRate", Colors.redAccent),
                quickCard(Icons.thermostat, "Temperature\nCheck", Colors.purple),
              ],
            ),
            const SizedBox(height: 20),
            mainButton("Start Recording", Icons.mic, () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const ResultScreen()));
            }),
            const SizedBox(height: 20),
            navTile(Icons.child_care, "Infant Profile", () => onTabSelected(1)),
            navTile(Icons.history, "Monitoring History", () => onTabSelected(2)),
            navTile(Icons.medical_services, "Doctor Consultation", () => onTabSelected(3)),
          ],
        ),
      ),
    );
  }
}

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
            const Text("Infant Profile", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: darkText)),
            const SizedBox(height: 20),
            const CircleAvatar(radius: 55, backgroundColor: Color(0xFFE7FAF9), child: Icon(Icons.child_care, color: mainColor, size: 65)),
            const SizedBox(height: 20),
            Card(
              elevation: 8,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
              child: Padding(
                padding: const EdgeInsets.all(22),
                child: Column(
                  children: [
                    TextField(decoration: inputField("Baby Name", Icons.person)),
                    const SizedBox(height: 12),
                    TextField(decoration: inputField("Age (months)", Icons.cake)),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: gender,
                      decoration: inputField("Gender", Icons.wc),
                      items: const [DropdownMenuItem(value: "Boy", child: Text("Boy")), DropdownMenuItem(value: "Girl", child: Text("Girl"))],
                      onChanged: (v) => setState(() => gender = v!),
                    ),
                    const SizedBox(height: 12),
                    TextField(decoration: inputField("Weight (kg)", Icons.monitor_weight)),
                    const SizedBox(height: 12),
                    TextField(decoration: inputField("Temperature (°C)", Icons.thermostat)),
                    const SizedBox(height: 12),
                    TextField(decoration: inputField("Last Feeding Time", Icons.access_time)),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: medicalHistory,
                      decoration: inputField("Previous Diseases?", Icons.local_hospital),
                      items: const [DropdownMenuItem(value: "No", child: Text("No")), DropdownMenuItem(value: "Yes", child: Text("Yes"))],
                      onChanged: (v) => setState(() => medicalHistory = v!),
                    ),
                    if (medicalHistory == "Yes") ...[
                      const SizedBox(height: 12),
                      TextField(decoration: inputField("Write disease details", Icons.edit_note)),
                    ],
                    const SizedBox(height: 20),
                    mainButton("Save Profile", Icons.save, () {}),
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

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  Widget item(String type, String date, String status, Color color) {
    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      child: ListTile(
        leading: CircleAvatar(backgroundColor: color.withOpacity(.15), child: Icon(Icons.monitor_heart, color: color)),
        title: Text(type, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(date),
        trailing: Text(status, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BabyBg(
      child: ListView(
        padding: const EdgeInsets.all(25),
        children: [
          const Text("Monitoring History", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: darkText)),
          const SizedBox(height: 20),
          item("Hunger", "24 May 2026 - 09:32 AM", "Normal", Colors.green),
          item("Discomfort", "23 May 2026 - 07:15 PM", "Attention", Colors.orange),
          item("Pain", "22 May 2026 - 11:10 AM", "Alert", Colors.redAccent),
        ],
      ),
    );
  }
}

class SubscriptionScreen extends StatelessWidget {
  const SubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BabyBg(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Card(
            elevation: 8,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
            child: Padding(
              padding: const EdgeInsets.all(25),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.medical_services, size: 85, color: mainColor),
                  const SizedBox(height: 20),
                  const Text("Need a Pediatric Consultation?", textAlign: TextAlign.center, style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: darkText)),
                  const SizedBox(height: 15),
                  const Text("Subscribe to access trusted pediatric doctors.", textAlign: TextAlign.center, style: TextStyle(color: Colors.grey)),
                  const SizedBox(height: 15),
                  const Text("Monthly Plan: 150 EGP", style: TextStyle(fontWeight: FontWeight.bold)),
                  const Text("Yearly Plan: 1200 EGP", style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 25),
                  mainButton("Subscribe Now", Icons.workspace_premium, () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const ConsultationScreen()));
                  }),
                  const SizedBox(height: 12),
                  mainButton("Book Appointment", Icons.calendar_month, () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const AppointmentScreen()));
                  }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ConsultationScreen extends StatelessWidget {
  const ConsultationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BabyBg(
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Card(
            elevation: 8,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
            child: Padding(
              padding: const EdgeInsets.all(25),
              child: Column(
                children: [
                  Align(alignment: Alignment.centerLeft, child: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context))),
                  const Icon(Icons.medical_services, size: 75, color: mainColor),
                  const SizedBox(height: 15),
                  const Text("Talk with Pediatric Doctor", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: darkText)),
                  const SizedBox(height: 20),
                  TextField(decoration: inputField("Consultation Subject", Icons.title)),
                  const SizedBox(height: 15),
                  TextField(maxLines: 4, decoration: inputField("Describe baby's condition", Icons.edit_note)),
                  const SizedBox(height: 20),
                  mainButton("Send Request", Icons.send, () {}),
                  const SizedBox(height: 15),
                  const Card(
                    child: ListTile(
                      leading: Icon(Icons.chat_bubble, color: mainColor),
                      title: Text("Doctor Reply"),
                      subtitle: Text("Please monitor temperature and feeding time."),
                    ),
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

class AppointmentScreen extends StatelessWidget {
  const AppointmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BabyBg(
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Card(
            elevation: 8,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
            child: Padding(
              padding: const EdgeInsets.all(25),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Align(alignment: Alignment.centerLeft, child: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context))),
                  const Icon(Icons.calendar_month, size: 80, color: mainColor),
                  const SizedBox(height: 20),
                  const Text("Book Appointment", style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: darkText)),
                  const SizedBox(height: 20),
                  TextField(decoration: inputField("Select Date", Icons.calendar_today)),
                  const SizedBox(height: 15),
                  TextField(decoration: inputField("Select Time", Icons.access_time)),
                  const SizedBox(height: 25),
                  mainButton("Confirm Booking", Icons.event_available, () {}),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key});

  Widget row(IconData icon, String title, String value, Color color) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(title),
      trailing: Text(value, style: TextStyle(fontWeight: FontWeight.bold, color: color)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BabyBg(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(25),
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
              child: Padding(
                padding: const EdgeInsets.all(25),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Align(alignment: Alignment.centerLeft, child: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context))),
                    const Icon(Icons.star, size: 90, color: Color(0xFFFFC857)),
                    const SizedBox(height: 10),
                    const Text("Cry Type", style: TextStyle(color: Colors.grey)),
                    const Text("Hunger", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: mainColor)),
                    row(Icons.percent, "Confidence", "87%", mainColor),
                    row(Icons.warning_amber, "Risk Level", "Low", Colors.green),
                    row(Icons.lightbulb, "Recommendation", "Try feeding", Colors.orange),
                    const SizedBox(height: 15),
                    mainButton("View Medical Report", Icons.description, () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const MedicalReportScreen()));
                    }),
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

class MedicalReportScreen extends StatelessWidget {
  const MedicalReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BabyBg(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(25),
            child: Card(
              elevation: 8,
              child: Padding(
                padding: const EdgeInsets.all(25),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Align(alignment: Alignment.centerLeft, child: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context))),
                    const Icon(Icons.description, size: 80, color: mainColor),
                    const SizedBox(height: 20),
                    const Text("Cry Analysis Report", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: darkText)),
                    const ListTile(title: Text("Cry Type"), trailing: Text("Hunger")),
                    const ListTile(title: Text("Confidence"), trailing: Text("87%")),
                    const ListTile(title: Text("Risk Level"), trailing: Text("Low")),
                    const SizedBox(height: 15),
                    mainButton("Download Report", Icons.download, () {}),
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

class DoctorRegisterScreen extends StatelessWidget {
  const DoctorRegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BabyBg(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(25),
          child: Card(
            elevation: 8,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
            child: Padding(
              padding: const EdgeInsets.all(25),
              child: Column(
                children: [
                  Align(alignment: Alignment.centerLeft, child: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context))),
                  const Icon(Icons.medical_services, size: 80, color: mainColor),
                  const SizedBox(height: 15),
                  const Text("Doctor Registration", style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: darkText)),
                  const SizedBox(height: 20),
                  TextField(decoration: inputField("Doctor Full Name", Icons.person)),
                  const SizedBox(height: 12),
                  TextField(decoration: inputField("Email", Icons.email)),
                  const SizedBox(height: 12),
                  TextField(decoration: inputField("Specialization", Icons.medical_services)),
                  const SizedBox(height: 12),
                  TextField(decoration: inputField("Medical License ID", Icons.badge)),
                  const SizedBox(height: 12),
                  TextField(decoration: inputField("Certificate / Graduation Proof", Icons.upload_file)),
                  const SizedBox(height: 12),
                  TextField(decoration: inputField("Years of Experience", Icons.work)),
                  const SizedBox(height: 20),
                  mainButton("Submit for Admin Approval", Icons.upload, () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const PendingApprovalScreen()));
                  }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

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
                IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context)),
                const Icon(Icons.hourglass_top, size: 90, color: mainColor),
                const SizedBox(height: 20),
                const Text("Waiting for Admin Approval", textAlign: TextAlign.center, style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: darkText)),
                const SizedBox(height: 15),
                const Text("Your doctor account and certificate are under review.", textAlign: TextAlign.center, style: TextStyle(color: Colors.grey)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  Widget doctorRequest(BuildContext context, String name, String license) {
    return Card(
      margin: const EdgeInsets.only(bottom: 15),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            ListTile(
              leading: const Icon(Icons.medical_services, color: mainColor),
              title: Text(name),
              subtitle: Text("License: $license\nCertificate: Uploaded"),
            ),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const DoctorDashboardScreen())),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    child: const Text("Approve", style: TextStyle(color: Colors.white)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
                    child: const Text("Reject", style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            )
          ],
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
            IconButton(alignment: Alignment.centerLeft, icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context)),
            const Icon(Icons.admin_panel_settings, size: 80, color: mainColor),
            const SizedBox(height: 15),
            const Text("Admin Dashboard", textAlign: TextAlign.center, style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: darkText)),
            const SizedBox(height: 20),
            doctorRequest(context, "Dr. Ahmed Mohamed", "DOC-2026-112"),
            doctorRequest(context, "Dr. Sara Ali", "DOC-2026-205"),
          ],
        ),
      ),
    );
  }
}

class DoctorDashboardScreen extends StatelessWidget {
  const DoctorDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BabyBg(
        child: ListView(
          padding: const EdgeInsets.all(25),
          children: [
            Align(alignment: Alignment.centerLeft, child: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context))),
            const Text("Doctor Dashboard", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: darkText)),
            const SizedBox(height: 20),
            const Card(
              child: ListTile(
                leading: Icon(Icons.child_care, color: mainColor),
                title: Text("Baby: Adam"),
                subtitle: Text("Issue: Repeated crying after feeding"),
                trailing: Text("New"),
              ),
            ),
            const Card(
              child: ListTile(
                leading: Icon(Icons.monitor_heart, color: mainColor),
                title: Text("Patient Info"),
                subtitle: Text("Age: 6 months • Temp: 37°C • Weight: 7kg"),
              ),
            ),
            const Card(
              child: ListTile(
                leading: Icon(Icons.reply, color: mainColor),
                title: Text("Doctor Reply"),
                subtitle: Text("Mother should monitor temperature and feeding schedule."),
              ),
            ),
          ],
        ),
      ),
    );
  }
}