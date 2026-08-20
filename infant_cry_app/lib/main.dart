// ignore_for_file: curly_braces_in_flow_control_structures, avoid_web_libraries_in_flutter, unused_local_variable, use_build_context_synchronously, deprecated_member_use

import 'dart:html' as html;
import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:record/record.dart';
import 'firebase_options.dart';

Future<void> main() async {
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


/* ===================== PREMIUM 3D TEXT GLOW ===================== */

List<Shadow> premiumTextShadows({
  Color glow = Colors.white,
  double strength = 1,
}) {
  return [
    Shadow(
      color: glow.withOpacity(.95),
      offset: const Offset(-1.4, -1.4),
      blurRadius: 2.2 * strength,
    ),
    Shadow(
      color: mainColor.withOpacity(.10),
      offset: Offset.zero,
      blurRadius: 5.5 * strength,
    ),
    Shadow(
      color: const Color(0xFF071A2B).withOpacity(.18),
      offset: const Offset(1.6, 2.2),
      blurRadius: 3.2 * strength,
    ),
  ];
}

List<Shadow> coloredGlow(
  Color color, {
  double strength = 1,
}) {
  return [
    Shadow(
      color: color.withOpacity(.42),
      offset: Offset.zero,
      blurRadius: 10 * strength,
    ),
    Shadow(
      color: Colors.white.withOpacity(.98),
      offset: const Offset(-1.1, -1.1),
      blurRadius: 1.8,
    ),
    Shadow(
      color: const Color(0xFF071A2B).withOpacity(.18),
      offset: const Offset(1.4, 2),
      blurRadius: 3,
    ),
  ];
}

TextStyle premiumHeadingStyle({
  double size = 28,
  Color color = darkText,
}) {
  return TextStyle(
    fontSize: size,
    fontWeight: FontWeight.w900,
    color: color,
    letterSpacing: -.45,
    height: 1.05,
    shadows: premiumTextShadows(
      glow: Colors.white,
      strength: 1.35,
    ),
  );
}

TextStyle premiumMetricStyle({
  double size = 30,
  required Color color,
}) {
  return TextStyle(
    fontSize: size,
    fontWeight: FontWeight.w900,
    color: color,
    letterSpacing: -.6,
    shadows: coloredGlow(color, strength: 1.3),
  );
}

TextStyle premiumBody3D({
  double size = 13,
  Color color = const Color(0xFF53657A),
  FontWeight weight = FontWeight.w500,
}) {
  return TextStyle(
    fontSize: size,
    color: color,
    fontWeight: weight,
    height: 1.35,
    shadows: [
      Shadow(
        color: Colors.white.withOpacity(.98),
        offset: const Offset(-.8, -.8),
        blurRadius: 1.2,
      ),
      Shadow(
        color: const Color(0xFF071A2B).withOpacity(.10),
        offset: const Offset(.9, 1.2),
        blurRadius: 1.8,
      ),
    ],
  );
}


const String babyImage = "assets/baby.png";
const String doctorImage = "assets/baby doctor.webp";

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

final ValueNotifier<bool> appDarkMode = ValueNotifier<bool>(false);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  ThemeData lightTheme() {
    return ThemeData(
      primaryColor: mainColor,
      scaffoldBackgroundColor: const Color(0xFFF2FBFD),
      fontFamily: "Arial",
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: mainColor,
        brightness: Brightness.light,
      ),
      useMaterial3: true,
      textTheme: ThemeData.light().textTheme.copyWith(
        displayLarge: premiumHeadingStyle(size: 42),
        displayMedium: premiumHeadingStyle(size: 36),
        headlineLarge: premiumHeadingStyle(size: 32),
        headlineMedium: premiumHeadingStyle(size: 28),
        headlineSmall: premiumHeadingStyle(size: 23),
        titleLarge: premiumHeadingStyle(size: 20),
        titleMedium: premiumHeadingStyle(size: 16),
        titleSmall: premiumHeadingStyle(size: 14),
        bodyLarge: premiumBody3D(size: 15),
        bodyMedium: premiumBody3D(size: 13),
        bodySmall: premiumBody3D(size: 11),
      ),

      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: _PremiumPageTransitionsBuilder(),
          TargetPlatform.iOS: _PremiumPageTransitionsBuilder(),
          TargetPlatform.windows: _PremiumPageTransitionsBuilder(),
          TargetPlatform.macOS: _PremiumPageTransitionsBuilder(),
          TargetPlatform.linux: _PremiumPageTransitionsBuilder(),
        },
      ),
      cardTheme: CardThemeData(
        color: Colors.white.withOpacity(.94),
        elevation: 9,
        shadowColor: mainColor.withOpacity(.16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(26),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white.withOpacity(.94),
        prefixIconColor: mainColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(19),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(19),
          borderSide: const BorderSide(
            color: mainColor,
            width: 1.6,
          ),
        ),
      ),
    );
  }

  ThemeData darkTheme() {
    const darkBg = Color(0xFF081421);
    const darkSurface = Color(0xFF102235);
    const darkSurface2 = Color(0xFF153047);

    return ThemeData(
      primaryColor: mainColor,
      scaffoldBackgroundColor: darkBg,
      fontFamily: "Arial",
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: mainColor,
        brightness: Brightness.dark,
        surface: darkSurface,
      ),
      useMaterial3: true,
      textTheme: ThemeData.dark().textTheme.copyWith(
        displayLarge: const TextStyle(
          color: Colors.white,
          fontSize: 42,
          fontWeight: FontWeight.w900,
        ),
        headlineLarge: const TextStyle(
          color: Colors.white,
          fontSize: 32,
          fontWeight: FontWeight.w900,
        ),
        headlineMedium: const TextStyle(
          color: Colors.white,
          fontSize: 28,
          fontWeight: FontWeight.w900,
        ),
        headlineSmall: const TextStyle(
          color: Colors.white,
          fontSize: 23,
          fontWeight: FontWeight.w900,
        ),
        titleLarge: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w900,
        ),
        titleMedium: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w800,
        ),
        bodyLarge: const TextStyle(
          color: Color(0xFFDDE8F3),
        ),
        bodyMedium: const TextStyle(
          color: Color(0xFFB8C9D8),
        ),
        bodySmall: const TextStyle(
          color: Color(0xFF91A6BA),
        ),
      ),

      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: _PremiumPageTransitionsBuilder(),
          TargetPlatform.iOS: _PremiumPageTransitionsBuilder(),
          TargetPlatform.windows: _PremiumPageTransitionsBuilder(),
          TargetPlatform.macOS: _PremiumPageTransitionsBuilder(),
          TargetPlatform.linux: _PremiumPageTransitionsBuilder(),
        },
      ),
      cardTheme: CardThemeData(
        color: darkSurface.withOpacity(.96),
        elevation: 8,
        shadowColor: mainColor.withOpacity(.12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(26),
          side: BorderSide(
            color: Colors.white.withOpacity(.05),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: darkSurface2.withOpacity(.94),
        hintStyle: const TextStyle(
          color: Color(0xFF8EA5B9),
        ),
        labelStyle: const TextStyle(
          color: Color(0xFFD8E5EF),
        ),
        prefixIconColor: mainColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(19),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(19),
          borderSide: const BorderSide(
            color: mainColor,
            width: 1.6,
          ),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: mainColor,
        ),
      ),
      dividerColor: Colors.white.withOpacity(.08),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: appDarkMode,
      builder: (context, isDark, _) {
        return MaterialApp(
          title: "Pediatric Cry Care",
          debugShowCheckedModeBanner: false,
          theme: lightTheme(),
          darkTheme: darkTheme(),
          themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
          home: const PremiumSplashScreen(),
        );
      },
    );
  }
}



class _PremiumPageTransitionsBuilder extends PageTransitionsBuilder {
  const _PremiumPageTransitionsBuilder();

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    final curved = CurvedAnimation(
      parent: animation,
      curve: Curves.easeOutCubic,
      reverseCurve: Curves.easeInCubic,
    );

    return FadeTransition(
      opacity: curved,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(.035, .018),
          end: Offset.zero,
        ).animate(curved),
        child: ScaleTransition(
          scale: Tween<double>(
            begin: .985,
            end: 1,
          ).animate(curved),
          child: child,
        ),
      ),
    );
  }
}

/* ===================== PREMIUM EXPERIENCE HELPERS ===================== */

class PremiumSplashScreen extends StatefulWidget {
  const PremiumSplashScreen({super.key});

  @override
  State<PremiumSplashScreen> createState() => _PremiumSplashScreenState();
}

class _PremiumSplashScreenState extends State<PremiumSplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController controller;
  late final Animation<double> scale;
  late final Animation<double> fade;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1450),
    );

    scale = Tween<double>(
      begin: .78,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: Curves.easeOutBack,
      ),
    );

    fade = CurvedAnimation(
      parent: controller,
      curve: Curves.easeIn,
    );

    controller.forward();

    Future.delayed(
      const Duration(milliseconds: 1900),
      () {
        if (!mounted) return;

        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            transitionDuration:
                const Duration(milliseconds: 650),
            pageBuilder: (_, animation, __) =>
                const RoleScreen(),
            transitionsBuilder:
                (_, animation, __, child) {
              return FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, .035),
                    end: Offset.zero,
                  ).animate(
                    CurvedAnimation(
                      parent: animation,
                      curve: Curves.easeOutCubic,
                    ),
                  ),
                  child: child,
                ),
              );
            },
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFF2FFFF),
              Color(0xFFFDF8FF),
              Color(0xFFEAFBFF),
            ],
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              top: -80,
              left: -65,
              child: _splashCircle(
                220,
                mainColor.withOpacity(.10),
              ),
            ),
            Positioned(
              bottom: -70,
              right: -55,
              child: _splashCircle(
                210,
                softPink.withOpacity(.35),
              ),
            ),
            Center(
              child: FadeTransition(
                opacity: fade,
                child: ScaleTransition(
                  scale: scale,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 142,
                        height: 142,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: mainColor.withOpacity(.24),
                            width: 3,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: mainColor.withOpacity(.14),
                              blurRadius: 30,
                              spreadRadius: 8,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.child_care_rounded,
                          color: mainColor,
                          size: 72,
                        ),
                      ),
                      const SizedBox(height: 22),
                      const Text(
                        "Pediatric Cry Care",
                        style: TextStyle(
                          color: darkText,
                          fontSize: 31,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 7),
                      const Text(
                        "Smart infant health monitoring",
                        style: TextStyle(
                          color: Color(0xFF6E7A92),
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 25),
                      SizedBox(
                        width: 190,
                        child: LinearProgressIndicator(
                          minHeight: 4,
                          backgroundColor:
                              mainColor.withOpacity(.10),
                          color: mainColor,
                          borderRadius:
                              BorderRadius.circular(20),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _splashCircle(
    double size,
    Color color,
  ) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}

class FadeSlideIn extends StatefulWidget {
  final Widget child;
  final int delayMs;

  const FadeSlideIn({
    super.key,
    required this.child,
    this.delayMs = 0,
  });

  @override
  State<FadeSlideIn> createState() => _FadeSlideInState();
}

class _FadeSlideInState extends State<FadeSlideIn> {
  bool visible = false;

  @override
  void initState() {
    super.initState();

    Future.delayed(
      Duration(milliseconds: 70 + widget.delayMs),
      () {
        if (mounted) {
          setState(() => visible = true);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: visible ? 1 : 0,
      duration: const Duration(milliseconds: 450),
      curve: Curves.easeOut,
      child: AnimatedSlide(
        offset:
            visible ? Offset.zero : const Offset(0, .055),
        duration: const Duration(milliseconds: 450),
        curve: Curves.easeOutCubic,
        child: widget.child,
      ),
    );
  }
}

class HoverLift extends StatefulWidget {
  final Widget child;
  final double lift;

  const HoverLift({
    super.key,
    required this.child,
    this.lift = 5,
  });

  @override
  State<HoverLift> createState() => _HoverLiftState();
}

class _HoverLiftState extends State<HoverLift> {
  bool hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => hover = true),
      onExit: (_) => setState(() => hover = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 210),
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          boxShadow: hover
              ? [
                  BoxShadow(
                    color: mainColor.withOpacity(.18),
                    blurRadius: 26,
                    spreadRadius: 1.5,
                    offset: const Offset(0, 11),
                  ),
                  BoxShadow(
                    color: Colors.white.withOpacity(.85),
                    blurRadius: 7,
                    offset: const Offset(-2, -2),
                  ),
                ]
              : const [],
        ),
        child: AnimatedScale(
          scale: hover ? 1.025 : 1,
          duration: const Duration(milliseconds: 210),
          curve: Curves.easeOutCubic,
          child: AnimatedSlide(
            offset: hover ? const Offset(0, -.025) : Offset.zero,
            duration: const Duration(milliseconds: 210),
            curve: Curves.easeOutCubic,
            child: widget.child,
          ),
        ),
      ),
    );
  }
}

class SkeletonCard extends StatefulWidget {
  final double height;

  const SkeletonCard({
    super.key,
    this.height = 95,
  });

  @override
  State<SkeletonCard> createState() => _SkeletonCardState();
}

class _SkeletonCardState extends State<SkeletonCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController controller;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 950),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final opacity =
            .38 + controller.value * .28;

        return Container(
          height: widget.height,
          margin: const EdgeInsets.only(bottom: 11),
          decoration: BoxDecoration(
            color: const Color(0xFFE8EDF3)
                .withOpacity(opacity),
            borderRadius: BorderRadius.circular(21),
          ),
        );
      },
    );
  }
}

class PremiumEmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String? buttonText;
  final VoidCallback? onTap;
  final Color color;

  const PremiumEmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.buttonText,
    this.onTap,
    this.color = mainColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 26,
        vertical: 56,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.025),
            blurRadius: 12,
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 82,
            height: 82,
            decoration: BoxDecoration(
              color: color.withOpacity(.09),
              shape: BoxShape.circle,
              border: Border.all(
                color: color.withOpacity(.16),
              ),
            ),
            child: Icon(
              icon,
              color: color,
              size: 40,
            ),
          ),
          const SizedBox(height: 15),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: darkText,
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 11,
              height: 1.4,
            ),
          ),
          if (buttonText != null && onTap != null) ...[
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: onTap,
              icon: const Icon(
                Icons.arrow_forward_rounded,
                color: Colors.white,
                size: 18,
              ),
              label: Text(
                buttonText!,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: color,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(14),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class PremiumStatusPill extends StatelessWidget {
  final String text;
  final Color color;
  final IconData? icon;

  const PremiumStatusPill({
    super.key,
    required this.text,
    required this.color,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 9,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(.10),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              color: color,
              size: 13,
            ),
            const SizedBox(width: 4),
          ],
          Text(
            text,
            style: TextStyle(
              color: color,
              fontSize: 9.5,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

Future<void> showPremiumSuccess(
  BuildContext context, {
  required String title,
  required String message,
  IconData icon = Icons.check_rounded,
  Color color = successColor,
}) async {
  await showDialog<void>(
    context: context,
    builder: (dialogContext) {
      return Dialog(
        backgroundColor: Colors.transparent,
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: .78, end: 1),
          duration: const Duration(milliseconds: 330),
          curve: Curves.easeOutBack,
          builder: (context, value, child) {
            return Transform.scale(
              scale: value,
              child: child,
            );
          },
          child: Container(
            constraints:
                const BoxConstraints(maxWidth: 420),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(.16),
                  blurRadius: 28,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: color.withOpacity(.10),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: color.withOpacity(.20),
                      width: 2,
                    ),
                  ),
                  child: Icon(
                    icon,
                    color: color,
                    size: 39,
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: darkText,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 11.5,
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: 17),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () =>
                        Navigator.pop(dialogContext),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: color,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text(
                      "Done",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

/* ===================== BACKGROUND ===================== */

class BabyBg extends StatelessWidget {
  final Widget child;
  const BabyBg({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;

    final bgColors = dark
        ? const [
            Color(0xFF06111D),
            Color(0xFF0A1B2B),
            Color(0xFF10283B),
            Color(0xFF14223A),
          ]
        : const [
            Color(0xFFF7FDFF),
            Color(0xFFEAFBFF),
            Color(0xFFFFF7FB),
            Color(0xFFF3F1FF),
          ];

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: bgColors,
          stops: const [0, .42, .73, 1],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -110,
            left: -90,
            child: _orb(
              290,
              mainColor.withOpacity(dark ? .16 : .20),
            ),
          ),
          Positioned(
            top: 40,
            right: -100,
            child: _orb(
              250,
              (dark
                      ? const Color(0xFF8C5AE8)
                      : softPink)
                  .withOpacity(dark ? .12 : .45),
            ),
          ),
          Positioned(
            bottom: -120,
            left: 120,
            child: _orb(
              310,
              medicalBlue.withOpacity(dark ? .10 : .13),
            ),
          ),
          Positioned.fill(
            child: IgnorePointer(
              child: CustomPaint(
                painter: _AdaptiveMedicalGridPainter(
                  dark: dark,
                ),
              ),
            ),
          ),
          SafeArea(child: child),
        ],
      ),
    );
  }

  static Widget _orb(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            color,
            color.withOpacity(.25),
            color.withOpacity(0),
          ],
        ),
      ),
    );
  }
}

class _AdaptiveMedicalGridPainter extends CustomPainter {
  final bool dark;
  const _AdaptiveMedicalGridPainter({
    required this.dark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final grid = Paint()
      ..color = (dark ? Colors.white : mainColor)
          .withOpacity(dark ? .022 : .026)
      ..strokeWidth = .7;

    const step = 34.0;

    for (double x = 0; x <= size.width; x += step) {
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height),
        grid,
      );
    }

    for (double y = 0; y <= size.height; y += step) {
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        grid,
      );
    }

    final pulse = Paint()
      ..color = mainColor.withOpacity(dark ? .08 : .05)
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke;

    final y = size.height * .62;
    final path = Path()
      ..moveTo(0, y)
      ..lineTo(size.width * .14, y)
      ..lineTo(size.width * .17, y - 8)
      ..lineTo(size.width * .20, y + 25)
      ..lineTo(size.width * .24, y - 55)
      ..lineTo(size.width * .28, y)
      ..lineTo(size.width, y);

    canvas.drawPath(path, pulse);
  }

  @override
  bool shouldRepaint(
    covariant _AdaptiveMedicalGridPainter oldDelegate,
  ) => oldDelegate.dark != dark;
}

/* ===================== REUSABLE WIDGETS ===================== */

Widget mainButton(
  String text,
  IconData icon,
  VoidCallback onTap, {
  Color color = mainColor,
}) {
  return Container(
    width: double.infinity,
    height: 58,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(19),
      boxShadow: [
        BoxShadow(
          color: color.withOpacity(.32),
          blurRadius: 18,
          offset: const Offset(0, 9),
        ),
        BoxShadow(
          color: Colors.white.withOpacity(.95),
          blurRadius: 5,
          offset: const Offset(-2, -2),
        ),
      ],
    ),
    child: ElevatedButton.icon(
      onPressed: onTap,
      icon: Icon(
        icon,
        color: Colors.white,
        shadows: [
          Shadow(
            color: Colors.black.withOpacity(.20),
            offset: const Offset(0, 1.5),
            blurRadius: 2,
          ),
        ],
      ),
      label: Text(
        text,
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w900,
          letterSpacing: .1,
          shadows: [
            Shadow(
              color: Colors.black.withOpacity(.28),
              offset: const Offset(0, 1.8),
              blurRadius: 2.6,
            ),
            Shadow(
              color: Colors.white.withOpacity(.38),
              offset: const Offset(0, -.8),
              blurRadius: 1.2,
            ),
          ],
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(19),
          side: BorderSide(
            color: Colors.white.withOpacity(.38),
            width: 1.1,
          ),
        ),
      ),
    ),
  );
}

InputDecoration inputField(String hint, IconData icon) {
  return InputDecoration(
    prefixIcon: Icon(
      icon,
      color: mainColor,
      shadows: coloredGlow(mainColor, strength: .55),
    ),
    hintText: hint,
    hintStyle: premiumBody3D(
      size: 13,
      color: const Color(0xFF7D8CA0),
    ),
    filled: true,
    fillColor: Colors.white.withOpacity(.91),
    contentPadding:
        const EdgeInsets.symmetric(vertical: 17, horizontal: 18),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(19),
      borderSide: BorderSide(
        color: Colors.white.withOpacity(.98),
        width: 1.5,
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(19),
      borderSide: const BorderSide(
        color: mainColor,
        width: 1.6,
      ),
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(19),
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

// الاسم متساب زي القديم عشان ما نغيرش باقي الكود، لكن الصور Local Assets وليست Network.
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
      child: Image.asset(
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

  Widget roleCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required String badge,
    required IconData icon,
    required Color color,
    required Widget page,
  }) {
    return HoverLift(
      child: InkWell(
        onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => page),
        );
      },
      borderRadius: BorderRadius.circular(27),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(.95),
          borderRadius: BorderRadius.circular(27),
          border: Border.all(
            color: color.withOpacity(.12),
          ),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(.08),
              blurRadius: 22,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 68,
              height: 68,
              decoration: BoxDecoration(
                color: color.withOpacity(.10),
                shape: BoxShape.circle,
                border: Border.all(
                  color: color.withOpacity(.22),
                  width: 2,
                ),
              ),
              child: Center(
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    color: color,
                    size: 28,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          title,
                          style: const TextStyle(
                            color: darkText,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: color.withOpacity(.10),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          badge,
                          style: TextStyle(
                            color: color,
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 11.5,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_forward_rounded,
                color: Colors.white,
                size: 21,
              ),
            ),
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
        child: LayoutBuilder(
          builder: (context, constraints) {
            final wide = constraints.maxWidth > 850;

            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: wide ? 48 : 22,
                vertical: 30,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: 1050,
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(
                          wide ? 30 : 22,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(.93),
                          borderRadius: BorderRadius.circular(34),
                          border: Border.all(
                            color: Colors.white,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: mainColor.withOpacity(.08),
                              blurRadius: 28,
                              offset: const Offset(0, 12),
                            ),
                          ],
                        ),
                        child: Flex(
                          direction:
                              wide ? Axis.horizontal : Axis.vertical,
                          children: [
                            const SizedBox(
                              width: 215,
                              height: 205,
                              child: AnimatedBabyOrbit(),
                            ),
                            SizedBox(
                              width: wide ? 30 : 0,
                              height: wide ? 0 : 10,
                            ),
                            Expanded(
                              flex: wide ? 1 : 0,
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 11,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: mainColor.withOpacity(.09),
                                      borderRadius:
                                          BorderRadius.circular(20),
                                    ),
                                    child: const Text(
                                      "SMART PEDIATRIC CARE",
                                      style: TextStyle(
                                        color: mainColor,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: .8,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 13),
                                  const Text(
                                    "Pediatric Cry Care",
                                    style: TextStyle(
                                      color: darkText,
                                      fontSize: 36,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 7),
                                  const Text(
                                    "AI-assisted infant monitoring, live health signals and trusted pediatric consultation in one secure platform.",
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 14,
                                      height: 1.5,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Wrap(
                                    spacing: 8,
                                    runSpacing: 8,
                                    children: [
                                      _heroFeature(
                                        Icons.monitor_heart_rounded,
                                        "Live Monitoring",
                                        mainColor,
                                      ),
                                      _heroFeature(
                                        Icons.mic_rounded,
                                        "Cry Recording",
                                        const Color(0xFF2E8FF0),
                                      ),
                                      _heroFeature(
                                        Icons.verified_user_rounded,
                                        "Verified Doctors",
                                        successColor,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Choose your portal",
                          style: TextStyle(
                            color: darkText,
                            fontSize: 21,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),

                      roleCard(
                        context: context,
                        title: "Mother / User",
                        subtitle:
                            "Monitor your baby's health, record crying, chat with doctors and manage appointments.",
                        badge: "FAMILY CARE",
                        icon: Icons.family_restroom_rounded,
                        color: mainColor,
                        page: const LoginScreen(),
                      ),
                      const SizedBox(height: 12),
                      roleCard(
                        context: context,
                        title: "Doctor",
                        subtitle:
                            "Review consultations, communicate with mothers, manage appointments and patient health data.",
                        badge: "PEDIATRIC PORTAL",
                        icon: Icons.medical_services_rounded,
                        color: medicalBlue,
                        page: const DoctorGatewayScreen(),
                      ),
                      const SizedBox(height: 12),
                      roleCard(
                        context: context,
                        title: "Admin",
                        subtitle:
                            "Verify pediatric doctors, review requests and manage platform access securely.",
                        badge: "SYSTEM CONTROL",
                        icon: Icons.admin_panel_settings_rounded,
                        color: const Color(0xFF8E67DC),
                        page: const LoginScreen(expectedRole: 'admin'),
                      ),

                      const SizedBox(height: 20),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEFFBFC),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Row(
                          children: [
                            Icon(
                              Icons.shield_rounded,
                              color: mainColor,
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                "Secure Firebase authentication • Real-time Firestore data • Private mother-doctor communication",
                                style: TextStyle(
                                  color: darkText,
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  static Widget _heroFeature(
    IconData icon,
    String text,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 11,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(.08),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: color.withOpacity(.12),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: color,
            size: 16,
          ),
          const SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(
              color: color,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

/* ===================== LOGIN SCREEN ===================== */

class LoginScreen extends StatefulWidget {
  final String expectedRole;

  const LoginScreen({
    super.key,
    this.expectedRole = 'mother',
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool loading = false;

  Future<DocumentSnapshot<Map<String, dynamic>>?> _findDoctorProfile(
    String uid,
    String email,
  ) async {
    final byUid = await FirebaseFirestore.instance
        .collection('doctors')
        .doc(uid)
        .get();

    if (byUid.exists) return byUid;

    final query = await FirebaseFirestore.instance
        .collection('doctors')
        .where('email', isEqualTo: email)
        .limit(1)
        .get();

    if (query.docs.isNotEmpty) {
      return query.docs.first;
    }

    return null;
  }

  Future<DocumentSnapshot<Map<String, dynamic>>?> _findMotherProfile(
    String uid,
    String email,
  ) async {
    // Security rules allow a mother to read only /users/{own uid}.
    // Do NOT query the users collection by email here because that
    // collection query is intentionally blocked by Firestore rules.
    final byUid = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get();

    return byUid.exists ? byUid : null;
  }

  Future<void> login() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter email and password")),
      );
      return;
    }

    setState(() => loading = true);

    try {
      final credential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final uid = credential.user!.uid;

      if (widget.expectedRole == 'admin') {
        final adminDoc = await FirebaseFirestore.instance
            .collection('admins')
            .doc(uid)
            .get();

        if (!adminDoc.exists) {
          await FirebaseAuth.instance.signOut();
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("This account does not have admin permission"),
            ),
          );
          return;
        }

        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const AdminScreen(),
          ),
        );
        return;
      }

      if (widget.expectedRole == 'doctor') {
        final doctorDoc = await _findDoctorProfile(uid, email);

        if (doctorDoc == null || !doctorDoc.exists) {
          await FirebaseAuth.instance.signOut();
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Doctor profile was not found"),
            ),
          );
          return;
        }

        final doctor = doctorDoc.data()!;

        if (doctor['approved'] == true) {
          if (!mounted) return;
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => const DoctorDashboardScreen(),
            ),
          );
        } else {
          await FirebaseAuth.instance.signOut();
          if (!mounted) return;
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => const PendingApprovalScreen(),
            ),
          );
        }

        return;
      }

      final motherDoc = await _findMotherProfile(uid, email);

      // لو الحساب موجود في Authentication لكن مفيش Profile،
      // ننشئ Profile للأم تلقائياً عشان زميلك يقدر يدخل بعد Login.
      if (motherDoc == null || !motherDoc.exists) {
        await FirebaseFirestore.instance.collection('users').doc(uid).set({
          'email': email,
          'role': 'mother',
          'createdAt': FieldValue.serverTimestamp(),
        });
      } else {
        final motherData = motherDoc.data()!;
        final role = motherData['role']?.toString().toLowerCase();

        if (role != null && role != 'mother' && role != 'user') {
          await FirebaseAuth.instance.signOut();
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("This account is not registered as a mother"),
            ),
          );
          return;
        }
      }

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const MainNavigationScreen(),
        ),
      );
    } on FirebaseAuthException catch (e) {
      String message = "Wrong email or password";

      if (e.code == 'invalid-email') {
        message = "Invalid email";
      } else if (e.code == 'too-many-requests') {
        message = "Too many attempts. Please try again later.";
      } else if (e.code == 'network-request-failed') {
        message = "Network error. Check your internet connection.";
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Login error: $e")),
      );
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  Future<void> register() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Enter a valid email and password of at least 6 characters"),
        ),
      );
      return;
    }

    setState(() => loading = true);

    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await FirebaseFirestore.instance
          .collection('users')
          .doc(credential.user!.uid)
          .set({
        'email': email,
        'role': 'mother',
        'createdAt': FieldValue.serverTimestamp(),
      });

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const MainNavigationScreen(),
        ),
      );
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? "Registration failed")),
      );
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BabyBg(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final wide = constraints.maxWidth > 800;

            return Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: 980,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(.95),
                      borderRadius: BorderRadius.circular(32),
                      boxShadow: [
                        BoxShadow(
                          color: mainColor.withOpacity(.08),
                          blurRadius: 28,
                          offset: const Offset(0, 12),
                        ),
                      ],
                    ),
                    child: Flex(
                      direction:
                          wide ? Axis.horizontal : Axis.vertical,
                      children: [
                        Expanded(
                          flex: wide ? 5 : 0,
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(28),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: const Radius.circular(32),
                                bottomLeft: Radius.circular(
                                  wide ? 32 : 0,
                                ),
                                topRight: Radius.circular(
                                  wide ? 0 : 32,
                                ),
                              ),
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  mainColor.withOpacity(.13),
                                  const Color(0xFFEFFBFC),
                                  softPink.withOpacity(.32),
                                ],
                              ),
                            ),
                            child: const Column(
                              mainAxisAlignment:
                                  MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 190,
                                  height: 190,
                                  child: AnimatedBabyOrbit(),
                                ),
                                SizedBox(height: 12),
                                Text(
                                  "Welcome Back",
                                  style: TextStyle(
                                    color: darkText,
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 6),
                                Text(
                                  "Continue your baby's smart care journey.",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          flex: wide ? 6 : 0,
                          child: Padding(
                            padding: const EdgeInsets.all(28),
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                backButton(context),
                                const SizedBox(height: 5),
                                Text(
                                  widget.expectedRole == 'doctor'
                                      ? "Doctor Login"
                                      : widget.expectedRole == 'admin'
                                          ? "Admin Login"
                                          : "Mother Login",
                                  style: const TextStyle(
                                    color: darkText,
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  widget.expectedRole == 'doctor'
                                      ? "Login securely to your pediatric clinical dashboard."
                                      : widget.expectedRole == 'admin'
                                          ? "Login securely to the system administration dashboard."
                                          : "Login securely to your family care dashboard.",
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(height: 22),
                                TextField(
                                  controller: emailController,
                                  decoration: inputField(
                                    "Email",
                                    Icons.email_outlined,
                                  ),
                                ),
                                const SizedBox(height: 13),
                                TextField(
                                  controller: passwordController,
                                  obscureText: true,
                                  decoration: inputField(
                                    "Password",
                                    Icons.lock_outline_rounded,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                mainButton(
                                  "Login to Dashboard",
                                  Icons.login_rounded,
                                  login,
                                ),
                                const SizedBox(height: 9),
                                if (widget.expectedRole == 'mother')
                                  SizedBox(
                                    width: double.infinity,
                                    child: OutlinedButton.icon(
                                      onPressed: register,
                                      icon: const Icon(
                                        Icons.person_add_alt_1_rounded,
                                        color: mainColor,
                                      ),
                                      label: const Text(
                                        "Create New Account",
                                        style: TextStyle(
                                          color: mainColor,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      style: OutlinedButton.styleFrom(
                                        minimumSize:
                                            const Size.fromHeight(52),
                                        side: BorderSide(
                                          color:
                                              mainColor.withOpacity(.28),
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(17),
                                        ),
                                      ),
                                    ),
                                  ),
                                const SizedBox(height: 14),
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF6F8FC),
                                    borderRadius:
                                        BorderRadius.circular(16),
                                  ),
                                  child: const Row(
                                    children: [
                                      Icon(
                                        Icons.verified_user_outlined,
                                        color: successColor,
                                        size: 18,
                                      ),
                                      SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          "Your account is protected with Firebase authentication and secured data rules.",
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 9.5,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
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
          },
        ),
      ),
    );
  }
}

/* ===================== MAIN NAVIGATION ===================== */

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() =>
      _MainNavigationScreenState();
}

class _MainNavigationScreenState
    extends State<MainNavigationScreen> {
  int index = 0;

  Widget badgeIcon(
    IconData icon,
    int count, {
    Color? selectedColor,
  }) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Icon(
          icon,
          color: selectedColor,
        ),
        if (count > 0)
          Positioned(
            right: -9,
            top: -7,
            child: Container(
              constraints: const BoxConstraints(
                minWidth: 19,
                minHeight: 19,
              ),
              padding:
                  const EdgeInsets.symmetric(horizontal: 4),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: const Color(0xFFFF365C),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.white,
                  width: 2,
                ),
              ),
              child: Text(
                count > 9 ? "9+" : count.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 8.5,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget sidebarItem({
    required IconData icon,
    required String label,
    required bool selected,
    required VoidCallback onTap,
    int badge = 0,
  }) {
    return HoverLift(
      lift: 3,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(17),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          margin: const EdgeInsets.only(bottom: 7),
          padding: const EdgeInsets.symmetric(
            horizontal: 13,
            vertical: 12,
          ),
          decoration: BoxDecoration(
            gradient: selected
                ? LinearGradient(
                    colors: [
                      mainColor.withOpacity(.18),
                      medicalBlue.withOpacity(.08),
                    ],
                  )
                : null,
            color: selected ? null : Colors.transparent,
            borderRadius: BorderRadius.circular(17),
            border: Border.all(
              color: selected
                  ? mainColor.withOpacity(.15)
                  : Colors.transparent,
            ),
            boxShadow: selected
                ? [
                    BoxShadow(
                      color: mainColor.withOpacity(.12),
                      blurRadius: 14,
                      offset: const Offset(0, 6),
                    ),
                  ]
                : const [],
          ),
          child: Row(
            children: [
              badgeIcon(
                icon,
                badge,
                selectedColor:
                    selected ? mainColor : const Color(0xFF74809F),
              ),
              const SizedBox(width: 11),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    color: selected
                        ? mainColor
                        : const Color(0xFF59647E),
                    fontSize: 11.5,
                    fontWeight: selected
                        ? FontWeight.bold
                        : FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget desktopSidebar({
    required BuildContext context,
    required int chatCount,
    required int unreadAlerts,
  }) {
    return Container(
      width: 232,
      margin: const EdgeInsets.fromLTRB(14, 14, 0, 14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(.96),
            const Color(0xFFF0FCFF).withOpacity(.95),
            const Color(0xFFFFF5FA).withOpacity(.92),
          ],
        ),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: Colors.white.withOpacity(.95),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: mainColor.withOpacity(.13),
            blurRadius: 30,
            offset: const Offset(0, 14),
          ),
          BoxShadow(
            color: Colors.white.withOpacity(.95),
            blurRadius: 7,
            offset: const Offset(-3, -3),
          ),
        ],
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 18, 16, 18),
          child: Column(
            children: [
              Container(
                width: 94,
                height: 94,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFFCAFFFF),
                      Color(0xFFF7D9FF),
                      Color(0xFFFFE4ED),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: mainColor.withOpacity(.28),
                      blurRadius: 25,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(5),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(.92),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white,
                      width: 2,
                    ),
                  ),
                  child: const Icon(
                    Icons.child_care_rounded,
                    color: mainColor,
                    size: 50,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                "Pediatric\nCry Care",
                textAlign: TextAlign.center,
                style: premiumHeadingStyle(size: 22),
              ),
              const SizedBox(height: 5),
              Text(
                "Baby • Medical • AI",
                style: premiumBody3D(
                  size: 10,
                  color: const Color(0xFF66758C),
                  weight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 17),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 11,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: successColor.withOpacity(.08),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: successColor.withOpacity(.15),
                  ),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.circle,
                      size: 8,
                      color: successColor,
                    ),
                    SizedBox(width: 6),
                    Text(
                      "LIVE CARE SYSTEM",
                      style: TextStyle(
                        color: successColor,
                        fontSize: 8.5,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              sidebarItem(
                icon: Icons.home_rounded,
                label: "Home",
                selected: index == 0,
                onTap: () => setState(() => index = 0),
              ),
              sidebarItem(
                icon: Icons.face_rounded,
                label: "Infant Profile",
                selected: index == 1,
                onTap: () => setState(() => index = 1),
              ),
              sidebarItem(
                icon: Icons.monitor_heart_rounded,
                label: "Monitoring",
                selected: index == 2,
                onTap: () => setState(() => index = 2),
              ),
              sidebarItem(
                icon: Icons.forum_rounded,
                label: "Consult",
                selected: index == 3,
                badge: chatCount,
                onTap: () => setState(() => index = 3),
              ),
              sidebarItem(
                icon: Icons.calendar_month_rounded,
                label: "Appointments",
                selected: false,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const AppointmentScreen(),
                    ),
                  );
                },
              ),
              sidebarItem(
                icon: Icons.description_rounded,
                label: "Medical Report",
                selected: false,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const MedicalReportScreen(),
                    ),
                  );
                },
              ),
              sidebarItem(
                icon: Icons.notifications_active_rounded,
                label: "Alerts",
                selected: index == 4,
                badge: unreadAlerts,
                onTap: () => setState(() => index = 4),
              ),

              const SizedBox(height: 18),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(13),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      mainColor.withOpacity(.11),
                      const Color(0xFF9A7BEF).withOpacity(.08),
                      softPink.withOpacity(.17),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(
                    color: Colors.white.withOpacity(.92),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: mainColor.withOpacity(.09),
                      blurRadius: 15,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Icon(
                      Icons.health_and_safety_rounded,
                      color: mainColor,
                      size: 27,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "Baby Status",
                      style: premiumHeadingStyle(size: 12),
                    ),
                    const SizedBox(height: 3),
                    const Text(
                      "♥ Healthy",
                      style: TextStyle(
                        color: successColor,
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      "All monitored signals look normal",
                      textAlign: TextAlign.center,
                      style: premiumBody3D(
                        size: 8,
                        color: const Color(0xFF66758C),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    final screens = [
      HomeScreen(
        onTabSelected: (i) =>
            setState(() => index = i),
      ),
      const InfantProfileScreen(),
      const HistoryScreen(),
      const SubscriptionScreen(),
      const NotificationsScreen(),
    ];

    if (user == null) {
      return Scaffold(
        body: screens[index],
      );
    }

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('notifications')
          .where('userId', isEqualTo: user.uid)
          .snapshots(),
      builder: (context, alertSnapshot) {
        final unreadAlerts =
            alertSnapshot.data?.docs.where((doc) {
                  final data =
                      doc.data() as Map<String, dynamic>;
                  return data['isRead'] != true;
                }).length ??
                0;

        return StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('chat_rooms')
              .where(
                'participants',
                arrayContains: user.uid,
              )
              .snapshots(),
          builder: (context, chatSnapshot) {
            final chatCount =
                chatSnapshot.data?.docs.length ?? 0;

            return LayoutBuilder(
              builder: (context, constraints) {
                final desktop =
                    constraints.maxWidth >= 900;

                if (desktop) {
                  return Scaffold(
                    body: Row(
                      children: [
                        desktopSidebar(
                          context: context,
                          chatCount: chatCount,
                          unreadAlerts: unreadAlerts,
                        ),
                        Expanded(
                          child: AnimatedSwitcher(
                            duration: const Duration(
                              milliseconds: 280,
                            ),
                            switchInCurve:
                                Curves.easeOutCubic,
                            child: KeyedSubtree(
                              key: ValueKey(index),
                              child: screens[index],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return Scaffold(
                  body: AnimatedSwitcher(
                    duration:
                        const Duration(milliseconds: 250),
                    child: KeyedSubtree(
                      key: ValueKey(index),
                      child: screens[index],
                    ),
                  ),
                  bottomNavigationBar: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color:
                              Colors.black.withOpacity(.05),
                          blurRadius: 20,
                          offset: const Offset(0, -5),
                        ),
                      ],
                    ),
                    child: NavigationBar(
                      height: 70,
                      backgroundColor: Colors.white,
                      indicatorColor:
                          mainColor.withOpacity(.11),
                      selectedIndex: index,
                      onDestinationSelected: (v) {
                        setState(() => index = v);
                      },
                      destinations: [
                        const NavigationDestination(
                          icon:
                              Icon(Icons.home_outlined),
                          selectedIcon: Icon(
                            Icons.home_rounded,
                            color: mainColor,
                          ),
                          label: "Home",
                        ),
                        const NavigationDestination(
                          icon: Icon(
                            Icons.person_outline_rounded,
                          ),
                          selectedIcon: Icon(
                            Icons.person_rounded,
                            color: mainColor,
                          ),
                          label: "Profile",
                        ),
                        const NavigationDestination(
                          icon:
                              Icon(Icons.history_rounded),
                          selectedIcon: Icon(
                            Icons.history_rounded,
                            color: mainColor,
                          ),
                          label: "History",
                        ),
                        NavigationDestination(
                          icon: badgeIcon(
                            Icons
                                .chat_bubble_outline_rounded,
                            chatCount,
                          ),
                          selectedIcon: badgeIcon(
                            Icons.chat_bubble_rounded,
                            chatCount,
                            selectedColor: mainColor,
                          ),
                          label: "Consult",
                        ),
                        NavigationDestination(
                          icon: badgeIcon(
                            Icons
                                .notifications_none_rounded,
                            unreadAlerts,
                          ),
                          selectedIcon: badgeIcon(
                            Icons.notifications_rounded,
                            unreadAlerts,
                            selectedColor: mainColor,
                          ),
                          label: "Alerts",
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}


/* ===================== PEDIATRIC WOW LAYER ===================== */


class BabyHealthScoreCard extends StatefulWidget {
  const BabyHealthScoreCard({super.key});

  @override
  State<BabyHealthScoreCard> createState() =>
      _BabyHealthScoreCardState();
}

class _BabyHealthScoreCardState extends State<BabyHealthScoreCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return HoverLift(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFF2FFFD),
              Colors.white,
              Color(0xFFF5F2FF),
            ],
          ),
          borderRadius: BorderRadius.circular(29),
          border: Border.all(color: Colors.white, width: 1.5),
          boxShadow: [
            BoxShadow(
              color: successColor.withOpacity(.13),
              blurRadius: 28,
              offset: const Offset(0, 13),
            ),
          ],
        ),
        child: Row(
          children: [
            AnimatedBuilder(
              animation: controller,
              builder: (context, _) {
                final score = 92 * controller.value;
                return SizedBox(
                  width: 116,
                  height: 116,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 108,
                        height: 108,
                        child: CircularProgressIndicator(
                          value: .92 * controller.value,
                          strokeWidth: 9,
                          backgroundColor:
                              successColor.withOpacity(.09),
                          valueColor:
                              const AlwaysStoppedAnimation<Color>(
                            successColor,
                          ),
                          strokeCap: StrokeCap.round,
                        ),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            score.toStringAsFixed(0),
                            style: premiumMetricStyle(
                              size: 31,
                              color: successColor,
                            ),
                          ),
                          Text(
                            "/ 100",
                            style: premiumBody3D(
                              size: 9,
                              color: const Color(0xFF758398),
                              weight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(width: 17),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Baby Health Score",
                    style: premiumHeadingStyle(size: 18),
                  ),
                  const SizedBox(height: 4),
                  const PremiumStatusPill(
                    text: "EXCELLENT",
                    color: successColor,
                    icon: Icons.verified_rounded,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Heart, temperature and recent monitoring signals look stable.",
                    style: premiumBody3D(
                      size: 9.5,
                      color: const Color(0xFF66758C),
                    ),
                  ),
                  const SizedBox(height: 9),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: const LinearProgressIndicator(
                      value: .92,
                      minHeight: 6,
                      backgroundColor: Color(0xFFE9F5F2),
                      valueColor:
                          AlwaysStoppedAnimation<Color>(successColor),
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

class SmartMedicalTimelineCard extends StatelessWidget {
  const SmartMedicalTimelineCard({super.key});

  Widget event(
    IconData icon,
    String title,
    String subtitle,
    Color color,
    bool last,
  ) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 36,
            child: Column(
              children: [
                Container(
                  width: 31,
                  height: 31,
                  decoration: BoxDecoration(
                    color: color.withOpacity(.11),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 1.4),
                    boxShadow: [
                      BoxShadow(
                        color: color.withOpacity(.16),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: Icon(icon, color: color, size: 16),
                ),
                if (!last)
                  Expanded(
                    child: Container(
                      width: 2,
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      color: mainColor.withOpacity(.10),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 9),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 13),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: premiumBody3D(
                      size: 10.5,
                      color: darkText,
                      weight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: premiumBody3D(
                      size: 8.5,
                      color: const Color(0xFF7C899B),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return HoverLift(
      child: Container(
        padding: const EdgeInsets.all(19),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(.94),
          borderRadius: BorderRadius.circular(29),
          border: Border.all(color: Colors.white, width: 1.5),
          boxShadow: [
            BoxShadow(
              color: medicalBlue.withOpacity(.10),
              blurRadius: 25,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.timeline_rounded,
                  color: medicalBlue,
                  size: 21,
                ),
                const SizedBox(width: 7),
                Text(
                  "Smart Care Timeline",
                  style: premiumHeadingStyle(size: 17),
                ),
                const Spacer(),
                const PremiumStatusPill(
                  text: "TODAY",
                  color: medicalBlue,
                  icon: Icons.schedule_rounded,
                ),
              ],
            ),
            const SizedBox(height: 15),
            event(
              Icons.favorite_rounded,
              "Vital signs updated",
              "Heart and temperature monitoring • just now",
              const Color(0xFFFF5A7D),
              false,
            ),
            event(
              Icons.graphic_eq_rounded,
              "Cry intelligence ready",
              "AI engine is ready for a new recording",
              const Color(0xFF7B61E8),
              false,
            ),
            event(
              Icons.restaurant_rounded,
              "Feeding profile available",
              "Last feeding data synced with baby profile",
              warningColor,
              true,
            ),
          ],
        ),
      ),
    );
  }
}

class PediatricAiInsightCard extends StatelessWidget {
  const PediatricAiInsightCard({super.key});

  @override
  Widget build(BuildContext context) {
    return HoverLift(
      child: Container(
        padding: const EdgeInsets.all(19),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color(0xFF172A45),
              const Color(0xFF203D5C),
              mainColor.withOpacity(.88),
            ],
          ),
          borderRadius: BorderRadius.circular(29),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF172A45).withOpacity(.22),
              blurRadius: 29,
              offset: const Offset(0, 13),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              right: -25,
              top: -30,
              child: Icon(
                Icons.psychology_alt_rounded,
                color: Colors.white.withOpacity(.07),
                size: 150,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(
                      Icons.auto_awesome_rounded,
                      color: Color(0xFFFFD166),
                      size: 20,
                    ),
                    SizedBox(width: 7),
                    Text(
                      "AI Pediatric Insight",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w900,
                        shadows: [
                          Shadow(
                            color: Colors.black26,
                            offset: Offset(0, 2),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                    ),
                    Spacer(),
                    PremiumStatusPill(
                      text: "AI",
                      color: Color(0xFF7B61E8),
                      icon: Icons.psychology_rounded,
                    ),
                  ],
                ),
                const SizedBox(height: 13),
                Text(
                  "Current connected signals appear stable. Continue routine monitoring and use Cry AI when the baby becomes unsettled.",
                  style: TextStyle(
                    color: Colors.white.withOpacity(.90),
                    fontSize: 10.5,
                    height: 1.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 13),
                Container(
                  padding: const EdgeInsets.all(11),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(.10),
                    borderRadius: BorderRadius.circular(17),
                    border: Border.all(
                      color: Colors.white.withOpacity(.13),
                    ),
                  ),
                  child: const Row(
                    children: [
                      Icon(
                        Icons.info_outline_rounded,
                        color: Colors.white70,
                        size: 17,
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          "AI guidance supports care decisions and does not replace a pediatric diagnosis.",
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 8.5,
                            height: 1.35,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class MedicalModePreviewCard extends StatelessWidget {
  const MedicalModePreviewCard({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: appDarkMode,
      builder: (context, dark, _) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 420),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: dark
                  ? const [
                      Color(0xFF091827),
                      Color(0xFF102A40),
                      Color(0xFF16424C),
                    ]
                  : const [
                      Color(0xFFF5FDFF),
                      Colors.white,
                      Color(0xFFF7F3FF),
                    ],
            ),
            borderRadius: BorderRadius.circular(29),
            border: Border.all(
              color: dark
                  ? Colors.white.withOpacity(.07)
                  : Colors.white,
            ),
            boxShadow: [
              BoxShadow(
                color: mainColor.withOpacity(.14),
                blurRadius: 25,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: mainColor.withOpacity(.12),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: mainColor.withOpacity(.22),
                      blurRadius: 15,
                    ),
                  ],
                ),
                child: Icon(
                  dark
                      ? Icons.dark_mode_rounded
                      : Icons.light_mode_rounded,
                  color: dark ? mainColor : warningColor,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      dark
                          ? "Dark Medical Mode"
                          : "Clinical Light Mode",
                      style: TextStyle(
                        color: dark ? Colors.white : darkText,
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      dark
                          ? "Dark theme is active across the application"
                          : "Switch the full application to clinical dark mode",
                      style: TextStyle(
                        color: dark
                            ? Colors.white60
                            : const Color(0xFF758398),
                        fontSize: 9,
                      ),
                    ),
                  ],
                ),
              ),
              Switch(
                value: dark,
                activeColor: mainColor,
                onChanged: (v) {
                  appDarkMode.value = v;
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class PediatricDigitalTwinCard extends StatefulWidget {
  final VoidCallback? onCryTap;
  final VoidCallback? onVitalsTap;

  const PediatricDigitalTwinCard({
    super.key,
    this.onCryTap,
    this.onVitalsTap,
  });

  @override
  State<PediatricDigitalTwinCard> createState() =>
      _PediatricDigitalTwinCardState();
}

class _PediatricDigitalTwinCardState
    extends State<PediatricDigitalTwinCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 9),
    )..repeat();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Widget signalNode(
    IconData icon,
    String label,
    Color color,
    double angle,
    double rotation,
  ) {
    final a = angle + rotation;
    return Transform.translate(
      offset: Offset(
        math.cos(a) * 112,
        math.sin(a) * 112,
      ),
      child: Container(
        width: 49,
        height: 49,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.white,
              color.withOpacity(.10),
            ],
          ),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 1.7),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(.25),
              blurRadius: 15,
              spreadRadius: .5,
            ),
          ],
        ),
        child: Tooltip(
          message: label,
          child: Icon(
            icon,
            color: color,
            size: 22,
            shadows: coloredGlow(color, strength: .7),
          ),
        ),
      ),
    );
  }

  Widget metric(
    IconData icon,
    String title,
    String value,
    Color color,
    VoidCallback? onTap,
  ) {
    return HoverLift(
      lift: 7,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(11),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.white,
                color.withOpacity(.045),
              ],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white, width: 1.3),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(.10),
                blurRadius: 14,
                offset: const Offset(0, 7),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 37,
                height: 37,
                decoration: BoxDecoration(
                  color: color.withOpacity(.10),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 18),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: premiumBody3D(
                        size: 8,
                        color: const Color(0xFF7A879A),
                      ),
                    ),
                    Text(
                      value,
                      style: premiumBody3D(
                        size: 10.5,
                        color: darkText,
                        weight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return HoverLift(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(21),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white,
              Color(0xFFF0FEFF),
              Color(0xFFFFF5FA),
              Color(0xFFF5F1FF),
            ],
          ),
          borderRadius: BorderRadius.circular(31),
          border: Border.all(color: Colors.white, width: 1.6),
          boxShadow: [
            BoxShadow(
              color: mainColor.withOpacity(.13),
              blurRadius: 31,
              offset: const Offset(0, 14),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 43,
                  height: 43,
                  decoration: BoxDecoration(
                    color: mainColor.withOpacity(.10),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: mainColor.withOpacity(.16),
                        blurRadius: 12,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.hub_rounded,
                    color: mainColor,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Baby Digital Twin 360°",
                        style: premiumHeadingStyle(size: 19),
                      ),
                      Text(
                        "One intelligent map for cry, vitals, feeding, sleep and risk",
                        style: premiumBody3D(
                          size: 9,
                          color: const Color(0xFF718095),
                        ),
                      ),
                    ],
                  ),
                ),
                const PremiumStatusPill(
                  text: "SYNCED",
                  color: successColor,
                  icon: Icons.sync_rounded,
                ),
              ],
            ),
            const SizedBox(height: 16),
            LayoutBuilder(
              builder: (context, c) {
                final wide = c.maxWidth > 720;
                final visual = AnimatedBuilder(
                  animation: controller,
                  builder: (context, _) {
                    final r = controller.value * math.pi * 2;
                    return SizedBox(
                      width: 285,
                      height: 285,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: 258,
                            height: 258,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: mainColor.withOpacity(.08),
                              ),
                            ),
                          ),
                          Container(
                            width: 218,
                            height: 218,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: const Color(0xFF7B61E8)
                                    .withOpacity(.10),
                                width: 1.4,
                              ),
                            ),
                          ),
                          Container(
                            width: 166,
                            height: 166,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [
                                  Color(0xFFE7FFFF),
                                  Colors.white,
                                  Color(0xFFFFEDF5),
                                ],
                              ),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white,
                                width: 3,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: mainColor.withOpacity(.23),
                                  blurRadius: 27,
                                  spreadRadius: 3,
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.child_care_rounded,
                              color: mainColor,
                              size: 82,
                            ),
                          ),
                          signalNode(
                            Icons.favorite_rounded,
                            "Heart",
                            const Color(0xFFFF5277),
                            0,
                            r,
                          ),
                          signalNode(
                            Icons.thermostat_rounded,
                            "Temperature",
                            const Color(0xFF8D55E7),
                            1.25,
                            r,
                          ),
                          signalNode(
                            Icons.graphic_eq_rounded,
                            "Cry AI",
                            const Color(0xFF7B61E8),
                            2.5,
                            r,
                          ),
                          signalNode(
                            Icons.restaurant_rounded,
                            "Feeding",
                            warningColor,
                            3.75,
                            r,
                          ),
                          signalNode(
                            Icons.bedtime_rounded,
                            "Sleep",
                            medicalBlue,
                            5,
                            r,
                          ),
                          Positioned(
                            bottom: 17,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 11,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(.94),
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: successColor.withOpacity(.13),
                                    blurRadius: 10,
                                  ),
                                ],
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.shield_rounded,
                                    color: successColor,
                                    size: 14,
                                  ),
                                  SizedBox(width: 5),
                                  Text(
                                    "LOW RISK",
                                    style: TextStyle(
                                      color: successColor,
                                      fontSize: 8,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );

                final data = GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 9,
                  crossAxisSpacing: 9,
                  childAspectRatio: 2.65,
                  children: [
                    metric(
                      Icons.favorite_rounded,
                      "Heart",
                      "Live signal",
                      const Color(0xFFFF5277),
                      widget.onVitalsTap,
                    ),
                    metric(
                      Icons.thermostat_rounded,
                      "Temperature",
                      "Live signal",
                      const Color(0xFF8D55E7),
                      widget.onVitalsTap,
                    ),
                    metric(
                      Icons.graphic_eq_rounded,
                      "Cry AI",
                      "Ready",
                      const Color(0xFF7B61E8),
                      widget.onCryTap,
                    ),
                    metric(
                      Icons.restaurant_rounded,
                      "Feeding",
                      "Tracked",
                      warningColor,
                      null,
                    ),
                    metric(
                      Icons.bedtime_rounded,
                      "Sleep",
                      "Monitoring",
                      medicalBlue,
                      null,
                    ),
                    metric(
                      Icons.shield_rounded,
                      "Risk",
                      "Low",
                      successColor,
                      null,
                    ),
                  ],
                );

                if (wide) {
                  return Row(
                    children: [
                      visual,
                      const SizedBox(width: 20),
                      Expanded(child: data),
                    ],
                  );
                }
                return Column(
                  children: [
                    visual,
                    const SizedBox(height: 12),
                    data,
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class AiCryInsightCard extends StatefulWidget {
  final VoidCallback onRecord;

  const AiCryInsightCard({
    super.key,
    required this.onRecord,
  });

  @override
  State<AiCryInsightCard> createState() =>
      _AiCryInsightCardState();
}

class _AiCryInsightCardState extends State<AiCryInsightCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController controller;
  int stage = 0;
  bool demoRunning = false;

  final stages = const [
    "AI READY",
    "LISTENING",
    "ANALYZING",
    "INSIGHT READY",
  ];

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 950),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<void> startDemo() async {
    if (demoRunning) return;
    setState(() {
      demoRunning = true;
      stage = 1;
    });
    await Future.delayed(const Duration(milliseconds: 850));
    if (!mounted) return;
    setState(() => stage = 2);
    await Future.delayed(const Duration(milliseconds: 850));
    if (!mounted) return;
    setState(() => stage = 3);
    await Future.delayed(const Duration(milliseconds: 650));
    if (!mounted) return;
    setState(() {
      demoRunning = false;
      stage = 0;
    });
    widget.onRecord();
  }

  @override
  Widget build(BuildContext context) {
    const purple = Color(0xFF7B61E8);

    return HoverLift(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFF6F2FF),
              Color(0xFFEDFBFF),
              Colors.white,
            ],
          ),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: Colors.white, width: 1.6),
          boxShadow: [
            BoxShadow(
              color: purple.withOpacity(.13),
              blurRadius: 29,
              offset: const Offset(0, 13),
            ),
          ],
        ),
        child: LayoutBuilder(
          builder: (context, c) {
            final wide = c.maxWidth > 700;

            final visual = AnimatedBuilder(
              animation: controller,
              builder: (context, _) {
                final v = controller.value;
                return SizedBox(
                  width: 235,
                  height: 190,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      for (int i = 0; i < 3; i++)
                        Container(
                          width: 120 + i * 30 + v * 9,
                          height: 120 + i * 30 + v * 9,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: purple.withOpacity(
                                .15 - i * .025,
                              ),
                              width: 1.5,
                            ),
                          ),
                        ),
                      Container(
                        width: 105,
                        height: 105,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFF8A6AF0),
                              Color(0xFF6750C8),
                            ],
                          ),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: purple.withOpacity(.35),
                              blurRadius: 25 + v * 10,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Icon(
                          stage == 1
                              ? Icons.mic_rounded
                              : stage == 2
                                  ? Icons.psychology_rounded
                                  : Icons.graphic_eq_rounded,
                          color: Colors.white,
                          size: 48,
                        ),
                      ),
                      Positioned(
                        bottom: 2,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 280),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 13,
                            vertical: 7,
                          ),
                          decoration: BoxDecoration(
                            color: stage == 3
                                ? successColor
                                : Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: purple.withOpacity(.14),
                                blurRadius: 12,
                              ),
                            ],
                          ),
                          child: Text(
                            stages[stage],
                            style: TextStyle(
                              color: stage == 3
                                  ? Colors.white
                                  : purple,
                              fontSize: 8.5,
                              fontWeight: FontWeight.w900,
                              letterSpacing: .5,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );

            final content = Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.psychology_alt_rounded,
                      color: purple,
                      size: 22,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "AI Cry Intelligence",
                      style: premiumHeadingStyle(size: 19),
                    ),
                    const Spacer(),
                    const PremiumStatusPill(
                      text: "NEURAL AI",
                      color: purple,
                      icon: Icons.auto_awesome_rounded,
                    ),
                  ],
                ),
                const SizedBox(height: 7),
                Text(
                  "Transform infant cry audio into a visual care insight with confidence, risk and recommended action.",
                  style: premiumBody3D(
                    size: 10,
                    color: const Color(0xFF66758C),
                  ),
                ),
                const SizedBox(height: 13),
                const Wrap(
                  spacing: 7,
                  runSpacing: 7,
                  children: [
                    PremiumStatusPill(
                      text: "Cry Class",
                      color: purple,
                      icon: Icons.category_rounded,
                    ),
                    PremiumStatusPill(
                      text: "Confidence",
                      color: medicalBlue,
                      icon: Icons.analytics_rounded,
                    ),
                    PremiumStatusPill(
                      text: "Risk",
                      color: successColor,
                      icon: Icons.shield_rounded,
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Container(
                  height: 54,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: purple.withOpacity(.045),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: purple.withOpacity(.07),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: List.generate(
                      22,
                      (i) {
                        final h = 8.0 +
                            ((i * 13) % 31) *
                                (.35 + controller.value * .35);
                        return Expanded(
                          child: Center(
                            child: AnimatedContainer(
                              duration:
                                  const Duration(milliseconds: 120),
                              width: 2.3,
                              height: h,
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 1),
                              decoration: BoxDecoration(
                                color: purple.withOpacity(
                                  demoRunning ? .75 : .30,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                SizedBox(
                  width: 215,
                  height: 48,
                  child: ElevatedButton.icon(
                    onPressed: demoRunning ? null : startDemo,
                    icon: Icon(
                      demoRunning
                          ? Icons.graphic_eq_rounded
                          : Icons.mic_rounded,
                      color: Colors.white,
                    ),
                    label: Text(
                      demoRunning
                          ? stages[stage]
                          : "Start AI Analysis",
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: purple,
                      disabledBackgroundColor:
                          purple.withOpacity(.72),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ),
              ],
            );

            if (wide) {
              return Row(
                children: [
                  visual,
                  const SizedBox(width: 22),
                  Expanded(child: content),
                ],
              );
            }
            return Column(
              children: [
                visual,
                const SizedBox(height: 10),
                content,
              ],
            );
          },
        ),
      ),
    );
  }
}

class ClinicalFocusCard extends StatelessWidget {
  final int conversations;
  final int pendingAppointments;
  final int confirmedAppointments;

  const ClinicalFocusCard({
    super.key,
    required this.conversations,
    required this.pendingAppointments,
    required this.confirmedAppointments,
  });

  Widget item(
    IconData icon,
    String title,
    String value,
    Color color,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: color.withOpacity(.09),
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: color,
              size: 22,
            ),
            const SizedBox(height: 6),
            Text(
              value,
              style: TextStyle(
                color: color,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: darkText,
                fontSize: 9,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            medicalBlue.withOpacity(.09),
            mainColor.withOpacity(.06),
            Colors.white,
          ],
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.radar_rounded,
                color: medicalBlue,
              ),
              SizedBox(width: 7),
              Text(
                "Clinical Focus",
                style: TextStyle(
                  color: darkText,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Spacer(),
              PremiumStatusPill(
                text: "LIVE WORKSPACE",
                color: medicalBlue,
              ),
            ],
          ),
          const SizedBox(height: 6),
          const Text(
            "A quick pediatric overview of communication and appointment workload.",
            style: TextStyle(
              color: Colors.grey,
              fontSize: 10,
            ),
          ),
          const SizedBox(height: 13),
          Row(
            children: [
              item(
                Icons.forum_rounded,
                "Active Chats",
                conversations.toString(),
                medicalBlue,
              ),
              const SizedBox(width: 8),
              item(
                Icons.pending_actions_rounded,
                "Needs Review",
                pendingAppointments.toString(),
                warningColor,
              ),
              const SizedBox(width: 8),
              item(
                Icons.verified_rounded,
                "Confirmed",
                confirmedAppointments.toString(),
                successColor,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class AdminEcosystemCard extends StatelessWidget {
  final int mothers;
  final int doctors;
  final int pendingDoctors;

  const AdminEcosystemCard({
    super.key,
    required this.mothers,
    required this.doctors,
    required this.pendingDoctors,
  });

  Widget bubble({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: color.withOpacity(.10),
          ),
        ),
        child: Column(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: color.withOpacity(.09),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: color,
                size: 21,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              value,
              style: TextStyle(
                color: color,
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: darkText,
                fontSize: 9,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF8E67DC)
                .withOpacity(.09),
            medicalBlue.withOpacity(.06),
            Colors.white,
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color:
              const Color(0xFF8E67DC).withOpacity(.08),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.account_tree_rounded,
                color: Color(0xFF8E67DC),
              ),
              SizedBox(width: 7),
              Text(
                "Live Care Ecosystem",
                style: TextStyle(
                  color: darkText,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Spacer(),
              PremiumStatusPill(
                text: "SYSTEM HEALTHY",
                color: successColor,
                icon: Icons.check_circle,
              ),
            ],
          ),
          const SizedBox(height: 6),
          const Text(
            "A visual snapshot of the pediatric care network connected through Firebase.",
            style: TextStyle(
              color: Colors.grey,
              fontSize: 10,
            ),
          ),
          const SizedBox(height: 13),
          Row(
            children: [
              bubble(
                icon: Icons.family_restroom_rounded,
                value: mothers.toString(),
                label: "Mothers",
                color: mainColor,
              ),
              const SizedBox(width: 8),
              bubble(
                icon: Icons.medical_services_rounded,
                value: doctors.toString(),
                label: "Doctors",
                color: medicalBlue,
              ),
              const SizedBox(width: 8),
              bubble(
                icon: Icons.pending_actions_rounded,
                value: pendingDoctors.toString(),
                label: "Approvals",
                color: warningColor,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/* ===================== PREMIUM HOME SCREEN ===================== */

class HomeScreen extends StatelessWidget {
  final Function(int) onTabSelected;

  const HomeScreen({
    super.key,
    required this.onTabSelected,
  });

  Stream<int> chatCount(String uid) {
    return FirebaseFirestore.instance
        .collection('chat_rooms')
        .where('participants', arrayContains: uid)
        .snapshots()
        .map((s) => s.docs.length);
  }

  Stream<int> appointmentCount(String uid) {
    return FirebaseFirestore.instance
        .collection('appointments')
        .where('motherUid', isEqualTo: uid)
        .snapshots()
        .map((s) => s.docs.where((doc) {
              final d = doc.data();
              return d['status'] == 'Pending' ||
                  d['status'] == 'Confirmed';
            }).length);
  }

  Widget infoChip(
    IconData icon,
    String label,
    String value,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.80),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Colors.white.withOpacity(.96),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(.08),
            blurRadius: 12,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: color.withOpacity(.10),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: color,
              size: 16,
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: premiumBody3D(
                  size: 8,
                  color: const Color(0xFF8190A5),
                ),
              ),
              Text(
                value,
                style: premiumBody3D(
                  size: 10,
                  color: darkText,
                  weight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget quickAction({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
    int badge = 0,
  }) {
    return HoverLift(
      lift: 8,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(27),
        child: Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withOpacity(.98),
                color.withOpacity(.055),
              ],
            ),
            borderRadius: BorderRadius.circular(27),
            border: Border.all(
              color: Colors.white.withOpacity(.98),
              width: 1.4,
            ),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(.14),
                blurRadius: 22,
                offset: const Offset(0, 11),
              ),
            ],
          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          color.withOpacity(.19),
                          Colors.white,
                        ],
                      ),
                      border: Border.all(
                        color: Colors.white,
                        width: 1.6,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: color.withOpacity(.23),
                          blurRadius: 18,
                        ),
                      ],
                    ),
                    child: Icon(
                      icon,
                      color: color,
                      size: 29,
                      shadows: coloredGlow(
                        color,
                        strength: .65,
                      ),
                    ),
                  ),
                  const SizedBox(height: 11),
                  Text(
                    title,
                    style: premiumHeadingStyle(size: 13),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: premiumBody3D(
                      size: 9,
                      color: const Color(0xFF66758C),
                    ),
                  ),
                  const Spacer(),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Text(
                        "Open",
                        style: premiumBody3D(
                          size: 9.5,
                          color: color,
                          weight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.arrow_forward_rounded,
                        color: color,
                        size: 15,
                      ),
                    ],
                  ),
                ],
              ),
              if (badge > 0)
                Positioned(
                  right: -4,
                  top: -5,
                  child: Container(
                    constraints: const BoxConstraints(
                      minWidth: 23,
                      minHeight: 23,
                    ),
                    alignment: Alignment.center,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF365C),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white,
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFFF365C)
                              .withOpacity(.35),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    child: Text(
                      badge > 9 ? "9+" : "$badge",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 8,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final uid = user?.uid ?? "";

    return BabyBg(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 36),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1180),
            child: StreamBuilder<
                DocumentSnapshot<Map<String, dynamic>>>(
              stream: uid.isEmpty
                  ? const Stream.empty()
                  : FirebaseFirestore.instance
                      .collection('infant_profiles')
                      .doc(uid)
                      .snapshots(),
              builder: (context, profileSnap) {
                final d = profileSnap.data?.data() ?? {};
                final babyName =
                    d['babyName']?.toString().trim().isNotEmpty == true
                        ? d['babyName'].toString()
                        : "Baby";
                final age =
                    d['ageMonths']?.toString().trim().isNotEmpty == true
                        ? "${d['ageMonths']} Months"
                        : "--";
                final weight =
                    d['weightKg']?.toString().trim().isNotEmpty == true
                        ? "${d['weightKg']} kg"
                        : "--";
                final feeding =
                    d['lastFeedingTime']?.toString() ?? "--";
                final gender = d['gender']?.toString() ?? "--";

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // --- premium top bar ---
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Good morning, Mom 🌸",
                                style: premiumHeadingStyle(size: 32),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                "Your baby's intelligent health command center",
                                style: premiumBody3D(
                                  size: 12,
                                  color: const Color(0xFF66758C),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 9,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(.78),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.white.withOpacity(.95),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: mainColor.withOpacity(.08),
                                blurRadius: 15,
                              ),
                            ],
                          ),
                          child: const Row(
                            children: [
                              Icon(
                                Icons.circle,
                                color: successColor,
                                size: 9,
                              ),
                              SizedBox(width: 7),
                              Text(
                                "ALL SYSTEMS NORMAL",
                                style: TextStyle(
                                  color: successColor,
                                  fontSize: 9,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),

                    // --- dominant baby hero ---
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(22),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.white.withOpacity(.94),
                            const Color(0xFFECFEFF).withOpacity(.90),
                            const Color(0xFFFFF4F9).withOpacity(.92),
                            const Color(0xFFF6F1FF).withOpacity(.88),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(34),
                        border: Border.all(
                          color: Colors.white.withOpacity(.98),
                          width: 1.7,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: mainColor.withOpacity(.13),
                            blurRadius: 34,
                            spreadRadius: 1,
                            offset: const Offset(0, 16),
                          ),
                          BoxShadow(
                            color: Colors.white.withOpacity(.95),
                            blurRadius: 8,
                            offset: const Offset(-3, -3),
                          ),
                        ],
                      ),
                      child: LayoutBuilder(
                        builder: (context, c) {
                          final wide = c.maxWidth > 780;

                          final orbit = SizedBox(
                            width: 285,
                            height: 265,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Container(
                                  width: 245,
                                  height: 245,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: SweepGradient(
                                      colors: [
                                        mainColor.withOpacity(.18),
                                        const Color(0xFF9A7BEF)
                                            .withOpacity(.22),
                                        softPink.withOpacity(.25),
                                        mainColor.withOpacity(.18),
                                      ],
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color:
                                            mainColor.withOpacity(.18),
                                        blurRadius: 30,
                                        spreadRadius: 3,
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  width: 205,
                                  height: 205,
                                  decoration: BoxDecoration(
                                    color:
                                        Colors.white.withOpacity(.90),
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 2,
                                    ),
                                  ),
                                  child: const Icon(
                                    Icons.child_care_rounded,
                                    color: mainColor,
                                    size: 98,
                                  ),
                                ),
                                Positioned(
                                  right: 12,
                                  bottom: 32,
                                  child: Container(
                                    width: 58,
                                    height: 58,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFFF5A7D),
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Colors.white,
                                        width: 3,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color(0xFFFF5A7D)
                                              .withOpacity(.38),
                                          blurRadius: 18,
                                        ),
                                      ],
                                    ),
                                    child: const Icon(
                                      Icons.favorite_rounded,
                                      color: Colors.white,
                                      size: 28,
                                    ),
                                  ),
                                ),
                                const Positioned(
                                  left: 8,
                                  top: 24,
                                  child: Icon(
                                    Icons.auto_awesome_rounded,
                                    color: Color(0xFFFFC857),
                                    size: 21,
                                  ),
                                ),
                              ],
                            ),
                          );

                          final details = Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Text(
                                "$babyName Care",
                                style: premiumHeadingStyle(size: 27),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "Pediatric AI health profile • continuously connected",
                                style: premiumBody3D(
                                  size: 10.5,
                                  color: const Color(0xFF66758C),
                                ),
                              ),
                              const SizedBox(height: 15),
                              Wrap(
                                spacing: 9,
                                runSpacing: 9,
                                children: [
                                  infoChip(
                                    Icons.cake_rounded,
                                    "Age",
                                    age,
                                    mainColor,
                                  ),
                                  infoChip(
                                    Icons.monitor_weight_rounded,
                                    "Weight",
                                    weight,
                                    medicalBlue,
                                  ),
                                  infoChip(
                                    Icons.restaurant_rounded,
                                    "Last Feeding",
                                    feeding,
                                    warningColor,
                                  ),
                                  infoChip(
                                    Icons.child_friendly_rounded,
                                    "Gender",
                                    gender,
                                    const Color(0xFF7B61E8),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 15),
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(13),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      successColor.withOpacity(.08),
                                      mainColor.withOpacity(.06),
                                    ],
                                  ),
                                  borderRadius:
                                      BorderRadius.circular(20),
                                  border: Border.all(
                                    color:
                                        Colors.white.withOpacity(.95),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 42,
                                      height: 42,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: successColor
                                                .withOpacity(.16),
                                            blurRadius: 12,
                                          ),
                                        ],
                                      ),
                                      child: const Icon(
                                        Icons.verified_user_rounded,
                                        color: successColor,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Baby is doing great",
                                            style:
                                                premiumHeadingStyle(
                                              size: 12,
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            "All connected health signals are currently within the expected pediatric range.",
                                            style: premiumBody3D(
                                              size: 9,
                                              color: const Color(
                                                0xFF66758C,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Icon(
                                      Icons.monitor_heart_rounded,
                                      color: mainColor,
                                      size: 31,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );

                          if (wide) {
                            return Row(
                              children: [
                                orbit,
                                const SizedBox(width: 24),
                                Expanded(child: details),
                              ],
                            );
                          }
                          return Column(
                            children: [
                              orbit,
                              const SizedBox(height: 10),
                              details,
                            ],
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 24),

                    Row(
                      children: [
                        Container(
                          width: 46,
                          height: 46,
                          decoration: BoxDecoration(
                            color: mainColor.withOpacity(.10),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: mainColor.withOpacity(.16),
                                blurRadius: 13,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.monitor_heart_rounded,
                            color: mainColor,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Live Health Signals",
                                style: premiumHeadingStyle(size: 21),
                              ),
                              Text(
                                "Real-time pediatric sensor monitoring",
                                style: premiumBody3D(
                                  size: 9.5,
                                  color: const Color(0xFF66758C),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const PremiumStatusPill(
                          text: "LIVE",
                          color: successColor,
                          icon: Icons.circle,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const HomeLiveVitals(),

                    const SizedBox(height: 24),

                    PediatricDigitalTwinCard(
                      onCryTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const RecordingScreen(),
                          ),
                        );
                      },
                      onVitalsTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const VitalSignsScreen(),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 20),

                    AiCryInsightCard(
                      onRecord: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const RecordingScreen(),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 20),

                    LayoutBuilder(
                      builder: (context, c) {
                        if (c.maxWidth > 760) {
                          return const Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(child: BabyHealthScoreCard()),
                              SizedBox(width: 14),
                              Expanded(child: SmartMedicalTimelineCard()),
                            ],
                          );
                        }
                        return const Column(
                          children: [
                            BabyHealthScoreCard(),
                            SizedBox(height: 14),
                            SmartMedicalTimelineCard(),
                          ],
                        );
                      },
                    ),

                    const SizedBox(height: 16),
                    const PediatricAiInsightCard(),
                    const SizedBox(height: 14),
                    const MedicalModePreviewCard(),

                    const SizedBox(height: 24),
                    Row(
                      children: [
                        const Icon(
                          Icons.bolt_rounded,
                          color: mainColor,
                        ),
                        const SizedBox(width: 7),
                        Text(
                          "Smart Actions",
                          style: premiumHeadingStyle(size: 20),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    StreamBuilder<int>(
                      stream: uid.isEmpty
                          ? const Stream.empty()
                          : chatCount(uid),
                      builder: (context, chatSnap) {
                        return StreamBuilder<int>(
                          stream: uid.isEmpty
                              ? const Stream.empty()
                              : appointmentCount(uid),
                          builder: (context, appSnap) {
                            final chatBadge =
                                chatSnap.data ?? 0;
                            final appointmentBadge =
                                appSnap.data ?? 0;

                            return LayoutBuilder(
                              builder: (context, c) {
                                final cols =
                                    c.maxWidth > 920
                                        ? 4
                                        : c.maxWidth > 580
                                            ? 2
                                            : 1;

                                return GridView.count(
                                  crossAxisCount: cols,
                                  shrinkWrap: true,
                                  physics:
                                      const NeverScrollableScrollPhysics(),
                                  mainAxisSpacing: 12,
                                  crossAxisSpacing: 12,
                                  mainAxisExtent: 205,
                                  children: [
                                    quickAction(
                                      icon: Icons.mic_rounded,
                                      title: "AI Cry Scan",
                                      subtitle:
                                          "Record and classify your baby's cry",
                                      color: mainColor,
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) =>
                                                const RecordingScreen(),
                                          ),
                                        );
                                      },
                                    ),
                                    quickAction(
                                      icon: Icons.forum_rounded,
                                      title: "Doctor Chat",
                                      subtitle:
                                          "Secure pediatric consultation",
                                      color: medicalBlue,
                                      badge: chatBadge,
                                      onTap: () => onTabSelected(3),
                                    ),
                                    quickAction(
                                      icon:
                                          Icons.calendar_month_rounded,
                                      title: "Appointments",
                                      subtitle:
                                          "Book and manage clinical visits",
                                      color: const Color(0xFFFFA928),
                                      badge: appointmentBadge,
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) =>
                                                const AppointmentScreen(),
                                          ),
                                        );
                                      },
                                    ),
                                    quickAction(
                                      icon:
                                          Icons.description_rounded,
                                      title: "Medical Report",
                                      subtitle:
                                          "Generate a smart health summary",
                                      color: const Color(0xFF9547E7),
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) =>
                                                const MedicalReportScreen(),
                                          ),
                                        );
                                      },
                                    ),
                                    quickAction(
                                      icon: Icons.monitor_heart_rounded,
                                      title: "Live Health Monitor",
                                      subtitle: "Hospital-style vitals and live trends",
                                      color: const Color(0xFF00A6A6),
                                      onTap: () {
                                        Navigator.push(context, MaterialPageRoute(builder: (_) => const VitalSignsScreen()));
                                      },
                                    ),
                                    quickAction(
                                      icon: Icons.insights_rounded,
                                      title: "Cry Analytics",
                                      subtitle: "Weekly patterns, causes and AI trends",
                                      color: const Color(0xFF5E5CE6),
                                      onTap: () {
                                        Navigator.push(context, MaterialPageRoute(builder: (_) => const CryAnalyticsScreen()));
                                      },
                                    ),
                                    quickAction(
                                      icon: Icons.health_and_safety_rounded,
                                      title: "Smart Risk Center",
                                      subtitle: "AI risk score and emergency guidance",
                                      color: const Color(0xFFFF5A6F),
                                      onTap: () {
                                        Navigator.push(context, MaterialPageRoute(builder: (_) => const SmartRiskCenterScreen()));
                                      },
                                    ),
                                    quickAction(
                                      icon: Icons.auto_awesome_rounded,
                                      title: "Doctor Demo Tour",
                                      subtitle: "Show the complete AI pediatric experience",
                                      color: const Color(0xFF9B51E0),
                                      onTap: () {
                                        Navigator.push(context, MaterialPageRoute(builder: (_) => const DoctorDemoTourScreen()));
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        );
                      },
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

/* ===================== PREMIUM HOME VITALS ===================== */

class HomeLiveVitals extends StatefulWidget {
  const HomeLiveVitals({super.key});

  @override
  State<HomeLiveVitals> createState() =>
      _HomeLiveVitalsState();
}

class _HomeLiveVitalsState extends State<HomeLiveVitals> {
  Timer? timer;
  double phase = 0;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(
      const Duration(milliseconds: 75),
      (_) {
        if (!mounted) return;
        setState(() => phase += .16);
      },
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Widget monitorCard({
    required BuildContext context,
    required String title,
    required IconData icon,
    required Color color,
    required String value,
    required String unit,
    required bool active,
    required String metric,
    required String range,
  }) {
    return HoverLift(
      lift: 7,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => VitalSignsScreen(
                initialMetric: metric,
              ),
            ),
          );
        },
        borderRadius: BorderRadius.circular(30),
        child: Container(
          constraints: const BoxConstraints(minHeight: 245),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withOpacity(.97),
                color.withOpacity(.045),
                Colors.white.withOpacity(.89),
              ],
            ),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: Colors.white.withOpacity(.96),
              width: 1.6,
            ),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(.15),
                blurRadius: 30,
                spreadRadius: .5,
                offset: const Offset(0, 14),
              ),
              BoxShadow(
                color: Colors.white.withOpacity(.95),
                blurRadius: 8,
                offset: const Offset(-3, -3),
              ),
            ],
          ),
          child: Stack(
            children: [
              Positioned(
                top: -32,
                right: -22,
                child: Container(
                  width: 125,
                  height: 125,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        color.withOpacity(.14),
                        color.withOpacity(0),
                      ],
                    ),
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              color.withOpacity(.18),
                              Colors.white,
                            ],
                          ),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white,
                            width: 1.4,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: color.withOpacity(.22),
                              blurRadius: 16,
                            ),
                          ],
                        ),
                        child: Icon(
                          icon,
                          color: color,
                          size: 25,
                          shadows: coloredGlow(
                            color,
                            strength: .8,
                          ),
                        ),
                      ),
                      const SizedBox(width: 11),
                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: premiumHeadingStyle(
                                size: 16,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              active
                                  ? "LIVE SENSOR STREAM"
                                  : "WAITING FOR SENSOR",
                              style: TextStyle(
                                color: active
                                    ? successColor
                                    : warningColor,
                                fontSize: 8.5,
                                fontWeight: FontWeight.w900,
                                letterSpacing: .4,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 61,
                        height: 61,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: color.withOpacity(.24),
                            width: 4,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: color.withOpacity(.20),
                              blurRadius: 18,
                            ),
                          ],
                        ),
                        child: Center(
                          child: Icon(
                            icon,
                            color: color,
                            size: 27,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 13),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        active ? value : "--",
                        style: premiumMetricStyle(
                          size: 42,
                          color: color,
                        ),
                      ),
                      const SizedBox(width: 7),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 7),
                        child: Text(
                          unit,
                          style: premiumBody3D(
                            size: 14,
                            color: darkText,
                            weight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: active
                              ? successColor
                              : warningColor,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: (active
                                      ? successColor
                                      : warningColor)
                                  .withOpacity(.45),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 7),
                      Text(
                        range,
                        style: premiumBody3D(
                          size: 9.5,
                          color: const Color(0xFF66758C),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 9),
                  Container(
                    height: 77,
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 7,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: color.withOpacity(.025),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: color.withOpacity(.06),
                      ),
                    ),
                    child: CustomPaint(
                      painter: VitalWavePainter(
                        color: color,
                        phase: phase,
                        strength: 1,
                        active: active,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) return const SizedBox.shrink();

    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection('vital_signs')
          .doc(user.uid)
          .snapshots(),
      builder: (context, snapshot) {
        final data = snapshot.data?.data();

        final hrRaw = data?['heartRate'];
        final tempRaw = data?['temperature'];

        final heartRate =
            hrRaw is num ? hrRaw.toDouble() : null;
        final temperature =
            tempRaw is num ? tempRaw.toDouble() : null;

        return LayoutBuilder(
          builder: (context, constraints) {
            final wide = constraints.maxWidth > 720;

            final heart = monitorCard(
              context: context,
              title: "Heart Rate",
              icon: Icons.favorite_rounded,
              color: const Color(0xFFFF4F76),
              value: heartRate?.toStringAsFixed(0) ?? "--",
              unit: "bpm",
              active: heartRate != null,
              metric: "heart",
              range: "Normal pediatric range • 90–160 bpm",
            );

            final temp = monitorCard(
              context: context,
              title: "Temperature",
              icon: Icons.thermostat_rounded,
              color: const Color(0xFF8C52E5),
              value: temperature?.toStringAsFixed(1) ?? "--",
              unit: "°C",
              active: temperature != null,
              metric: "temperature",
              range: "Normal range • 36.0–37.5 °C",
            );

            if (wide) {
              return Row(
                children: [
                  Expanded(child: heart),
                  const SizedBox(width: 16),
                  Expanded(child: temp),
                ],
              );
            }

            return Column(
              children: [
                heart,
                const SizedBox(height: 16),
                temp,
              ],
            );
          },
        );
      },
    );
  }
}

class AnimatedBabyOrbit extends StatefulWidget {
  const AnimatedBabyOrbit({super.key});

  @override
  State<AnimatedBabyOrbit> createState() => _AnimatedBabyOrbitState();
}

class _AnimatedBabyOrbitState extends State<AnimatedBabyOrbit>
    with SingleTickerProviderStateMixin {
  late final AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      child: AnimatedBuilder(
        animation: controller,
        builder: (context, _) {
          final angle = controller.value * math.pi * 2;

          return Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 138,
                height: 138,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: mainColor.withOpacity(.15),
                    width: 2,
                  ),
                ),
              ),
              Container(
                width: 108,
                height: 108,
                decoration: BoxDecoration(
                  color: mainColor.withOpacity(.055),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: mainColor.withOpacity(.18),
                    width: 2,
                  ),
                ),
                child: const Icon(
                  Icons.child_care_rounded,
                  color: mainColor,
                  size: 58,
                ),
              ),
              Transform.translate(
                offset: Offset(
                  math.cos(angle) * 62,
                  math.sin(angle) * 62,
                ),
                child: Container(
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    color: softPink,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: softPink.withOpacity(.55),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                ),
              ),
              Transform.translate(
                offset: Offset(
                  math.cos(angle + 2.6) * 62,
                  math.sin(angle + 2.6) * 62,
                ),
                child: const Icon(
                  Icons.star_rounded,
                  color: Color(0xFFFFC857),
                  size: 17,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class PulsingMic extends StatefulWidget {
  const PulsingMic({super.key});

  @override
  State<PulsingMic> createState() => _PulsingMicState();
}

class _PulsingMicState extends State<PulsingMic>
    with SingleTickerProviderStateMixin {
  late final AnimationController controller;
  late final Animation<double> animation;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    )..repeat(reverse: true);

    animation = Tween<double>(
      begin: .92,
      end: 1.08,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: animation,
      child: Container(
        width: 62,
        height: 62,
        decoration: BoxDecoration(
          color: mainColor.withOpacity(.10),
          shape: BoxShape.circle,
          border: Border.all(
            color: mainColor.withOpacity(.25),
            width: 2,
          ),
        ),
        child: const Icon(
          Icons.mic_rounded,
          color: mainColor,
          size: 30,
        ),
      ),
    );
  }
}

/* ===================== LIVE VITAL SIGNS SCREEN ===================== */

class VitalSignsScreen extends StatefulWidget {
  final String initialMetric;

  const VitalSignsScreen({
    super.key,
    this.initialMetric = "heart",
  });

  @override
  State<VitalSignsScreen> createState() => _VitalSignsScreenState();
}

class _VitalSignsScreenState extends State<VitalSignsScreen> {
  Timer? animationTimer;
  double phase = 0;

  @override
  void initState() {
    super.initState();

    animationTimer = Timer.periodic(
      const Duration(milliseconds: 90),
      (_) {
        if (!mounted) return;
        setState(() {
          phase += 0.18;
        });
      },
    );
  }

  @override
  void dispose() {
    animationTimer?.cancel();
    super.dispose();
  }

  Future<void> writeTestReading() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final now = DateTime.now();
    final heartRate = 118 + (now.second % 12);
    final temperature = 36.5 + ((now.second % 7) / 10);

    try {
      await FirebaseFirestore.instance
          .collection('vital_signs')
          .doc(user.uid)
          .set({
        'motherUid': user.uid,
        'heartRate': heartRate,
        'temperature': double.parse(
          temperature.toStringAsFixed(1),
        ),
        'source': 'test',
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Test sensor reading added ✅",
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Could not add test reading: $e"),
          ),
        );
      }
    }
  }

  String readingTime(Timestamp? value) {
    if (value == null) return "Waiting for sensor";

    final date = value.toDate();
    String two(int n) => n.toString().padLeft(2, '0');

    return "Updated ${two(date.hour)}:${two(date.minute)}:${two(date.second)}";
  }

  Widget vitalCard({
    required String title,
    required IconData icon,
    required Color color,
    required String value,
    required String unit,
    required bool hasReading,
    required double waveStrength,
  }) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(
          color: color.withOpacity(.12),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.05),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: color.withOpacity(.12),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 28,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: darkText,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: color.withOpacity(.28),
                    width: 5,
                  ),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 34,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                hasReading ? value : "--",
                style: TextStyle(
                  color: color,
                  fontSize: 42,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 8),
              Padding(
                padding: const EdgeInsets.only(bottom: 7),
                child: Text(
                  unit,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                width: 9,
                height: 9,
                decoration: BoxDecoration(
                  color: hasReading
                      ? successColor
                      : warningColor,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                hasReading
                    ? "Live sensor reading"
                    : "Waiting for sensor data",
                style: TextStyle(
                  color: hasReading
                      ? Colors.grey
                      : warningColor,
                  fontSize: 13,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          SizedBox(
            height: 95,
            width: double.infinity,
            child: CustomPaint(
              painter: VitalWavePainter(
                color: color,
                phase: phase,
                strength: waveStrength,
                active: hasReading,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return Scaffold(
        body: BabyBg(
          child: const Center(
            child: Text("Please login first"),
          ),
        ),
      );
    }

    return Scaffold(
      body: BabyBg(
        child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance
              .collection('vital_signs')
              .doc(user.uid)
              .snapshots(),
          builder: (context, snapshot) {
            final data = snapshot.data?.data();

            final heartRateRaw = data?['heartRate'];
            final temperatureRaw = data?['temperature'];

            final double? heartRate =
                heartRateRaw is num ? heartRateRaw.toDouble() : null;

            final double? temperature =
                temperatureRaw is num ? temperatureRaw.toDouble() : null;

            final updatedAt = data?['updatedAt'] is Timestamp
                ? data!['updatedAt'] as Timestamp
                : null;

            final source = data?['source']?.toString() ?? 'sensor';

            return SingleChildScrollView(
              padding: const EdgeInsets.all(25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  backButton(context),
                  const SizedBox(height: 5),
                  const Text(
                    "Live Health Signals",
                    style: TextStyle(
                      color: darkText,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    readingTime(updatedAt),
                    style: const TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 22),

                  LayoutBuilder(
                    builder: (context, constraints) {
                      final isWide = constraints.maxWidth > 760;

                      final heartCard = vitalCard(
                        title: "Heart Rate",
                        icon: Icons.favorite,
                        color: Colors.redAccent,
                        value: heartRate?.toStringAsFixed(0) ?? "--",
                        unit: "bpm",
                        hasReading: heartRate != null,
                        waveStrength:
                            ((heartRate ?? 110) / 160).clamp(.35, 1.0),
                      );

                      final tempCard = vitalCard(
                        title: "Temperature",
                        icon: Icons.thermostat,
                        color: Colors.purple,
                        value: temperature?.toStringAsFixed(1) ?? "--",
                        unit: "°C",
                        hasReading: temperature != null,
                        waveStrength:
                            ((temperature ?? 36.5) / 40).clamp(.45, 1.0),
                      );

                      if (isWide) {
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(child: heartCard),
                            const SizedBox(width: 18),
                            Expanded(child: tempCard),
                          ],
                        );
                      }

                      return Column(
                        children: [
                          heartCard,
                          const SizedBox(height: 18),
                          tempCard,
                        ],
                      );
                    },
                  ),

                  const SizedBox(height: 20),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8FFF5),
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(
                        color: successColor.withOpacity(.18),
                      ),
                    ),
                    child: Row(
                      children: [
                        const CircleAvatar(
                          backgroundColor: Colors.white,
                          child: Icon(
                            Icons.monitor_heart,
                            color: mainColor,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Live Monitoring",
                                style: TextStyle(
                                  color: darkText,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                data == null
                                    ? "Connect the baby sensor device to start receiving real readings."
                                    : source == 'test'
                                        ? "Test data is currently displayed."
                                        : "Receiving readings from the connected sensor.",
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  if (data == null || source == 'test')
                    mainButton(
                      data == null
                          ? "Add Test Sensor Reading"
                          : "Refresh Test Reading",
                      Icons.science,
                      writeTestReading,
                      color: medicalBlue,
                    ),

                  const SizedBox(height: 10),

                  const Text(
                    "Note: Real heart rate and body temperature require a connected hardware sensor. The wave is a live trend visualization of incoming readings, not a diagnostic ECG.",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class VitalWavePainter extends CustomPainter {
  final Color color;
  final double phase;
  final double strength;
  final bool active;

  VitalWavePainter({
    required this.color,
    required this.phase,
    required this.strength,
    required this.active,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = Colors.grey.withOpacity(.08)
      ..strokeWidth = 1;

    for (double y = 15; y < size.height; y += 20) {
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        gridPaint,
      );
    }

    final path = Path();
    final centerY = size.height * .55;
    final amplitude = active ? 18.0 * strength : 3.0;

    for (double x = 0; x <= size.width; x += 2) {
      final normalized = x / size.width;

      double y;

      if (!active) {
        y = centerY +
            math.sin((normalized * math.pi * 4) + phase) *
                amplitude;
      } else {
        final base =
            math.sin((normalized * math.pi * 6) + phase) *
                amplitude *
                .35;

        final pulsePosition =
            ((normalized * 3.2 + phase / 8) % 1.0);

        double pulse = 0;

        if (pulsePosition > .42 && pulsePosition < .47) {
          pulse = -amplitude * 1.7;
        } else if (pulsePosition >= .47 &&
            pulsePosition < .52) {
          pulse = amplitude * 1.15;
        } else if (pulsePosition >= .52 &&
            pulsePosition < .58) {
          pulse = -amplitude * .45;
        }

        y = centerY + base + pulse;
      }

      if (x == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    final fillPath = Path.from(path)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          color.withOpacity(.16),
          color.withOpacity(.01),
        ],
      ).createShader(
        Rect.fromLTWH(0, 0, size.width, size.height),
      );

    canvas.drawPath(fillPath, fillPaint);

    final linePaint = Paint()
      ..color = active ? color : Colors.grey
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    canvas.drawPath(path, linePaint);
  }

  @override
  bool shouldRepaint(covariant VitalWavePainter oldDelegate) {
    return oldDelegate.phase != phase ||
        oldDelegate.strength != strength ||
        oldDelegate.active != active ||
        oldDelegate.color != color;
  }
}

/* ===================== INFANT PROFILE SCREEN ===================== */

class InfantProfileScreen extends StatefulWidget {
  const InfantProfileScreen({super.key});

  @override
  State<InfantProfileScreen> createState() =>
      _InfantProfileScreenState();
}

class _InfantProfileScreenState
    extends State<InfantProfileScreen> {
  final TextEditingController babyNameController =
      TextEditingController();
  final TextEditingController ageController =
      TextEditingController();
  final TextEditingController weightController =
      TextEditingController();
  final TextEditingController temperatureController =
      TextEditingController();
  final TextEditingController lastFeedingController =
      TextEditingController();
  final TextEditingController diseaseDetailsController =
      TextEditingController();

  String gender = "Boy";
  String medicalHistory = "No";
  bool loadingProfile = true;
  bool savingProfile = false;

  @override
  void initState() {
    super.initState();
    loadInfantProfile();
  }

  Future<void> loadInfantProfile() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      if (mounted) {
        setState(() => loadingProfile = false);
      }
      return;
    }

    try {
      final doc = await FirebaseFirestore.instance
          .collection('infant_profiles')
          .doc(user.uid)
          .get();

      if (doc.exists) {
        final data = doc.data() ?? {};

        babyNameController.text =
            data['babyName']?.toString() ?? '';
        ageController.text =
            data['ageMonths']?.toString() ?? '';
        weightController.text =
            data['weightKg']?.toString() ?? '';
        temperatureController.text =
            data['temperature']?.toString() ?? '';
        lastFeedingController.text =
            data['lastFeedingTime']?.toString() ?? '';
        diseaseDetailsController.text =
            data['diseaseDetails']?.toString() ?? '';

        gender = data['gender']?.toString() ?? 'Boy';
        medicalHistory =
            data['medicalHistory']?.toString() ?? 'No';
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text("Could not load infant profile: $e"),
          ),
        );
      }
    }

    if (mounted) {
      setState(() => loadingProfile = false);
    }
  }

  Future<void> saveInfantProfile() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return;
    }

    if (babyNameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter Baby Name"),
        ),
      );
      return;
    }

    setState(() => savingProfile = true);

    try {
      await FirebaseFirestore.instance
          .collection('infant_profiles')
          .doc(user.uid)
          .set({
        'motherUid': user.uid,
        'motherEmail': user.email ?? '',
        'babyName': babyNameController.text.trim(),
        'ageMonths': ageController.text.trim(),
        'gender': gender,
        'weightKg': weightController.text.trim(),
        'temperature': temperatureController.text.trim(),
        'lastFeedingTime': lastFeedingController.text.trim(),
        'medicalHistory': medicalHistory,
        'diseaseDetails': medicalHistory == "Yes"
            ? diseaseDetailsController.text.trim()
            : '',
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      if (mounted) {
        await showPremiumSuccess(
          context,
          title: "Profile Updated",
          message:
              "Baby information has been saved and synchronized successfully.",
          icon: Icons.verified_user_rounded,
          color: successColor,
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text("Could not save infant profile: $e"),
          ),
        );
      }
    }

    if (mounted) {
      setState(() => savingProfile = false);
    }
  }

  @override
  void dispose() {
    babyNameController.dispose();
    ageController.dispose();
    weightController.dispose();
    temperatureController.dispose();
    lastFeedingController.dispose();
    diseaseDetailsController.dispose();
    super.dispose();
  }

  Widget premiumField(
    TextEditingController controller,
    String label,
    IconData icon, {
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: mainColor),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (loadingProfile) {
      return const BabyBg(
        child: Center(child: CircularProgressIndicator()),
      );
    }

    return BabyBg(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 28),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 900),
            child: Column(
              children: [
                const Text(
                  "Infant Profile",
                  style: TextStyle(
                    color: darkText,
                    fontSize: 27,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 17),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(27),
                    boxShadow: [
                      BoxShadow(
                        color: mainColor.withOpacity(.05),
                        blurRadius: 18,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: LayoutBuilder(
                    builder: (context, c) {
                      final horizontal = c.maxWidth > 650;

                      final profileHead = const SizedBox(
                        width: 170,
                        height: 165,
                        child: AnimatedBabyOrbit(),
                      );

                      final textInfo = Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Text(
                            babyNameController.text.trim().isEmpty
                                ? "Baby 👶"
                                : "${babyNameController.text.trim()} 👶",
                            style: const TextStyle(
                              color: darkText,
                              fontSize: 23,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "${ageController.text.trim().isEmpty ? '--' : ageController.text.trim()} Months Old  •  $gender",
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 12),
                          const Row(
                            children: [
                              Icon(
                                Icons.verified_rounded,
                                color: successColor,
                                size: 18,
                              ),
                              SizedBox(width: 6),
                              Text(
                                "Information synchronized with Firebase",
                                style: TextStyle(
                                  color: successColor,
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      );

                      if (horizontal) {
                        return Row(
                          children: [
                            profileHead,
                            const SizedBox(width: 20),
                            Expanded(child: textInfo),
                          ],
                        );
                      }

                      return Column(
                        children: [
                          profileHead,
                          const SizedBox(height: 10),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: textInfo,
                          ),
                        ],
                      );
                    },
                  ),
                ),

                const SizedBox(height: 14),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(17),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(23),
                  ),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Basic Information",
                        style: TextStyle(
                          color: darkText,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 13),
                      premiumField(
                        babyNameController,
                        "Baby Name",
                        Icons.child_care_rounded,
                      ),
                      const SizedBox(height: 10),
                      premiumField(
                        ageController,
                        "Age (months)",
                        Icons.cake_rounded,
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 10),
                      DropdownButtonFormField<String>(
                        value: gender,
                        decoration: inputField(
                          "Gender",
                          Icons.wc_rounded,
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: "Boy",
                            child: Text("Boy"),
                          ),
                          DropdownMenuItem(
                            value: "Girl",
                            child: Text("Girl"),
                          ),
                        ],
                        onChanged: (v) {
                          if (v != null) {
                            setState(() => gender = v);
                          }
                        },
                      ),
                      const SizedBox(height: 10),
                      premiumField(
                        weightController,
                        "Weight (kg)",
                        Icons.monitor_weight_rounded,
                        keyboardType:
                            const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                      ),
                      const SizedBox(height: 10),
                      premiumField(
                        temperatureController,
                        "Temperature (°C)",
                        Icons.thermostat_rounded,
                        keyboardType:
                            const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 14),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(17),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(23),
                  ),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Health Information",
                        style: TextStyle(
                          color: darkText,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 13),
                      premiumField(
                        lastFeedingController,
                        "Last Feeding Time",
                        Icons.schedule_rounded,
                      ),
                      const SizedBox(height: 10),
                      DropdownButtonFormField<String>(
                        value: medicalHistory,
                        decoration: inputField(
                          "Known Medical Conditions?",
                          Icons.health_and_safety_rounded,
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: "No",
                            child: Text("No"),
                          ),
                          DropdownMenuItem(
                            value: "Yes",
                            child: Text("Yes"),
                          ),
                        ],
                        onChanged: (v) {
                          if (v != null) {
                            setState(
                              () => medicalHistory = v,
                            );
                          }
                        },
                      ),
                      if (medicalHistory == "Yes") ...[
                        const SizedBox(height: 10),
                        premiumField(
                          diseaseDetailsController,
                          "Medical condition details",
                          Icons.edit_note_rounded,
                          maxLines: 2,
                        ),
                      ],
                    ],
                  ),
                ),

                const SizedBox(height: 14),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEFFBFC),
                    borderRadius: BorderRadius.circular(19),
                  ),
                  child: const Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.verified_user_rounded,
                          color: mainColor,
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          "All information is up to date. Keep it updated for accurate monitoring.",
                          style: TextStyle(
                            color: darkText,
                            fontSize: 10.5,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.monitor_heart_rounded,
                        color: Color(0xFFAADDDD),
                        size: 36,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 14),

                savingProfile
                    ? const CircularProgressIndicator()
                    : mainButton(
                        "Save Profile",
                        Icons.save_rounded,
                        saveInfantProfile,
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/* ===================== HISTORY SCREEN ===================== */

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  Color statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'alert':
      case 'high':
        return dangerColor;
      case 'attention':
      case 'medium':
        return warningColor;
      default:
        return successColor;
    }
  }

  String formatTimestamp(Timestamp? timestamp) {
    if (timestamp == null) return "Just now";

    final d = timestamp.toDate();
    String two(int n) => n.toString().padLeft(2, '0');

    return "${two(d.day)}/${two(d.month)}/${d.year} • "
        "${two(d.hour)}:${two(d.minute)}";
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const BabyBg(
        child: Center(child: Text("Please login first")),
      );
    }

    return BabyBg(
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('monitoring_history')
            .where('motherUid', isEqualTo: user.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text("History error: ${snapshot.error}"),
            );
          }

          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final docs = snapshot.data!.docs.toList();

          docs.sort((a, b) {
            final ad = a.data() as Map<String, dynamic>;
            final bd = b.data() as Map<String, dynamic>;

            final at = ad['createdAt'] as Timestamp?;
            final bt = bd['createdAt'] as Timestamp?;

            if (at == null || bt == null) return 0;

            return bt.compareTo(at);
          });

          return ListView(
            padding: const EdgeInsets.fromLTRB(
              20,
              18,
              20,
              28,
            ),
            children: [
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      "Monitoring History",
                      style: TextStyle(
                        color: darkText,
                        fontSize: 27,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    width: 41,
                    height: 41,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.calendar_month_rounded,
                      color: Color(0xFF7882A2),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              if (docs.isEmpty)
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 70),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(23),
                  ),
                  child: const Column(
                    children: [
                      Icon(
                        Icons.history_rounded,
                        color: mainColor,
                        size: 63,
                      ),
                      SizedBox(height: 12),
                      Text(
                        "No monitoring history yet",
                        style: TextStyle(
                          color: darkText,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                )
              else
                ...docs.map((doc) {
                  final d =
                      doc.data() as Map<String, dynamic>;

                  final type =
                      d['cryType']?.toString() ?? "Cry Recorded";

                  final confidence =
                      d['confidence']?.toString() ?? "--";

                  final risk =
                      d['riskLevel']?.toString() ?? "Low";

                  final recommendation =
                      d['recommendation']?.toString() ??
                          "No recommendation";

                  final color = statusColor(risk);

                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(21),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(.03),
                          blurRadius: 11,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 47,
                          height: 47,
                          decoration: BoxDecoration(
                            color: color.withOpacity(.10),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.monitor_heart_rounded,
                            color: color,
                          ),
                        ),
                        const SizedBox(width: 11),
                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      type,
                                      style: const TextStyle(
                                        color: darkText,
                                        fontSize: 14,
                                        fontWeight:
                                            FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    risk,
                                    style: TextStyle(
                                      color: color,
                                      fontSize: 10,
                                      fontWeight:
                                          FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "Confidence: $confidence • $recommendation",
                                maxLines: 1,
                                overflow:
                                    TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 10.5,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                formatTimestamp(
                                  d['createdAt']
                                      as Timestamp?,
                                ),
                                style: const TextStyle(
                                  color: Color(0xFF9AA3BA),
                                  fontSize: 9.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 9),
                        SizedBox(
                          width: 85,
                          height: 44,
                          child: CustomPaint(
                            painter: VitalWavePainter(
                              color: color,
                              phase: 0,
                              strength: .55,
                              active: true,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
            ],
          );
        },
      ),
    );
  }
}

/* ===================== SUBSCRIPTION / CONSULTATION HUB ===================== */


class SubscriptionScreen extends StatelessWidget {
  const SubscriptionScreen({super.key});

  Widget actionCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required String buttonText,
    required Color color,
    required VoidCallback onTap,
    int badge = 0,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.96),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: color.withOpacity(.10)),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(.07),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 62,
                height: 62,
                decoration: BoxDecoration(
                  color: color.withOpacity(.11),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: color.withOpacity(.22),
                    width: 2,
                  ),
                ),
                child: Icon(icon, color: color, size: 29),
              ),
              if (badge > 0)
                Positioned(
                  right: -4,
                  top: -5,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 7,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: dangerColor,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: Text(
                      badge > 99 ? "99+" : badge.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 16),
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
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          ElevatedButton(
            onPressed: onTap,
            style: ElevatedButton.styleFrom(
              backgroundColor: color,
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 14,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            child: Text(
              buttonText,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return BabyBg(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(25, 24, 25, 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: medicalBlue.withOpacity(.10),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(
                    Icons.medical_services_rounded,
                    color: medicalBlue,
                    size: 26,
                  ),
                ),
                const SizedBox(width: 13),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Doctor Consultation",
                        style: TextStyle(
                          color: darkText,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 3),
                      Text(
                        "Chat, search doctors and manage bookings",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 22),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(28),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white,
                    mainColor.withOpacity(.055),
                    softPink.withOpacity(.20),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: mainColor.withOpacity(.08),
                    blurRadius: 22,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: const Row(
                children: [
                  SizedBox(
                    width: 120,
                    height: 120,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 112,
                          height: 112,
                          child: CircularProgressIndicator(
                            value: 1,
                            strokeWidth: 4,
                            color: mainColor,
                            backgroundColor: Color(0xFFE4FBFA),
                          ),
                        ),
                        CircleAvatar(
                          radius: 43,
                          backgroundColor: Color(0xFFE7FAF9),
                          child: Icon(
                            Icons.medical_services_rounded,
                            color: mainColor,
                            size: 48,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 18),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Private Pediatric Care",
                          style: TextStyle(
                            color: darkText,
                            fontSize: 21,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          "Connect with approved pediatric doctors in real time.",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 13,
                          ),
                        ),
                        SizedBox(height: 12),
                        Row(
                          children: [
                            Icon(
                              Icons.verified_rounded,
                              color: successColor,
                              size: 18,
                            ),
                            SizedBox(width: 6),
                            Text(
                              "Verified doctors only",
                              style: TextStyle(
                                color: successColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
            const Text(
              "Care Services",
              style: TextStyle(
                color: darkText,
                fontSize: 21,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            actionCard(
              context: context,
              icon: Icons.search_rounded,
              title: "Find Approved Doctor",
              subtitle: "Search verified pediatric specialists",
              buttonText: "Find",
              color: mainColor,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const DoctorSearchScreen(),
                  ),
                );
              },
            ),

            StreamBuilder<QuerySnapshot>(
              stream: user == null
                  ? const Stream<QuerySnapshot>.empty()
                  : FirebaseFirestore.instance
                      .collection('chat_rooms')
                      .where('participants', arrayContains: user.uid)
                      .snapshots(),
              builder: (context, snapshot) {
                final count = snapshot.data?.docs.length ?? 0;

                return actionCard(
                  context: context,
                  icon: Icons.forum_rounded,
                  title: "My Conversations",
                  subtitle: "Continue private doctor conversations",
                  buttonText: "Open",
                  color: medicalBlue,
                  badge: count,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            const ConversationsScreen(role: 'mother'),
                      ),
                    );
                  },
                );
              },
            ),

            actionCard(
              context: context,
              icon: Icons.calendar_month_rounded,
              title: "Appointments",
              subtitle: "Choose date, time and approved doctor",
              buttonText: "Book",
              color: const Color(0xFFFF6B6B),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const AppointmentScreen(),
                  ),
                );
              },
            ),

            actionCard(
              context: context,
              icon: Icons.description_rounded,
              title: "Medical Report",
              subtitle: "View the latest cry analysis health report",
              buttonText: "View",
              color: Colors.purple,
              onTap: () {
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

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('doctors')
                    .where('approved', isEqualTo: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text("Doctor search error: ${snapshot.error}"),
                    );
                  }

                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final query = searchController.text.trim().toLowerCase();

                  final doctors = snapshot.data!.docs.where((doc) {
                    final data = doc.data() as Map<String, dynamic>;
                    final name = (data['name'] ?? '').toString().toLowerCase();
                    final specialization =
                        (data['specialization'] ?? '').toString().toLowerCase();

                    return query.isEmpty ||
                        name.contains(query) ||
                        specialization.contains(query);
                  }).toList();

                  if (doctors.isEmpty) {
                    return const Center(
                      child: Text("No approved doctors found"),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: doctors.length,
                    itemBuilder: (context, index) {
                      final doc = doctors[index];
                      final data = doc.data() as Map<String, dynamic>;

                      return Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(22),
                        ),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: mainColor.withOpacity(.15),
                            child: const Icon(
                              Icons.medical_services,
                              color: mainColor,
                            ),
                          ),
                          title: Text(
                            data['name']?.toString() ?? 'Doctor',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            "${data['specialization'] ?? 'Pediatrician'} • "
                            "${data['experience'] ?? '0'} years",
                          ),
                          trailing: const Icon(
                            Icons.verified,
                            color: successColor,
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => DoctorProfileScreen(
                                  doctorId: doc.id,
                                  doctorData: data,
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
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
  final String doctorId;
  final Map<String, dynamic> doctorData;

  const DoctorProfileScreen({
    super.key,
    required this.doctorId,
    required this.doctorData,
  });

  Future<void> startPrivateChat(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please login first")),
      );
      return;
    }

    final motherDoc =
        await FirebaseFirestore.instance.collection('users').doc(user.uid).get();

    final motherName = motherDoc.data()?['name']?.toString() ??
        motherDoc.data()?['email']?.toString() ??
        user.email ??
        'Mother';

    final doctorName = doctorData['name']?.toString() ?? 'Doctor';

    // Deterministic one-to-one room: one room per mother + doctor pair.
    final roomId = '${user.uid}_$doctorId';

    await FirebaseFirestore.instance.collection('chat_rooms').doc(roomId).set({
      'motherId': user.uid,
      'motherName': motherName,
      'doctorId': doctorId,
      'doctorName': doctorName,
      'participants': [user.uid, doctorId],
      'lastMessage': '',
      'updatedAt': FieldValue.serverTimestamp(),
      'createdAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    if (!context.mounted) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PrivateChatScreen(
          roomId: roomId,
          otherName: doctorName,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final name = doctorData['name']?.toString() ?? 'Doctor';
    final specialization =
        doctorData['specialization']?.toString() ?? 'Pediatrician';
    final experience = doctorData['experience']?.toString() ?? '0';

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
                name,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 27,
                  fontWeight: FontWeight.bold,
                  color: darkText,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                specialization,
                style: const TextStyle(color: Colors.grey, fontSize: 16),
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  smallStatCard(
                    "Verified",
                    "Status",
                    Icons.verified,
                    successColor,
                  ),
                  smallStatCard(
                    "$experience y",
                    "Experience",
                    Icons.work,
                    medicalBlue,
                  ),
                  smallStatCard(
                    "Online",
                    "Chat",
                    Icons.chat,
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
                subtitle:
                    doctorData['certificate']?.toString() ?? 'Uploaded',
                color: medicalBlue,
              ),
              featureCard(
                icon: Icons.access_time,
                title: "Private Consultation",
                subtitle: "Your conversation is stored in a private room",
                color: warningColor,
              ),
              const SizedBox(height: 15),
              mainButton(
                "Start Private Chat",
                Icons.chat,
                () => startPrivateChat(context),
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

/* ===================== PRIVATE REAL-TIME CHAT ===================== */


class ConversationsScreen extends StatelessWidget {
  final String role;

  const ConversationsScreen({
    super.key,
    required this.role,
  });

  String formatRoomTime(Timestamp? ts) {
    if (ts == null) return "";
    final d = ts.toDate();
    String two(int n) => n.toString().padLeft(2, '0');
    return "${two(d.hour)}:${two(d.minute)}";
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Scaffold(
        body: Center(child: Text("Please login first")),
      );
    }

    return Scaffold(
      body: BabyBg(
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('chat_rooms')
              .where('participants', arrayContains: user.uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return ListView(
                padding: const EdgeInsets.all(25),
                children: [
                  backButton(context),
                  const SizedBox(height: 10),
                  const Text(
                    "My Conversations",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: darkText,
                    ),
                  ),
                  const SizedBox(height: 120),
                  const Icon(
                    Icons.lock_outline_rounded,
                    size: 64,
                    color: dangerColor,
                  ),
                  const SizedBox(height: 15),
                  Text(
                    "Conversations error: ${snapshot.error}",
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: dangerColor),
                  ),
                ],
              );
            }

            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            final rooms = snapshot.data!.docs.toList();

            rooms.sort((a, b) {
              final ad = a.data() as Map<String, dynamic>;
              final bd = b.data() as Map<String, dynamic>;
              final at = ad['updatedAt'] as Timestamp?;
              final bt = bd['updatedAt'] as Timestamp?;
              if (at == null && bt == null) return 0;
              if (at == null) return 1;
              if (bt == null) return -1;
              return bt.compareTo(at);
            });

            return ListView(
              padding: const EdgeInsets.fromLTRB(25, 22, 25, 30),
              children: [
                Row(
                  children: [
                    backButton(context),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        role == 'doctor'
                            ? "Mother Conversations"
                            : "My Conversations",
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: darkText,
                        ),
                      ),
                    ),
                    Container(
                      width: 45,
                      height: 45,
                      decoration: BoxDecoration(
                        color: medicalBlue.withOpacity(.10),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.forum_rounded,
                        color: medicalBlue,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),

                if (rooms.isEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 25,
                      vertical: 75,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(.94),
                      borderRadius: BorderRadius.circular(26),
                    ),
                    child: const Column(
                      children: [
                        Icon(
                          Icons.chat_bubble_outline_rounded,
                          size: 66,
                          color: mainColor,
                        ),
                        SizedBox(height: 16),
                        Text(
                          "No conversations yet",
                          style: TextStyle(
                            color: darkText,
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          "Choose an approved doctor to start a private consultation.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  ...rooms.map((room) {
                    final data =
                        room.data() as Map<String, dynamic>;

                    final otherName = role == 'doctor'
                        ? (data['motherName']?.toString() ?? 'Mother')
                        : (data['doctorName']?.toString() ?? 'Doctor');

                    final lastMessage =
                        data['lastMessage']?.toString() ?? 'Open conversation';

                    final updatedAt = data['updatedAt'] as Timestamp?;

                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => PrivateChatScreen(
                              roomId: room.id,
                              otherName: otherName,
                            ),
                          ),
                        );
                      },
                      borderRadius: BorderRadius.circular(23),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(.96),
                          borderRadius: BorderRadius.circular(23),
                          border: Border.all(
                            color: mainColor.withOpacity(.08),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(.04),
                              blurRadius: 14,
                              offset: const Offset(0, 7),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Stack(
                              clipBehavior: Clip.none,
                              children: [
                                CircleAvatar(
                                  radius: 27,
                                  backgroundColor:
                                      medicalBlue.withOpacity(.11),
                                  child: Icon(
                                    role == 'doctor'
                                        ? Icons.person_rounded
                                        : Icons.medical_services_rounded,
                                    color: medicalBlue,
                                    size: 28,
                                  ),
                                ),
                                Positioned(
                                  right: -1,
                                  bottom: 1,
                                  child: Container(
                                    width: 13,
                                    height: 13,
                                    decoration: BoxDecoration(
                                      color: successColor,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Colors.white,
                                        width: 2,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    otherName,
                                    style: const TextStyle(
                                      color: darkText,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    lastMessage,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  formatRoomTime(updatedAt),
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 10,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Container(
                                  width: 26,
                                  height: 26,
                                  decoration: BoxDecoration(
                                    color: mainColor.withOpacity(.10),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    color: mainColor,
                                    size: 13,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
              ],
            );
          },
        ),
      ),
    );
  }
}

class PrivateChatScreen extends StatefulWidget {
  final String roomId;
  final String otherName;

  const PrivateChatScreen({
    super.key,
    required this.roomId,
    required this.otherName,
  });

  @override
  State<PrivateChatScreen> createState() => _PrivateChatScreenState();
}

class _PrivateChatScreenState extends State<PrivateChatScreen> {
  final TextEditingController messageController = TextEditingController();

  // Presentation role selector for the shared mother-doctor conversation.
  // Firebase still stores the authenticated sender ID.
  String activeChatRole = 'mother';
  bool isTyping = false;

  Future<String> currentRole() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return 'unknown';

    final doctorDoc =
        await FirebaseFirestore.instance.collection('doctors').doc(user.uid).get();

    if (doctorDoc.exists) return 'doctor';

    return 'mother';
  }

  Future<void> sendMessage() async {
    final text = messageController.text.trim();
    if (text.isEmpty) return;

    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please login first")),
      );
      return;
    }

    final roomRef =
        FirebaseFirestore.instance.collection('chat_rooms').doc(widget.roomId);

    await roomRef.collection('messages').add({
      'senderId': user.uid,
      'senderEmail': user.email ?? '',
      'senderRole': activeChatRole,
      'message': text,
      'createdAt': FieldValue.serverTimestamp(),
    });

    await roomRef.set({
      'lastMessage': text,
      'lastSenderId': user.uid,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    messageController.clear();
  }

  String messageTime(Timestamp? timestamp) {
    if (timestamp == null) return "";

    final d = timestamp.toDate();
    String two(int n) => n.toString().padLeft(2, '0');

    final h = d.hour == 0
        ? 12
        : d.hour > 12
            ? d.hour - 12
            : d.hour;

    final p = d.hour >= 12 ? "PM" : "AM";

    return "${two(h)}:${two(d.minute)} $p";
  }

  Widget chatBubble(Map<String, dynamic> msg) {
    final role =
        msg['senderRole']?.toString() ?? 'mother';

    final bool isDoctorMessage =
        role == 'doctor';

    final createdAt =
        msg['createdAt'] as Timestamp?;

    return Align(
      alignment: isDoctorMessage
          ? Alignment.centerLeft
          : Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.fromLTRB(
          13,
          10,
          11,
          8,
        ),
        constraints:
            const BoxConstraints(maxWidth: 350),
        decoration: BoxDecoration(
          color: isDoctorMessage
              ? Colors.white
              : mainColor,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(18),
            topRight: const Radius.circular(18),
            bottomLeft: Radius.circular(
              isDoctorMessage ? 5 : 18,
            ),
            bottomRight: Radius.circular(
              isDoctorMessage ? 18 : 5,
            ),
          ),
          border: isDoctorMessage
              ? Border.all(
                  color: medicalBlue.withOpacity(.12),
                )
              : null,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.035),
              blurRadius: 7,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Text(
              isDoctorMessage
                  ? 'Doctor'
                  : 'Mother',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 10,
                color: isDoctorMessage
                    ? medicalBlue
                    : Colors.white70,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              msg['message']?.toString() ?? '',
              style: TextStyle(
                color: isDoctorMessage
                    ? Colors.black87
                    : Colors.white,
                fontSize: 13,
                height: 1.3,
              ),
            ),
            const SizedBox(height: 5),
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment:
                  MainAxisAlignment.end,
              children: [
                Text(
                  messageTime(createdAt),
                  style: TextStyle(
                    color: isDoctorMessage
                        ? Colors.grey
                        : Colors.white70,
                    fontSize: 8.5,
                  ),
                ),
                if (!isDoctorMessage) ...[
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.done_all_rounded,
                    color: Color(0xFFD7FFFF),
                    size: 14,
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      body: BabyBg(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 980),
              child: Container(
                decoration: BoxDecoration(
                  color: dark
                      ? const Color(0xFF0E2133).withOpacity(.93)
                      : Colors.white.withOpacity(.91),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: dark
                        ? Colors.white.withOpacity(.06)
                        : Colors.white,
                    width: 1.4,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: mainColor.withOpacity(.12),
                      blurRadius: 30,
                      offset: const Offset(0, 14),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Premium doctor header
                    Padding(
                      padding: const EdgeInsets.fromLTRB(
                        18,
                        16,
                        18,
                        13,
                      ),
                      child: Row(
                        children: [
                          backButton(context),
                          const SizedBox(width: 10),
                          Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Container(
                                width: 58,
                                height: 58,
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFFE7FFFF),
                                      Color(0xFFDDEAFF),
                                    ],
                                  ),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 2,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: medicalBlue
                                          .withOpacity(.16),
                                      blurRadius: 14,
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.medical_services_rounded,
                                  color: medicalBlue,
                                  size: 28,
                                ),
                              ),
                              Positioned(
                                right: -1,
                                bottom: 1,
                                child: Container(
                                  width: 15,
                                  height: 15,
                                  decoration: BoxDecoration(
                                    color: successColor,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 2.5,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 11),
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Flexible(
                                      child: Text(
                                        widget.otherName,
                                        overflow:
                                            TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: dark
                                              ? Colors.white
                                              : darkText,
                                          fontSize: 18,
                                          fontWeight:
                                              FontWeight.w900,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 5),
                                    const Icon(
                                      Icons.verified_rounded,
                                      color: medicalBlue,
                                      size: 17,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 2),
                                const Text(
                                  "Pediatric specialist • Online",
                                  style: TextStyle(
                                    color: successColor,
                                    fontSize: 9.5,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Text(
                                  "End-to-end protected consultation",
                                  style: TextStyle(
                                    color: dark
                                        ? Colors.white54
                                        : Colors.grey,
                                    fontSize: 8.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          _chatAction(
                            Icons.call_rounded,
                            mainColor,
                          ),
                          const SizedBox(width: 7),
                          _chatAction(
                            Icons.videocam_rounded,
                            medicalBlue,
                          ),
                          const SizedBox(width: 7),
                          Container(
                            width: 39,
                            height: 39,
                            decoration: BoxDecoration(
                              color: successColor.withOpacity(.08),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.lock_rounded,
                              color: successColor,
                              size: 18,
                            ),
                          ),
                        ],
                      ),
                    ),

                    Divider(
                      height: 1,
                      color: dark
                          ? Colors.white.withOpacity(.06)
                          : mainColor.withOpacity(.07),
                    ),

                    // patient context strip
                    Container(
                      margin: const EdgeInsets.fromLTRB(
                        16,
                        12,
                        16,
                        4,
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 13,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            mainColor.withOpacity(.07),
                            medicalBlue.withOpacity(.05),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: const Row(
                        children: [
                          Icon(
                            Icons.child_care_rounded,
                            color: mainColor,
                            size: 20,
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              "Baby context attached • latest vitals and cry history available",
                              style: TextStyle(
                                color: Color(0xFF627489),
                                fontSize: 9,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          PremiumStatusPill(
                            text: "SECURE",
                            color: successColor,
                            icon: Icons.shield_rounded,
                          ),
                        ],
                      ),
                    ),

                    // messages
                    Expanded(
                      child: StreamBuilder<
                          QuerySnapshot<Map<String, dynamic>>>(
                        stream: FirebaseFirestore.instance
                            .collection('chat_rooms')
                            .doc(widget.roomId)
                            .collection('messages')
                            .orderBy('createdAt')
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return PremiumEmptyState(
                              icon: Icons.error_outline_rounded,
                              title: "Conversation unavailable",
                              subtitle: snapshot.error.toString(),
                            );
                          }

                          if (!snapshot.hasData) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          final docs = snapshot.data!.docs;

                          if (docs.isEmpty) {
                            return const PremiumEmptyState(
                              icon: Icons.forum_outlined,
                              title: "Start the consultation",
                              subtitle:
                                  "Send the first message to begin your secure pediatric conversation.",
                            );
                          }

                          return ListView.builder(
                            padding: const EdgeInsets.fromLTRB(
                              18,
                              14,
                              18,
                              12,
                            ),
                            itemCount: docs.length,
                            itemBuilder: (_, i) {
                              return chatBubble(
                                docs[i].data(),
                              );
                            },
                          );
                        },
                      ),
                    ),

                    // role selector compact
                    Padding(
                      padding: const EdgeInsets.fromLTRB(
                        16,
                        4,
                        16,
                        7,
                      ),
                      child: Row(
                        children: [
                          Text(
                            "Reply as",
                            style: TextStyle(
                              color: dark
                                  ? Colors.white54
                                  : Colors.grey,
                              fontSize: 8.5,
                            ),
                          ),
                          const SizedBox(width: 7),
                          ChoiceChip(
                            label: const Text("Mother"),
                            selected:
                                activeChatRole == 'mother',
                            onSelected: (_) {
                              setState(
                                () =>
                                    activeChatRole = 'mother',
                              );
                            },
                            avatar: const Icon(
                              Icons.person_rounded,
                              size: 15,
                            ),
                          ),
                          const SizedBox(width: 6),
                          ChoiceChip(
                            label: const Text("Doctor"),
                            selected:
                                activeChatRole == 'doctor',
                            onSelected: (_) {
                              setState(
                                () =>
                                    activeChatRole = 'doctor',
                              );
                            },
                            avatar: const Icon(
                              Icons.medical_services_rounded,
                              size: 15,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // floating composer
                    Container(
                      margin: const EdgeInsets.fromLTRB(
                        15,
                        0,
                        15,
                        15,
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 7,
                      ),
                      decoration: BoxDecoration(
                        color: dark
                            ? const Color(0xFF163047)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(
                          color: dark
                              ? Colors.white.withOpacity(.06)
                              : mainColor.withOpacity(.09),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(
                              dark ? .20 : .05,
                            ),
                            blurRadius: 17,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.attach_file_rounded,
                              color: medicalBlue,
                            ),
                          ),
                          Expanded(
                            child: TextField(
                              controller: messageController,
                              minLines: 1,
                              maxLines: 4,
                              style: TextStyle(
                                color: dark
                                    ? Colors.white
                                    : darkText,
                              ),
                              decoration:
                                  const InputDecoration(
                                hintText:
                                    "Type your message...",
                                filled: false,
                                border: InputBorder.none,
                                enabledBorder:
                                    InputBorder.none,
                                focusedBorder:
                                    InputBorder.none,
                                contentPadding:
                                    EdgeInsets.symmetric(
                                  horizontal: 4,
                                  vertical: 10,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          InkWell(
                            onTap: sendMessage,
                            borderRadius:
                                BorderRadius.circular(50),
                            child: Container(
                              width: 43,
                              height: 43,
                              decoration: BoxDecoration(
                                gradient:
                                    const LinearGradient(
                                  colors: [
                                    mainColor,
                                    medicalBlue,
                                  ],
                                ),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: mainColor
                                        .withOpacity(.27),
                                    blurRadius: 13,
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.send_rounded,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
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

  Widget _chatAction(IconData icon, Color color) {
    return Container(
      width: 39,
      height: 39,
      decoration: BoxDecoration(
        color: color.withOpacity(.08),
        shape: BoxShape.circle,
        border: Border.all(
          color: color.withOpacity(.08),
        ),
      ),
      child: Icon(
        icon,
        color: color,
        size: 18,
      ),
    );
  }

}

class AppointmentScreen extends StatefulWidget {
  const AppointmentScreen({super.key});

  @override
  State<AppointmentScreen> createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> {
  String selectedTime = "7:00 PM";
  String? selectedDoctorId;
  String? selectedDoctorName;
  DateTime? selectedDate;
  bool saving = false;

  late DateTime visibleMonth;

  final List<String> times = const [
    "7:00 PM",
    "8:00 PM",
    "9:00 PM",
  ];

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    visibleMonth = DateTime(now.year, now.month);
  }

  String monthName(int month) {
    const months = [
      "January", "February", "March", "April",
      "May", "June", "July", "August",
      "September", "October", "November", "December",
    ];
    return months[month - 1];
  }

  String formatDate(DateTime date) {
    String two(int n) => n.toString().padLeft(2, '0');
    return "${two(date.day)}/${two(date.month)}/${date.year}";
  }

  bool sameDate(DateTime? a, DateTime b) {
    if (a == null) return false;
    return a.year == b.year &&
        a.month == b.month &&
        a.day == b.day;
  }

  bool isPast(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return date.isBefore(today);
  }

  Widget calendar() {
    final firstDay = DateTime(
      visibleMonth.year,
      visibleMonth.month,
      1,
    );

    final daysInMonth = DateTime(
      visibleMonth.year,
      visibleMonth.month + 1,
      0,
    ).day;

    // Sunday = 0
    final leading = firstDay.weekday % 7;

    final cells = <Widget>[];

    for (int i = 0; i < leading; i++) {
      cells.add(const SizedBox());
    }

    for (int day = 1; day <= daysInMonth; day++) {
      final date = DateTime(
        visibleMonth.year,
        visibleMonth.month,
        day,
      );

      final selected = sameDate(selectedDate, date);
      final past = isPast(date);

      cells.add(
        InkWell(
          onTap: past
              ? null
              : () => setState(() => selectedDate = date),
          borderRadius: BorderRadius.circular(14),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            margin: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              color: selected
                  ? const Color(0xFFFF4D67)
                  : Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: selected
                    ? const Color(0xFFFF4D67)
                    : const Color(0xFFFFD7DE),
              ),
              boxShadow: selected
                  ? [
                      BoxShadow(
                        color: const Color(0xFFFF4D67)
                            .withOpacity(.25),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : null,
            ),
            alignment: Alignment.center,
            child: Text(
              day.toString(),
              style: TextStyle(
                color: past
                    ? Colors.grey.shade300
                    : selected
                        ? Colors.white
                        : darkText,
                fontWeight: selected
                    ? FontWeight.bold
                    : FontWeight.w600,
              ),
            ),
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFAFB),
        borderRadius: BorderRadius.circular(26),
        border: Border.all(
          color: const Color(0xFFFFD7DE),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFF4D67).withOpacity(.06),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () {
                  setState(() {
                    visibleMonth = DateTime(
                      visibleMonth.year,
                      visibleMonth.month - 1,
                    );
                  });
                },
                icon: const Icon(
                  Icons.chevron_left_rounded,
                  color: Color(0xFFFF4D67),
                ),
              ),
              Expanded(
                child: Text(
                  "${monthName(visibleMonth.month)} ${visibleMonth.year}",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: darkText,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    visibleMonth = DateTime(
                      visibleMonth.year,
                      visibleMonth.month + 1,
                    );
                  });
                },
                icon: const Icon(
                  Icons.chevron_right_rounded,
                  color: Color(0xFFFF4D67),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Row(
            children: [
              Expanded(child: Center(child: Text("S", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)))),
              Expanded(child: Center(child: Text("M", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)))),
              Expanded(child: Center(child: Text("T", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)))),
              Expanded(child: Center(child: Text("W", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)))),
              Expanded(child: Center(child: Text("T", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)))),
              Expanded(child: Center(child: Text("F", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)))),
              Expanded(child: Center(child: Text("S", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)))),
            ],
          ),
          const SizedBox(height: 6),
          GridView.count(
            crossAxisCount: 7,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            childAspectRatio: 1.15,
            children: cells,
          ),
        ],
      ),
    );
  }

  Future<void> _performAppointmentSave() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please login first")),
      );
      return;
    }

    if (selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select appointment date")),
      );
      return;
    }

    if (selectedDoctorId == null || selectedDoctorName == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select doctor")),
      );
      return;
    }

    setState(() => saving = true);

    try {
      String babyName = "Baby";

      final profileDoc = await FirebaseFirestore.instance
          .collection('infant_profiles')
          .doc(user.uid)
          .get();

      if (profileDoc.exists) {
        babyName =
            profileDoc.data()?['babyName']?.toString() ?? "Baby";
      }

      await FirebaseFirestore.instance
          .collection('appointments')
          .add({
        'motherUid': user.uid,
        'motherEmail': user.email ?? '',
        'babyName': babyName,
        'doctorId': selectedDoctorId,
        'doctorName': selectedDoctorName,
        'date': Timestamp.fromDate(selectedDate!),
        'dateText': formatDate(selectedDate!),
        'time': selectedTime,
        'status': 'Pending',
        'createdAt': FieldValue.serverTimestamp(),
      });

      if (mounted) {
        await showPremiumSuccess(
          context,
          title: "Appointment Booked",
          message:
              "Your appointment request was sent successfully. The doctor can now confirm or update it.",
          icon: Icons.event_available_rounded,
          color: successColor,
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Could not book appointment: $e"),
          ),
        );
      }
    }

    if (mounted) {
      setState(() => saving = false);
    }
  }


  Future<void> saveAppointment() async {
    if (selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
              Text("Please select appointment date"),
        ),
      );
      return;
    }

    if (selectedDoctorId == null ||
        selectedDoctorName == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please select doctor"),
        ),
      );
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            constraints:
                const BoxConstraints(maxWidth: 440),
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(27),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFFF4D67)
                      .withOpacity(.12),
                  blurRadius: 24,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 65,
                  height: 65,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF4D67)
                        .withOpacity(.10),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.calendar_month_rounded,
                    color: Color(0xFFFF4D67),
                    size: 34,
                  ),
                ),
                const SizedBox(height: 13),
                const Text(
                  "Confirm Appointment",
                  style: TextStyle(
                    color: darkText,
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 14),
                _summaryRow(
                  Icons.medical_services_rounded,
                  "Doctor",
                  selectedDoctorName!,
                ),
                _summaryRow(
                  Icons.event_rounded,
                  "Date",
                  formatDate(selectedDate!),
                ),
                _summaryRow(
                  Icons.schedule_rounded,
                  "Time",
                  selectedTime,
                ),
                const SizedBox(height: 17),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () =>
                            Navigator.pop(
                          dialogContext,
                          false,
                        ),
                        style: OutlinedButton.styleFrom(
                          minimumSize:
                              const Size.fromHeight(48),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(
                              14,
                            ),
                          ),
                        ),
                        child: const Text("Back"),
                      ),
                    ),
                    const SizedBox(width: 9),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () =>
                            Navigator.pop(
                          dialogContext,
                          true,
                        ),
                        style: ElevatedButton.styleFrom(
                          minimumSize:
                              const Size.fromHeight(48),
                          backgroundColor:
                              const Color(0xFFFF4D67),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(
                              14,
                            ),
                          ),
                        ),
                        child: const Text(
                          "Confirm",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );

    if (confirmed == true) {
      await _performAppointmentSave();
    }
  }

  Widget _summaryRow(
    IconData icon,
    String label,
    String value,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(11),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF7F9),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: const Color(0xFFFF4D67),
            size: 18,
          ),
          const SizedBox(width: 9),
          Text(
            "$label:",
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 10.5,
            ),
          ),
          const Spacer(),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: const TextStyle(
                color: darkText,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BabyBg(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(25, 22, 25, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  backButton(context),
                  const SizedBox(width: 5),
                  Expanded(
                    child: Text(
                      "Book Appointment",
                      style: premiumHeadingStyle(size: 29),
                    ),
                  ),
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF4D67).withOpacity(.10),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.calendar_month_rounded,
                      color: Color(0xFFFF4D67),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 7),
              Text(
                "Choose a date, available time and approved pediatric specialist",
                style: premiumBody3D(
                  size: 11,
                  color: const Color(0xFF758398),
                ),
              ),
              const SizedBox(height: 20),

              calendar(),

              const SizedBox(height: 18),

              if (selectedDate != null)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF0F3),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: const Color(0xFFFFCCD5),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.event_available_rounded,
                        color: Color(0xFFFF4D67),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        "Selected: ${formatDate(selectedDate!)}",
                        style: const TextStyle(
                          color: darkText,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

              const SizedBox(height: 18),

              const Text(
                "Select Time",
                style: TextStyle(
                  color: darkText,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),

              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: times.map((time) {
                  final selected = selectedTime == time;

                  return ChoiceChip(
                    label: Text(time),
                    selected: selected,
                    selectedColor: const Color(0xFFFF4D67),
                    backgroundColor: Colors.white,
                    elevation: selected ? 6 : 0,
                    pressElevation: 2,
                    shadowColor:
                        const Color(0xFFFF4D67).withOpacity(.20),
                    side: BorderSide(
                      color: selected
                          ? const Color(0xFFFF4D67)
                          : const Color(0xFFFFD7DE),
                      width: selected ? 1.4 : 1,
                    ),
                    labelStyle: TextStyle(
                      color: selected ? Colors.white : darkText,
                      fontWeight: FontWeight.bold,
                    ),
                    onSelected: (_) {
                      setState(() => selectedTime = time);
                    },
                  );
                }).toList(),
              ),

              const SizedBox(height: 20),

              const Text(
                "Select Doctor",
                style: TextStyle(
                  color: darkText,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),

              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('doctors')
                    .where('approved', isEqualTo: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text(
                      "Doctors error: ${snapshot.error}",
                      style: const TextStyle(color: dangerColor),
                    );
                  }

                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  final doctors = snapshot.data!.docs;

                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.white,
                          mainColor.withOpacity(.035),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: mainColor.withOpacity(.12),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: mainColor.withOpacity(.07),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: DropdownButtonFormField<String>(
                      value: selectedDoctorId,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        prefixIcon: Icon(
                          Icons.medical_services_rounded,
                          color: mainColor,
                        ),
                      ),
                      hint: const Text("Choose approved doctor"),
                      items: doctors.map((doc) {
                        final data =
                            doc.data() as Map<String, dynamic>;
                        final name =
                            data['name']?.toString() ?? 'Doctor';
                        final spec =
                            data['specialization']?.toString() ?? '';

                        return DropdownMenuItem<String>(
                          value: doc.id,
                          child: Text(
                            spec.isEmpty ? name : "$name • $spec",
                          ),
                        );
                      }).toList(),
                      onChanged: (v) {
                        if (v == null) return;

                        final doc = doctors.firstWhere(
                          (element) => element.id == v,
                        );

                        final data =
                            doc.data() as Map<String, dynamic>;

                        setState(() {
                          selectedDoctorId = v;
                          selectedDoctorName =
                              data['name']?.toString() ?? 'Doctor';
                        });
                      },
                    ),
                  );
                },
              ),

              const SizedBox(height: 24),

              saving
                  ? const Center(child: CircularProgressIndicator())
                  : SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton.icon(
                        onPressed: saveAppointment,
                        icon: const Icon(
                          Icons.event_available_rounded,
                          color: Colors.white,
                        ),
                        label: const Text(
                          "Confirm Booking",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFF4D67),
                          elevation: 8,
                          shadowColor:
                              const Color(0xFFFF4D67).withOpacity(.28),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

/* ===================== DOCTOR APPOINTMENTS SCREEN ===================== */

class DoctorAppointmentsScreen extends StatelessWidget {
  const DoctorAppointmentsScreen({super.key});

  Color statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed':
        return successColor;
      case 'rejected':
      case 'cancelled':
        return dangerColor;
      default:
        return warningColor;
    }
  }

  Future<void> updateStatus(
    BuildContext context,
    String appointmentId,
    String status,
  ) async {
    try {
      final appointmentRef = FirebaseFirestore.instance
          .collection('appointments')
          .doc(appointmentId);

      final appointmentDoc = await appointmentRef.get();
      final appointmentData = appointmentDoc.data() ?? <String, dynamic>{};

      await appointmentRef.update({
        'status': status,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      final motherUid = appointmentData['motherUid']?.toString() ?? '';
      final doctorName =
          appointmentData['doctorName']?.toString() ?? 'Doctor';
      final dateText = appointmentData['dateText']?.toString() ?? '';
      final time = appointmentData['time']?.toString() ?? '';

      if (motherUid.isNotEmpty) {
        await FirebaseFirestore.instance.collection('notifications').add({
          'userId': motherUid,
          'type': 'appointment',
          'title': status == 'Confirmed'
              ? 'Appointment Confirmed'
              : 'Appointment Update',
          'message': status == 'Confirmed'
              ? '$doctorName confirmed your appointment on $dateText at $time.'
              : '$doctorName changed your appointment status to $status.',
          'isRead': false,
          'createdAt': FieldValue.serverTimestamp(),
        });
      }

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Appointment $status")),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Could not update appointment: $e")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final doctor = FirebaseAuth.instance.currentUser;

    if (doctor == null) {
      return Scaffold(
        body: BabyBg(
          child: const Center(child: Text("Please login first")),
        ),
      );
    }

    return Scaffold(
      body: BabyBg(
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('appointments')
              .where('doctorId', isEqualTo: doctor.uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text(
                  "Appointments error: ${snapshot.error}",
                ),
              );
            }

            if (!snapshot.hasData) {
              return const Padding(
                padding: EdgeInsets.all(22),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SkeletonCard(height: 96),
                    SkeletonCard(height: 96),
                    SkeletonCard(height: 96),
                  ],
                ),
              );
            }

            final docs = snapshot.data!.docs.toList();

            docs.sort((a, b) {
              final aData = a.data() as Map<String, dynamic>;
              final bData = b.data() as Map<String, dynamic>;
              final aTime = aData['date'] as Timestamp?;
              final bTime = bData['date'] as Timestamp?;

              if (aTime == null && bTime == null) return 0;
              if (aTime == null) return 1;
              if (bTime == null) return -1;

              return aTime.compareTo(bTime);
            });

            return ListView(
              padding: const EdgeInsets.all(25),
              children: [
                backButton(context),
                const Text(
                  "Appointments",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: darkText,
                  ),
                ),
                const SizedBox(height: 20),

                if (docs.isEmpty)
                  const Padding(
                    padding: EdgeInsets.only(top: 70),
                    child: Center(
                      child: Column(
                        children: [
                          Icon(
                            Icons.event_busy,
                            size: 70,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 12),
                          Text(
                            "No appointments yet",
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  ...docs.map((doc) {
                    final data =
                        doc.data() as Map<String, dynamic>;

                    final babyName =
                        data['babyName']?.toString() ?? 'Baby';
                    final motherEmail =
                        data['motherEmail']?.toString() ?? '';
                    final dateText =
                        data['dateText']?.toString() ?? '';
                    final time = data['time']?.toString() ?? '';
                    final status =
                        data['status']?.toString() ?? 'Pending';
                    final color = statusColor(status);

                    return Card(
                      elevation: 5,
                      margin: const EdgeInsets.only(bottom: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(14),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor:
                                      mainColor.withOpacity(.15),
                                  child: const Icon(
                                    Icons.child_care,
                                    color: mainColor,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        babyName,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 17,
                                          color: darkText,
                                        ),
                                      ),
                                      Text(
                                        motherEmail,
                                        style: const TextStyle(
                                          color: Colors.grey,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 5,
                                  ),
                                  decoration: BoxDecoration(
                                    color: color.withOpacity(.15),
                                    borderRadius:
                                        BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    status,
                                    style: TextStyle(
                                      color: color,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                const Icon(
                                  Icons.calendar_today,
                                  size: 18,
                                  color: medicalBlue,
                                ),
                                const SizedBox(width: 7),
                                Text(dateText),
                                const SizedBox(width: 18),
                                const Icon(
                                  Icons.access_time,
                                  size: 18,
                                  color: warningColor,
                                ),
                                const SizedBox(width: 7),
                                Text(time),
                              ],
                            ),
                            if (status == 'Pending') ...[
                              const SizedBox(height: 14),
                              Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: () => updateStatus(
                                        context,
                                        doc.id,
                                        'Confirmed',
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: successColor,
                                      ),
                                      child: const Text(
                                        "Confirm",
                                        style:
                                            TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: () => updateStatus(
                                        context,
                                        doc.id,
                                        'Rejected',
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: dangerColor,
                                      ),
                                      child: const Text(
                                        "Reject",
                                        style:
                                            TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),
                    );
                  }),
              ],
            );
          },
        ),
      ),
    );
  }
}

/* ===================== REAL AUDIO RECORDING SCREEN ===================== */

class RecordingScreen extends StatefulWidget {
  const RecordingScreen({super.key});

  @override
  State<RecordingScreen> createState() => _RecordingScreenState();
}

class _RecordingScreenState extends State<RecordingScreen> {
  final AudioRecorder _recorder = AudioRecorder();
  bool _isRecording = false;
  bool _isStarting = false;
  String? _recordedPath;
  int _seconds = 0;
  StreamSubscription<RecordState>? _stateSub;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _stateSub = _recorder.onStateChanged().listen((state) {
      if (!mounted) return;
      setState(() => _isRecording = state == RecordState.record);
    });
  }

  void _startTimer() {
    _timer?.cancel();
    _seconds = 0;
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() => _seconds++);
    });
  }

  Future<void> _startRecording() async {
    if (_isStarting || _isRecording) return;
    setState(() => _isStarting = true);
    try {
      final allowed = await _recorder.hasPermission();
      if (!allowed) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Microphone permission is required.')),
          );
        }
        return;
      }

      await _recorder.start(
        const RecordConfig(
          encoder: AudioEncoder.aacLc,
          sampleRate: 44100,
          numChannels: 1,
          echoCancel: true,
          noiseSuppress: true,
        ),
        path: '', // record package uses a browser Blob URL on Flutter Web.
      );
      _startTimer();
      if (mounted) setState(() => _recordedPath = null);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not start recording: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isStarting = false);
    }
  }

  Future<void> _stopRecording() async {
    if (!_isRecording) return;
    try {
      final path = await _recorder.stop();
      _timer?.cancel();
      if (mounted) {
        setState(() {
          _recordedPath = path;
          _isRecording = false;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not stop recording: $e')),
        );
      }
    }
  }

  String get _durationText {
    final m = (_seconds ~/ 60).toString().padLeft(2, '0');
    final sec = (_seconds % 60).toString().padLeft(2, '0');
    return '$m:$sec';
  }

  @override
  void dispose() {
    _timer?.cancel();
    _stateSub?.cancel();
    _recorder.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final accent =
        _isRecording ? dangerColor : const Color(0xFF00AAA8);

    return Scaffold(
      body: BabyBg(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 980),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  backButton(context),
                  const SizedBox(height: 4),

                  Row(
                    children: [
                      Container(
                        width: 49,
                        height: 49,
                        decoration: BoxDecoration(
                          color: accent.withOpacity(.10),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: accent.withOpacity(.20),
                              blurRadius: 15,
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.graphic_eq_rounded,
                          color: accent,
                        ),
                      ),
                      const SizedBox(width: 11),
                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Infant Cry AI Studio",
                              style: TextStyle(
                                color: dark
                                    ? Colors.white
                                    : darkText,
                                fontSize: 27,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            Text(
                              "Capture a clean cry sample for intelligent pediatric analysis",
                              style: TextStyle(
                                color: dark
                                    ? Colors.white54
                                    : Colors.grey,
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ),
                      PremiumStatusPill(
                        text: _isRecording
                            ? "RECORDING"
                            : _recordedPath != null
                                ? "CAPTURED"
                                : "READY",
                        color: _isRecording
                            ? dangerColor
                            : _recordedPath != null
                                ? successColor
                                : mainColor,
                        icon: _isRecording
                            ? Icons.circle
                            : Icons.mic_rounded,
                      ),
                    ],
                  ),

                  const SizedBox(height: 18),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      color: dark
                          ? const Color(0xFF0E2133).withOpacity(.94)
                          : Colors.white.withOpacity(.93),
                      borderRadius: BorderRadius.circular(31),
                      border: Border.all(
                        color: dark
                            ? Colors.white.withOpacity(.06)
                            : Colors.white,
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: accent.withOpacity(.13),
                          blurRadius: 30,
                          offset: const Offset(0, 14),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // animated mic core
                        TweenAnimationBuilder<double>(
                          tween: Tween(
                            begin: .94,
                            end: _isRecording ? 1.08 : 1,
                          ),
                          duration:
                              const Duration(milliseconds: 650),
                          curve: Curves.easeInOut,
                          builder: (context, scale, child) {
                            return Transform.scale(
                              scale: scale,
                              child: child,
                            );
                          },
                          child: SizedBox(
                            width: 230,
                            height: 230,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                for (int i = 0; i < 3; i++)
                                  Container(
                                    width: 150.0 + i * 34,
                                    height: 150.0 + i * 34,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: accent.withOpacity(
                                          .17 - i * .035,
                                        ),
                                        width: 1.5,
                                      ),
                                    ),
                                  ),
                                Container(
                                  width: 122,
                                  height: 122,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        accent,
                                        _isRecording
                                            ? const Color(
                                                0xFFFF7B86,
                                              )
                                            : medicalBlue,
                                      ],
                                    ),
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color:
                                            accent.withOpacity(.35),
                                        blurRadius: 30,
                                        spreadRadius: 3,
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    _isRecording
                                        ? Icons
                                            .graphic_eq_rounded
                                        : Icons.mic_rounded,
                                    color: Colors.white,
                                    size: 57,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        Text(
                          _durationText,
                          style: TextStyle(
                            color: dark
                                ? Colors.white
                                : darkText,
                            fontSize: 38,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.2,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          _isRecording
                              ? "Listening to infant cry..."
                              : _recordedPath != null
                                  ? "Audio sample captured successfully"
                                  : "Keep the device close to the baby",
                          style: TextStyle(
                            color: _isRecording
                                ? dangerColor
                                : dark
                                    ? Colors.white54
                                    : Colors.grey,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        const SizedBox(height: 19),

                        // waveform
                        Container(
                          height: 92,
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 9,
                          ),
                          decoration: BoxDecoration(
                            color: accent.withOpacity(.035),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: accent.withOpacity(.07),
                            ),
                          ),
                          child: Row(
                            crossAxisAlignment:
                                CrossAxisAlignment.center,
                            children: List.generate(
                              42,
                              (i) {
                                final base =
                                    8.0 + ((i * 17) % 37);
                                final h = _isRecording
                                    ? base *
                                        (.70 +
                                            ((_seconds + i) %
                                                    5) *
                                                .10)
                                    : 7.0 + (i % 4) * 2.0;

                                return Expanded(
                                  child: Center(
                                    child: AnimatedContainer(
                                      duration:
                                          const Duration(
                                        milliseconds: 160,
                                      ),
                                      height: h,
                                      margin:
                                          const EdgeInsets.symmetric(
                                        horizontal: 1,
                                      ),
                                      decoration: BoxDecoration(
                                        color:
                                            accent.withOpacity(
                                          _isRecording
                                              ? .78
                                              : .24,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(
                                          10,
                                        ),
                                        boxShadow: _isRecording
                                            ? [
                                                BoxShadow(
                                                  color: accent
                                                      .withOpacity(
                                                    .22,
                                                  ),
                                                  blurRadius: 5,
                                                ),
                                              ]
                                            : null,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        SizedBox(
                          width: double.infinity,
                          height: 54,
                          child: ElevatedButton.icon(
                            onPressed: _isStarting
                                ? null
                                : (_isRecording
                                    ? _stopRecording
                                    : _startRecording),
                            icon: Icon(
                              _isRecording
                                  ? Icons.stop_rounded
                                  : Icons.mic_rounded,
                            ),
                            label: Text(
                              _isStarting
                                  ? "Preparing microphone..."
                                  : _isRecording
                                      ? "Stop Recording"
                                      : _recordedPath == null
                                          ? "Start Recording"
                                          : "Record Again",
                              style: const TextStyle(
                                fontWeight:
                                    FontWeight.w900,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: accent,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(17),
                              ),
                            ),
                          ),
                        ),

                        if (_recordedPath != null &&
                            !_isRecording) ...[
                          const SizedBox(height: 11),
                          SizedBox(
                            width: double.infinity,
                            height: 54,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        const ResultScreen(),
                                  ),
                                );
                              },
                              icon: const Icon(
                                Icons.auto_awesome_rounded,
                              ),
                              label: const Text(
                                "Analyze Cry with AI",
                                style: TextStyle(
                                  fontWeight:
                                      FontWeight.w900,
                                ),
                              ),
                              style:
                                  ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color(0xFF7B61E8),
                                foregroundColor: Colors.white,
                                shape:
                                    RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(
                                    17,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),

                  const SizedBox(height: 14),

                  LayoutBuilder(
                    builder: (context, c) {
                      final wide = c.maxWidth > 680;
                      final tips = [
                        _recordTip(
                          Icons.phone_iphone_rounded,
                          "Keep Close",
                          "Place the device near the baby",
                          mainColor,
                          dark,
                        ),
                        _recordTip(
                          Icons.volume_off_rounded,
                          "Quiet Space",
                          "Reduce background noise",
                          medicalBlue,
                          dark,
                        ),
                        _recordTip(
                          Icons.timer_outlined,
                          "Clean Sample",
                          "Capture a few clear seconds",
                          const Color(0xFF7B61E8),
                          dark,
                        ),
                      ];

                      if (wide) {
                        return Row(
                          children: [
                            Expanded(child: tips[0]),
                            const SizedBox(width: 10),
                            Expanded(child: tips[1]),
                            const SizedBox(width: 10),
                            Expanded(child: tips[2]),
                          ],
                        );
                      }

                      return Column(
                        children: [
                          tips[0],
                          const SizedBox(height: 8),
                          tips[1],
                          const SizedBox(height: 8),
                          tips[2],
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _recordTip(
    IconData icon,
    String title,
    String subtitle,
    Color color,
    bool dark,
  ) {
    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: dark
            ? const Color(0xFF10283B).withOpacity(.92)
            : Colors.white.withOpacity(.87),
        borderRadius: BorderRadius.circular(19),
        border: Border.all(
          color: dark
              ? Colors.white.withOpacity(.05)
              : Colors.white,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: color.withOpacity(.10),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: color,
              size: 18,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color:
                        dark ? Colors.white : darkText,
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: dark
                        ? Colors.white54
                        : Colors.grey,
                    fontSize: 8,
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

/* ===================== RESULT SCREEN ===================== */

class ResultScreen extends StatefulWidget {
  const ResultScreen({super.key});

  @override
  State<ResultScreen> createState() =>
      _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen>
    with SingleTickerProviderStateMixin {
  bool savingResult = false;
  bool resultSaved = false;

  late final AnimationController pulseController;

  final String cryType = "Hunger";
  final String confidence = "87%";
  final String riskLevel = "Low";
  final String recommendation = "Try feeding";

  @override
  void initState() {
    super.initState();

    pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    pulseController.dispose();
    super.dispose();
  }

  Future<void> saveResultToHistory() async {
    if (savingResult || resultSaved) return;

    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please login first"),
        ),
      );
      return;
    }

    setState(() => savingResult = true);

    try {
      String babyName = "Baby";

      final profileDoc = await FirebaseFirestore.instance
          .collection('infant_profiles')
          .doc(user.uid)
          .get();

      if (profileDoc.exists) {
        babyName =
            profileDoc.data()?['babyName']?.toString() ??
                "Baby";
      }

      await FirebaseFirestore.instance
          .collection('monitoring_history')
          .add({
        'motherUid': user.uid,
        'motherEmail': user.email ?? '',
        'babyName': babyName,
        'cryType': cryType,
        'confidence': confidence,
        'riskLevel': riskLevel,
        'recommendation': recommendation,
        'createdAt': FieldValue.serverTimestamp(),
      });

      if (mounted) {
        setState(() {
          resultSaved = true;
        });

        await showPremiumSuccess(
          context,
          title: "Analysis Saved",
          message:
              "The cry-analysis result has been added to the baby's monitoring history.",
          icon: Icons.auto_awesome_rounded,
          color: successColor,
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text("Could not save result: $e"),
          ),
        );
      }
    }

    if (mounted) {
      setState(() => savingResult = false);
    }
  }

  Widget probabilityBar(
    String label,
    double value,
    Color color,
  ) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  color: darkText,
                  fontSize: 10.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Text(
              "${(value * 100).round()}%",
              style: TextStyle(
                color: color,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 5),
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: LinearProgressIndicator(
            value: value,
            minHeight: 7,
            backgroundColor:
                color.withOpacity(.08),
            color: color,
          ),
        ),
      ],
    );
  }

  Widget metricCard(
    IconData icon,
    String title,
    String value,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: color.withOpacity(.09),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: color.withOpacity(.10),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: color,
              size: 19,
            ),
          ),
          const SizedBox(width: 9),
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 8.5,
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    color: darkText,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BabyBg(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            22,
            20,
            22,
            30,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints:
                  const BoxConstraints(maxWidth: 930),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  backButton(context),
                  const SizedBox(height: 4),
                  const Text(
                    "AI Cry Analysis • Clinical View",
                    style: TextStyle(
                      color: darkText,
                      fontSize: 29,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    "Cry pattern interpreted into a clear pediatric insight.",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 11,
                    ),
                  ),
                  const SizedBox(height: 18),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFFF5F1FF),
                          Color(0xFFF1FBFF),
                          Colors.white,
                        ],
                      ),
                      borderRadius:
                          BorderRadius.circular(28),
                      boxShadow: [
                        BoxShadow(
                          color:
                              const Color(0xFF7B61E8)
                                  .withOpacity(.07),
                          blurRadius: 20,
                          offset:
                              const Offset(0, 9),
                        ),
                      ],
                    ),
                    child: LayoutBuilder(
                      builder: (context, c) {
                        final wide =
                            c.maxWidth > 700;

                        final visual =
                            AnimatedBuilder(
                          animation:
                              pulseController,
                          builder: (context, _) {
                            final v =
                                pulseController.value;

                            return SizedBox(
                              width: 220,
                              height: 205,
                              child: Stack(
                                alignment:
                                    Alignment.center,
                                children: [
                                  Container(
                                    width:
                                        180 + v * 14,
                                    height:
                                        180 + v * 14,
                                    decoration:
                                        BoxDecoration(
                                      shape:
                                          BoxShape.circle,
                                      border:
                                          Border.all(
                                        color: const Color(
                                          0xFF7B61E8,
                                        ).withOpacity(
                                          .11 +
                                              v * .08,
                                        ),
                                        width: 2,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 150,
                                    height: 150,
                                    child:
                                        CircularProgressIndicator(
                                      value: .87,
                                      strokeWidth: 9,
                                      backgroundColor:
                                          const Color(
                                        0xFF7B61E8,
                                      ).withOpacity(.08),
                                      color:
                                          const Color(
                                        0xFF7B61E8,
                                      ),
                                    ),
                                  ),
                                  const Column(
                                    mainAxisSize:
                                        MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons
                                            .graphic_eq_rounded,
                                        color: Color(
                                          0xFF7B61E8,
                                        ),
                                        size: 42,
                                      ),
                                      SizedBox(height: 3),
                                      Text(
                                        "87%",
                                        style: TextStyle(
                                          color: darkText,
                                          fontSize: 25,
                                          fontWeight:
                                              FontWeight
                                                  .bold,
                                        ),
                                      ),
                                      Text(
                                        "AI Confidence",
                                        style: TextStyle(
                                          color:
                                              Colors.grey,
                                          fontSize: 9,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        );

                        final content = Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            const PremiumStatusPill(
                              text:
                                  "ANALYSIS COMPLETE",
                              color: successColor,
                              icon: Icons
                                  .check_circle_rounded,
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              "Detected Cry Type",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 10,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              cryType,
                              style: premiumMetricStyle(
                                size: 34,
                                color: const Color(0xFF7B61E8),
                              ),
                            ),
                            const SizedBox(height: 7),
                            const Text(
                              "The acoustic pattern most strongly matches a hunger-related cry.",
                              style: TextStyle(
                                color:
                                    Color(0xFF5B6680),
                                fontSize: 11,
                                height: 1.4,
                              ),
                            ),
                            const SizedBox(height: 13),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: [
                                PremiumStatusPill(
                                  text:
                                      "Risk: $riskLevel",
                                  color:
                                      successColor,
                                  icon: Icons
                                      .shield_rounded,
                                ),
                                PremiumStatusPill(
                                  text:
                                      "Confidence: $confidence",
                                  color:
                                      medicalBlue,
                                  icon: Icons
                                      .analytics_rounded,
                                ),
                              ],
                            ),
                          ],
                        );

                        if (wide) {
                          return Row(
                            children: [
                              visual,
                              const SizedBox(
                                width: 22,
                              ),
                              Expanded(
                                child: content,
                              ),
                            ],
                          );
                        }

                        return Column(
                          children: [
                            visual,
                            const SizedBox(
                              height: 8,
                            ),
                            content,
                          ],
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 15),

                  Container(
                    padding: const EdgeInsets.all(17),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.circular(23),
                    ),
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "AI Probability Map",
                          style: TextStyle(
                            color: darkText,
                            fontSize: 16,
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 13),
                        probabilityBar(
                          "Hunger",
                          .87,
                          const Color(0xFF7B61E8),
                        ),
                        const SizedBox(height: 11),
                        probabilityBar(
                          "Discomfort",
                          .08,
                          warningColor,
                        ),
                        const SizedBox(height: 11),
                        probabilityBar(
                          "Pain",
                          .03,
                          dangerColor,
                        ),
                        const SizedBox(height: 11),
                        probabilityBar(
                          "Sleepy",
                          .02,
                          medicalBlue,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 15),

                  LayoutBuilder(
                    builder: (context, c) {
                      final cols =
                          c.maxWidth > 650 ? 3 : 1;

                      return GridView.count(
                        crossAxisCount: cols,
                        shrinkWrap: true,
                        physics:
                            const NeverScrollableScrollPhysics(),
                        mainAxisSpacing: 9,
                        crossAxisSpacing: 9,
                        mainAxisExtent: 66,
                        children: [
                          metricCard(
                            Icons.shield_rounded,
                            "Risk Level",
                            riskLevel,
                            successColor,
                          ),
                          metricCard(
                            Icons.lightbulb_rounded,
                            "Care Guidance",
                            recommendation,
                            warningColor,
                          ),
                          metricCard(
                            Icons.history_rounded,
                            "Monitoring",
                            "Ready to save",
                            mainColor,
                          ),
                        ],
                      );
                    },
                  ),

                  const SizedBox(height: 15),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color:
                          const Color(0xFFEFFBFC),
                      borderRadius:
                          BorderRadius.circular(20),
                    ),
                    child: const Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.white,
                          child: Icon(
                            Icons
                                .medical_information_rounded,
                            color: mainColor,
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Pediatric Recommendation",
                                style: TextStyle(
                                  color: darkText,
                                  fontSize: 11,
                                  fontWeight:
                                      FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                "Try feeding and continue monitoring the baby. Escalate to a doctor if the crying pattern becomes unusual or persistent.",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 9.5,
                                  height: 1.35,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  savingResult
                      ? const Center(
                          child:
                              CircularProgressIndicator(),
                        )
                      : mainButton(
                          resultSaved
                              ? "Saved to History"
                              : "Save Analysis",
                          resultSaved
                              ? Icons
                                  .check_circle_rounded
                              : Icons
                                  .history_rounded,
                          saveResultToHistory,
                          color: resultSaved
                              ? successColor
                              : const Color(
                                  0xFF7B61E8,
                                ),
                        ),

                  const SizedBox(height: 10),

                  mainButton(
                    "Open Medical Report",
                    Icons.description_rounded,
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              const MedicalReportScreen(),
                        ),
                      );
                    },
                    color: medicalBlue,
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

/* ===================== MEDICAL REPORT SCREEN ===================== */

class MedicalReportScreen extends StatelessWidget {
  const MedicalReportScreen({super.key});

  String formatTimestamp(Timestamp? timestamp) {
    if (timestamp == null) return "--";

    final d = timestamp.toDate();

    String two(int n) => n.toString().padLeft(2, '0');

    return "${two(d.day)}/${two(d.month)}/${d.year} "
        "${two(d.hour)}:${two(d.minute)}";
  }

  Widget metric(
    IconData icon,
    String title,
    String value,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(11),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white,
            color.withOpacity(.035),
          ],
        ),
        borderRadius: BorderRadius.circular(17),
        border: Border.all(
          color: color.withOpacity(.10),
        ),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(.06),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 33,
            height: 33,
            decoration: BoxDecoration(
              color: color.withOpacity(.10),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: color,
              size: 17,
            ),
          ),
          const SizedBox(width: 7),
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 8.5,
                  ),
                ),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: darkText,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  "Normal",
                  style: TextStyle(
                    color: successColor,
                    fontSize: 8.5,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Scaffold(
        body: Center(child: Text("Please login first")),
      );
    }

    return Scaffold(
      body: BabyBg(
        child: FutureBuilder<QuerySnapshot>(
          future: FirebaseFirestore.instance
              .collection('monitoring_history')
              .where('motherUid', isEqualTo: user.uid)
              .get(),
          builder: (context, historySnapshot) {
            if (!historySnapshot.hasData) {
              return const Padding(
                padding: EdgeInsets.all(22),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SkeletonCard(height: 96),
                    SkeletonCard(height: 96),
                    SkeletonCard(height: 96),
                  ],
                ),
              );
            }

            final docs =
                historySnapshot.data!.docs.toList();

            docs.sort((a, b) {
              final ad =
                  a.data() as Map<String, dynamic>;

              final bd =
                  b.data() as Map<String, dynamic>;

              final at =
                  ad['createdAt'] as Timestamp?;

              final bt =
                  bd['createdAt'] as Timestamp?;

              if (at == null || bt == null) {
                return 0;
              }

              return bt.compareTo(at);
            });

            final latest = docs.isEmpty
                ? <String, dynamic>{}
                : docs.first.data()
                    as Map<String, dynamic>;

            return FutureBuilder<
                DocumentSnapshot<Map<String, dynamic>>>(
              future: FirebaseFirestore.instance
                  .collection('infant_profiles')
                  .doc(user.uid)
                  .get(),
              builder: (context, profileSnapshot) {
                final profile =
                    profileSnapshot.data?.data() ?? {};

                final baby =
                    profile['babyName']?.toString() ??
                        "Baby";

                final type =
                    latest['cryType']?.toString() ?? "--";

                final confidence =
                    latest['confidence']?.toString() ??
                        "--";

                final risk =
                    latest['riskLevel']?.toString() ??
                        "--";

                final recommendation =
                    latest['recommendation']?.toString() ??
                        "--";

                return SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(
                    20,
                    18,
                    20,
                    28,
                  ),
                  child: Center(
                    child: ConstrainedBox(
                      constraints:
                          const BoxConstraints(
                        maxWidth: 900,
                      ),
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              backButton(context),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Pediatric Medical Report",
                                      style: premiumHeadingStyle(
                                        size: 27,
                                      ),
                                    ),
                                    Text(
                                      "AI-assisted child health summary",
                                      style: premiumBody3D(
                                        size: 9.5,
                                        color: const Color(
                                          0xFF758398,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const PremiumStatusPill(
                                text: "VERIFIED FORMAT",
                                color: successColor,
                                icon: Icons.verified_rounded,
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Colors.white,
                                  Color(0xFFF0FCFF),
                                  Color(0xFFF8F4FF),
                                ],
                              ),
                              borderRadius:
                                  BorderRadius.circular(25),
                              border: Border.all(
                                color: Colors.white,
                                width: 1.4,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: mainColor.withOpacity(.10),
                                  blurRadius: 22,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 72,
                                  height: 72,
                                  decoration: BoxDecoration(
                                    color: mainColor
                                        .withOpacity(.09),
                                    borderRadius:
                                        BorderRadius.circular(
                                      19,
                                    ),
                                  ),
                                  child: const Icon(
                                    Icons.health_and_safety_rounded,
                                    color: mainColor,
                                    size: 38,
                                  ),
                                ),
                                const SizedBox(width: 14),
                                const Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "AI Generated Report",
                                        style: TextStyle(
                                          color: medicalBlue,
                                          fontSize: 10,
                                          fontWeight:
                                              FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 7),
                                      Row(
                                        children: [
                                          CircleAvatar(
                                            radius: 16,
                                            backgroundColor:
                                                Color(
                                              0xFFE8FFF2,
                                            ),
                                            child: Icon(
                                              Icons.verified_rounded,
                                              color:
                                                  successColor,
                                              size: 18,
                                            ),
                                          ),
                                          SizedBox(width: 8),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Overall Health Status",
                                                style:
                                                    TextStyle(
                                                  color:
                                                      successColor,
                                                  fontSize: 8.5,
                                                ),
                                              ),
                                              Text(
                                                "Excellent",
                                                style:
                                                    TextStyle(
                                                  color: darkText,
                                                  fontSize: 17,
                                                  fontWeight:
                                                      FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 12),

                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color:
                                  const Color(0xFFF1FBFD),
                              borderRadius:
                                  BorderRadius.circular(21),
                            ),
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Report Summary",
                                  style: TextStyle(
                                    color: darkText,
                                    fontSize: 15,
                                    fontWeight:
                                        FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  "$baby's latest cry analysis is $type with $confidence confidence. Risk level: $risk. Recommendation: $recommendation.",
                                  style: const TextStyle(
                                    color:
                                        Color(0xFF59647E),
                                    fontSize: 10.5,
                                    height: 1.4,
                                  ),
                                ),
                                const SizedBox(height: 13),
                                LayoutBuilder(
                                  builder: (context, c) {
                                    final columns =
                                        c.maxWidth > 650
                                            ? 4
                                            : 2;

                                    return GridView.count(
                                      crossAxisCount:
                                          columns,
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      crossAxisSpacing: 8,
                                      mainAxisSpacing: 8,
                                      mainAxisExtent: 68,
                                      children: [
                                        metric(
                                          Icons.favorite_rounded,
                                          "Cry Type",
                                          type,
                                          Colors.redAccent,
                                        ),
                                        metric(
                                          Icons.analytics_rounded,
                                          "Confidence",
                                          confidence,
                                          Colors.purple,
                                        ),
                                        metric(
                                          Icons.shield_rounded,
                                          "Risk Level",
                                          risk,
                                          medicalBlue,
                                        ),
                                        metric(
                                          Icons.lightbulb_rounded,
                                          "Recommendation",
                                          recommendation,
                                          warningColor,
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 9),

                          Text(
                            "Generated from latest analysis • ${formatTimestamp(latest['createdAt'] as Timestamp?)}",
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 9.5,
                            ),
                          ),

                          const SizedBox(height: 13),

                          mainButton(
                            "Download Report",
                            Icons.download_rounded,
                            () {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    "Report is ready for export ✅",
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

/* ===================== DOCTOR GATEWAY ===================== */

class DoctorGatewayScreen extends StatelessWidget {
  const DoctorGatewayScreen({super.key});

  Widget optionCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required Widget page,
  }) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => page),
        );
      },
      borderRadius: BorderRadius.circular(24),
      child: Container(
        padding: const EdgeInsets.all(17),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: color.withOpacity(.10),
          ),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(.06),
              blurRadius: 16,
              offset: const Offset(0, 7),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 58,
              height: 58,
              decoration: BoxDecoration(
                color: color.withOpacity(.10),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: color,
                size: 28,
              ),
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
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 10.5,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: color,
              size: 17,
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
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 780,
              ),
              child: Column(
                children: [
                  backButton(context),
                  const SizedBox(height: 5),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(.95),
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: medicalBlue.withOpacity(.07),
                          blurRadius: 23,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: const Column(
                      children: [
                        CircleAvatar(
                          radius: 47,
                          backgroundColor: Color(0xFFEAF4FF),
                          child: Icon(
                            Icons.medical_services_rounded,
                            color: medicalBlue,
                            size: 48,
                          ),
                        ),
                        SizedBox(height: 14),
                        Text(
                          "Doctor Portal",
                          style: TextStyle(
                            color: darkText,
                            fontSize: 29,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          "Secure pediatric consultation and patient monitoring workspace.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  optionCard(
                    context: context,
                    title: "Doctor Login",
                    subtitle:
                        "Access your consultations, appointments and patient information.",
                    icon: Icons.login_rounded,
                    color: medicalBlue,
                    page: const LoginScreen(expectedRole: 'doctor'),
                  ),
                  const SizedBox(height: 11),
                  optionCard(
                    context: context,
                    title: "New Doctor Registration",
                    subtitle:
                        "Submit medical license and professional details for admin approval.",
                    icon: Icons.person_add_alt_1_rounded,
                    color: mainColor,
                    page: const DoctorRegisterScreen(),
                  ),
                  const SizedBox(height: 13),
                  Container(
                    padding: const EdgeInsets.all(13),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFFBFC),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: const Row(
                      children: [
                        Icon(
                          Icons.verified_rounded,
                          color: successColor,
                        ),
                        SizedBox(width: 9),
                        Expanded(
                          child: Text(
                            "Only admin-approved pediatric doctors can access clinical consultation features.",
                            style: TextStyle(
                              color: darkText,
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
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

/* ===================== DOCTOR REGISTER SCREEN ===================== */

class DoctorRegisterScreen extends StatefulWidget {
  const DoctorRegisterScreen({super.key});

  @override
  State<DoctorRegisterScreen> createState() => _DoctorRegisterScreenState();
}

class _DoctorRegisterScreenState extends State<DoctorRegisterScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final specializationController = TextEditingController();
  final licenseController = TextEditingController();
  final experienceController = TextEditingController();
  bool loading = false;

  Future<void> submitDoctor() async {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final specialization = specializationController.text.trim();
    final license = licenseController.text.trim();
    final experience = experienceController.text.trim();

    if (name.isEmpty ||
        email.isEmpty ||
        password.length < 6 ||
        specialization.isEmpty ||
        license.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please complete all required fields")),
      );
      return;
    }

    setState(() => loading = true);

    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await FirebaseFirestore.instance
          .collection('doctors')
          .doc(credential.user!.uid)
          .set({
        'uid': credential.user!.uid,
        'name': name,
        'email': email,
        'specialization': specialization,
        'licenseId': license,
        'experience': experience,
        'certificate': 'Uploaded',
        'approved': false,
        'createdAt': FieldValue.serverTimestamp(),
      });

      await FirebaseAuth.instance.signOut();

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const PendingApprovalScreen(),
        ),
      );
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? "Doctor registration failed")),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Doctor registration error: $e")),
      );
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    specializationController.dispose();
    licenseController.dispose();
    experienceController.dispose();
    super.dispose();
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
                    controller: passwordController,
                    obscureText: true,
                    decoration: inputField("Password", Icons.lock_outline),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: specializationController,
                    decoration: inputField(
                      "Specialization",
                      Icons.medical_services,
                    ),
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
                  loading
                      ? const CircularProgressIndicator()
                      : mainButton(
                          "Submit for Admin Approval",
                          Icons.upload,
                          submitDoctor,
                        ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: loading
                        ? null
                        : () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    const LoginScreen(expectedRole: 'doctor'),
                              ),
                            );
                          },
                    child: const Text("Already registered? Doctor Login"),
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

  Widget statCard(
    String count,
    String title,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: color.withOpacity(.09),
        ),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(.05),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withOpacity(.10),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: color,
              size: 21,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            count,
            style: TextStyle(
              color: color,
              fontSize: 19,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: darkText,
              fontSize: 9,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget requestCard(
    BuildContext context,
    QueryDocumentSnapshot doctor,
  ) {
    final data =
        doctor.data() as Map<String, dynamic>;

    final name =
        data['name']?.toString() ?? 'No Name';

    final license =
        data['licenseId']?.toString() ?? 'No License';

    final specialization =
        data['specialization']?.toString() ?? 'Not specified';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(23),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.03),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: medicalBlue.withOpacity(.10),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.medical_services_rounded,
                  color: medicalBlue,
                  size: 27,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        color: darkText,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      specialization,
                      style: const TextStyle(
                        color: medicalBlue,
                        fontSize: 10.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      "License: $license",
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 9,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: warningColor.withOpacity(.10),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  "Pending",
                  style: TextStyle(
                    color: warningColor,
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 13),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () async {
                    await FirebaseFirestore.instance
                        .collection('doctors')
                        .doc(doctor.id)
                        .update({
                      'approved': true,
                    });

                    if (context.mounted) {
                      await showPremiumSuccess(
                        context,
                        title: "Doctor Approved",
                        message:
                            "The pediatric doctor now has approved access to clinical features.",
                        icon: Icons.verified_rounded,
                        color: successColor,
                      );
                    }
                  },
                  icon: const Icon(
                    Icons.check_circle_rounded,
                    color: Colors.white,
                    size: 18,
                  ),
                  label: const Text(
                    "Approve",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: successColor,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 9),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () async {
                    await FirebaseFirestore.instance
                        .collection('doctors')
                        .doc(doctor.id)
                        .delete();

                    if (context.mounted) {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(
                        const SnackBar(
                          content:
                              Text("Doctor rejected"),
                        ),
                      );
                    }
                  },
                  icon: const Icon(
                    Icons.close_rounded,
                    color: Colors.white,
                    size: 18,
                  ),
                  label: const Text(
                    "Reject",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: dangerColor,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
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
              .snapshots(),
          builder: (context, doctorSnapshot) {
            if (doctorSnapshot.hasError) {
              return Center(
                child: Text(
                  "Admin error: ${doctorSnapshot.error}",
                ),
              );
            }

            if (!doctorSnapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            final allDoctors =
                doctorSnapshot.data!.docs;

            final pending = allDoctors.where((d) {
              final data =
                  d.data() as Map<String, dynamic>;
              return data['approved'] != true;
            }).toList();

            final approved = allDoctors.where((d) {
              final data =
                  d.data() as Map<String, dynamic>;
              return data['approved'] == true;
            }).length;

            return StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .snapshots(),
              builder: (context, userSnapshot) {
                final userCount =
                    userSnapshot.data?.docs.length ?? 0;

                return ListView(
                  padding: const EdgeInsets.fromLTRB(
                    22,
                    20,
                    22,
                    30,
                  ),
                  children: [
                    Row(
                      children: [
                        backButton(context),
                        const SizedBox(width: 5),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Admin Dashboard",
                                style: TextStyle(
                                  color: darkText,
                                  fontSize: 28,
                                  fontWeight:
                                      FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 3),
                              Text(
                                "Doctor verification and system management",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 49,
                          height: 49,
                          decoration: BoxDecoration(
                            color: const Color(0xFF8E67DC)
                                .withOpacity(.10),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.admin_panel_settings_rounded,
                            color: Color(0xFF8E67DC),
                            size: 27,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),

                    LayoutBuilder(
                      builder: (context, c) {
                        final cols =
                            c.maxWidth > 750 ? 4 : 2;

                        return GridView.count(
                          crossAxisCount: cols,
                          shrinkWrap: true,
                          physics:
                              const NeverScrollableScrollPhysics(),
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          mainAxisExtent: 145,
                          children: [
                            statCard(
                              pending.length.toString(),
                              "Pending Requests",
                              Icons.pending_actions_rounded,
                              warningColor,
                            ),
                            statCard(
                              approved.toString(),
                              "Approved Doctors",
                              Icons.verified_rounded,
                              successColor,
                            ),
                            statCard(
                              userCount.toString(),
                              "Registered Mothers",
                              Icons.family_restroom_rounded,
                              mainColor,
                            ),
                            statCard(
                              allDoctors.length.toString(),
                              "Total Doctors",
                              Icons.medical_services_rounded,
                              medicalBlue,
                            ),
                          ],
                        );
                      },
                    ),

                    const SizedBox(height: 16),

                    AdminEcosystemCard(
                      mothers: userCount,
                      doctors: allDoctors.length,
                      pendingDoctors: pending.length,
                    ),

                    const SizedBox(height: 20),

                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            const Color(0xFF8E67DC)
                                .withOpacity(.11),
                            medicalBlue.withOpacity(.07),
                          ],
                        ),
                        borderRadius:
                            BorderRadius.circular(20),
                      ),
                      child: const Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.white,
                            child: Icon(
                              Icons.security_rounded,
                              color: Color(0xFF8E67DC),
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              "Admin approval protects the platform by allowing only verified pediatric doctors to access clinical features.",
                              style: TextStyle(
                                color: darkText,
                                fontSize: 10.5,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    const Text(
                      "Doctor Approval Requests",
                      style: TextStyle(
                        color: darkText,
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),

                    if (pending.isEmpty)
                      Container(
                        padding:
                            const EdgeInsets.symmetric(
                          vertical: 60,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              BorderRadius.circular(22),
                        ),
                        child: const Column(
                          children: [
                            Icon(
                              Icons.verified_user_rounded,
                              color: successColor,
                              size: 55,
                            ),
                            SizedBox(height: 10),
                            Text(
                              "No pending doctor requests",
                              style: TextStyle(
                                color: darkText,
                                fontWeight:
                                    FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      )
                    else
                      ...pending.map(
                        (doctor) =>
                            requestCard(context, doctor),
                      ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}

/* ===================== DOCTOR DASHBOARD SCREEN ===================== */


class DoctorPatient360Card extends StatelessWidget {
  const DoctorPatient360Card({super.key});

  Widget metric(
    IconData icon,
    String title,
    String value,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.82),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: color.withOpacity(.08),
        ),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(.07),
            blurRadius: 10,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 35,
            height: 35,
            decoration: BoxDecoration(
              color: color.withOpacity(.10),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: color,
              size: 17,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: premiumBody3D(
                    size: 8,
                    color: const Color(0xFF7D8A9D),
                  ),
                ),
                Text(
                  value,
                  style: premiumBody3D(
                    size: 10.5,
                    color: darkText,
                    weight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;

    return HoverLift(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          gradient: dark
              ? const LinearGradient(
                  colors: [
                    Color(0xFF10283B),
                    Color(0xFF173348),
                    Color(0xFF193748),
                  ],
                )
              : const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFFF1FDFF),
                    Colors.white,
                    Color(0xFFF7F2FF),
                  ],
                ),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(
            color: dark
                ? Colors.white.withOpacity(.05)
                : Colors.white,
          ),
          boxShadow: [
            BoxShadow(
              color: medicalBlue.withOpacity(.12),
              blurRadius: 26,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: LayoutBuilder(
          builder: (context, c) {
            final wide = c.maxWidth > 720;

            final visual = SizedBox(
              width: 240,
              height: 220,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 190,
                    height: 190,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: mainColor.withOpacity(.12),
                        width: 1.5,
                      ),
                    ),
                  ),
                  Container(
                    width: 145,
                    height: 145,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFFE8FFFF),
                          Colors.white,
                          Color(0xFFFFEFF6),
                        ],
                      ),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white,
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: mainColor.withOpacity(.20),
                          blurRadius: 22,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.child_care_rounded,
                      color: mainColor,
                      size: 70,
                    ),
                  ),
                  const Positioned(
                    top: 8,
                    child: _PatientOrbitBadge(
                      icon: Icons.favorite_rounded,
                      color: Color(0xFFFF5277),
                    ),
                  ),
                  const Positioned(
                    right: 8,
                    child: _PatientOrbitBadge(
                      icon: Icons.thermostat_rounded,
                      color: Color(0xFF8D55E7),
                    ),
                  ),
                  const Positioned(
                    left: 8,
                    child: _PatientOrbitBadge(
                      icon: Icons.graphic_eq_rounded,
                      color: Color(0xFF7B61E8),
                    ),
                  ),
                  const Positioned(
                    bottom: 6,
                    child: _PatientOrbitBadge(
                      icon: Icons.restaurant_rounded,
                      color: warningColor,
                    ),
                  ),
                ],
              ),
            );

            final details = Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.visibility_rounded,
                      color: medicalBlue,
                    ),
                    const SizedBox(width: 7),
                    Text(
                      "Patient 360° View",
                      style: TextStyle(
                        color: dark ? Colors.white : darkText,
                        fontSize: 19,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const Spacer(),
                    const PremiumStatusPill(
                      text: "CLINICAL VIEW",
                      color: medicalBlue,
                      icon: Icons.radar_rounded,
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Text(
                  "A single pediatric snapshot combining profile, cry AI and health signals.",
                  style: TextStyle(
                    color: dark
                        ? Colors.white54
                        : const Color(0xFF758398),
                    fontSize: 9.5,
                  ),
                ),
                const SizedBox(height: 13),
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  childAspectRatio: 2.7,
                  children: [
                    metric(
                      Icons.favorite_rounded,
                      "Heart",
                      "Live monitoring",
                      const Color(0xFFFF5277),
                    ),
                    metric(
                      Icons.thermostat_rounded,
                      "Temperature",
                      "Live monitoring",
                      const Color(0xFF8D55E7),
                    ),
                    metric(
                      Icons.graphic_eq_rounded,
                      "Latest Cry AI",
                      "History available",
                      const Color(0xFF7B61E8),
                    ),
                    metric(
                      Icons.shield_rounded,
                      "Clinical Risk",
                      "Low",
                      successColor,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(11),
                  decoration: BoxDecoration(
                    color: medicalBlue.withOpacity(.06),
                    borderRadius: BorderRadius.circular(17),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.auto_awesome_rounded,
                        color: Color(0xFFFFC857),
                        size: 17,
                      ),
                      const SizedBox(width: 7),
                      Expanded(
                        child: Text(
                          "AI summary is available to support consultation and should be interpreted with clinical judgement.",
                          style: TextStyle(
                            color: dark
                                ? Colors.white60
                                : const Color(0xFF66758C),
                            fontSize: 8.5,
                            height: 1.35,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );

            if (wide) {
              return Row(
                children: [
                  visual,
                  const SizedBox(width: 18),
                  Expanded(child: details),
                ],
              );
            }

            return Column(
              children: [
                visual,
                const SizedBox(height: 10),
                details,
              ],
            );
          },
        ),
      ),
    );
  }
}

class _PatientOrbitBadge extends StatelessWidget {
  final IconData icon;
  final Color color;

  const _PatientOrbitBadge({
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 43,
      height: 43,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(
          color: color.withOpacity(.12),
        ),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(.18),
            blurRadius: 11,
          ),
        ],
      ),
      child: Icon(
        icon,
        color: color,
        size: 20,
      ),
    );
  }
}

class DoctorDashboardScreen extends StatelessWidget {
  const DoctorDashboardScreen({super.key});

  Widget statCard(
    String number,
    String title,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(21),
        border: Border.all(
          color: color.withOpacity(.08),
        ),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(.05),
            blurRadius: 13,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: color.withOpacity(.10),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: color,
              size: 20,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            number,
            style: TextStyle(
              color: color,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: darkText,
              fontSize: 9.5,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget actionTile({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
    int badge = 0,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(22),
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: color.withOpacity(.08),
          ),
        ),
        child: Row(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: color.withOpacity(.10),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    color: color,
                    size: 25,
                  ),
                ),
                if (badge > 0)
                  Positioned(
                    right: -4,
                    top: -5,
                    child: Container(
                      width: 21,
                      height: 21,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF365C),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white,
                          width: 2,
                        ),
                      ),
                      child: Text(
                        badge > 9
                            ? "9+"
                            : badge.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 8.5,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: darkText,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: color,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Scaffold(
        body: Center(child: Text("Please login first")),
      );
    }

    return Scaffold(
      body: BabyBg(
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('chat_rooms')
              .where(
                'participants',
                arrayContains: user.uid,
              )
              .snapshots(),
          builder: (context, chatSnapshot) {
            final chatCount =
                chatSnapshot.data?.docs.length ?? 0;

            return StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('appointments')
                  .where(
                    'doctorId',
                    isEqualTo: user.uid,
                  )
                  .snapshots(),
              builder: (context, appointmentSnapshot) {
                final appointments =
                    appointmentSnapshot.data?.docs ?? [];

                final pendingAppointments =
                    appointments.where((doc) {
                  final d =
                      doc.data() as Map<String, dynamic>;
                  return d['status'] == 'Pending';
                }).length;

                final confirmedAppointments =
                    appointments.where((doc) {
                  final d =
                      doc.data() as Map<String, dynamic>;
                  return d['status'] == 'Confirmed';
                }).length;

                return ListView(
                  padding: const EdgeInsets.fromLTRB(
                    22,
                    20,
                    22,
                    30,
                  ),
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 58,
                          height: 58,
                          decoration: BoxDecoration(
                            color:
                                medicalBlue.withOpacity(.10),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: medicalBlue
                                  .withOpacity(.20),
                            ),
                          ),
                          child: const Icon(
                            Icons.medical_services_rounded,
                            color: medicalBlue,
                            size: 31,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Doctor Dashboard",
                                style: TextStyle(
                                  color: darkText,
                                  fontSize: 27,
                                  fontWeight:
                                      FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 3),
                              Text(
                                "Clinical consultation workspace",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.logout_rounded,
                            color: dangerColor,
                          ),
                          onPressed: () async {
                            await FirebaseAuth.instance
                                .signOut();

                            if (context.mounted) {
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      const RoleScreen(),
                                ),
                                (_) => false,
                              );
                            }
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 17),

                    LayoutBuilder(
                      builder: (context, c) {
                        final cols =
                            c.maxWidth > 760 ? 4 : 2;

                        return GridView.count(
                          crossAxisCount: cols,
                          shrinkWrap: true,
                          physics:
                              const NeverScrollableScrollPhysics(),
                          crossAxisSpacing: 9,
                          mainAxisSpacing: 9,
                          mainAxisExtent: 140,
                          children: [
                            statCard(
                              chatCount.toString(),
                              "Conversations",
                              Icons.forum_rounded,
                              medicalBlue,
                            ),
                            statCard(
                              pendingAppointments
                                  .toString(),
                              "Pending",
                              Icons.pending_actions_rounded,
                              warningColor,
                            ),
                            statCard(
                              confirmedAppointments
                                  .toString(),
                              "Confirmed",
                              Icons.event_available_rounded,
                              successColor,
                            ),
                            statCard(
                              appointments.length
                                  .toString(),
                              "Appointments",
                              Icons.calendar_month_rounded,
                              mainColor,
                            ),
                          ],
                        );
                      },
                    ),

                    const SizedBox(height: 16),

                    ClinicalFocusCard(
                      conversations: chatCount,
                      pendingAppointments:
                          pendingAppointments,
                      confirmedAppointments:
                          confirmedAppointments,
                    ),

                    const SizedBox(height: 16),
                    const DoctorPatient360Card(),

                    const SizedBox(height: 19),

                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            medicalBlue.withOpacity(.10),
                            mainColor.withOpacity(.07),
                          ],
                        ),
                        borderRadius:
                            BorderRadius.circular(21),
                      ),
                      child: const Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.white,
                            child: Icon(
                              Icons.health_and_safety_rounded,
                              color: medicalBlue,
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              "Review patient information and cry-analysis results before giving pediatric advice.",
                              style: TextStyle(
                                color: darkText,
                                fontSize: 10.5,
                                fontWeight:
                                    FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 19),

                    const Text(
                      "Clinical Workspace",
                      style: TextStyle(
                        color: darkText,
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),

                    actionTile(
                      context: context,
                      icon: Icons.chat_rounded,
                      title: "Mother Conversations",
                      subtitle:
                          "Reply to consultation messages in real time.",
                      color: medicalBlue,
                      badge: chatCount,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                const ConversationsScreen(
                              role: 'doctor',
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 10),

                    actionTile(
                      context: context,
                      icon: Icons.calendar_month_rounded,
                      title: "Appointments",
                      subtitle:
                          "Confirm or reject consultation bookings.",
                      color: const Color(0xFFFF9F1C),
                      badge: pendingAppointments,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                const DoctorAppointmentsScreen(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 10),

                    actionTile(
                      context: context,
                      icon: Icons.monitor_heart_rounded,
                      title: "Patient Monitoring",
                      subtitle:
                          "Review baby health information and analysis history.",
                      color: mainColor,
                      onTap: () {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(
                          const SnackBar(
                            content: Text(
                              "Open a mother consultation to review patient data.",
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}

/* ===================== NOTIFICATIONS SCREEN ===================== */

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  IconData notificationIcon(String type) {
    switch (type) {
      case 'appointment':
        return Icons.calendar_month_rounded;
      case 'chat':
        return Icons.chat_bubble_rounded;
      case 'report':
        return Icons.description_rounded;
      default:
        return Icons.settings_suggest_rounded;
    }
  }

  Color notificationColor(String type) {
    switch (type) {
      case 'appointment':
        return const Color(0xFFFF4771);
      case 'chat':
        return const Color(0xFFFF4771);
      case 'report':
        return const Color(0xFF4BA57A);
      default:
        return const Color(0xFF6956D9);
    }
  }

  String formatTimestamp(Timestamp? timestamp) {
    if (timestamp == null) {
      return "Just now";
    }

    final difference =
        DateTime.now().difference(
      timestamp.toDate(),
    );

    if (difference.inMinutes < 1) {
      return "Just now";
    }

    if (difference.inMinutes < 60) {
      return "${difference.inMinutes} min ago";
    }

    if (difference.inHours < 24) {
      return "${difference.inHours} hour ago";
    }

    return "${difference.inDays} day ago";
  }

  Future<void> markAsRead(String id) async {
    await FirebaseFirestore.instance
        .collection('notifications')
        .doc(id)
        .update({
      'isRead': true,
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const BabyBg(
        child: Center(child: Text("Please login first")),
      );
    }

    return BabyBg(
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('notifications')
            .where(
              'userId',
              isEqualTo: user.uid,
            )
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                "Notifications error: ${snapshot.error}",
              ),
            );
          }

          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final docs =
              snapshot.data!.docs.toList();

          docs.sort((a, b) {
            final ad =
                a.data() as Map<String, dynamic>;

            final bd =
                b.data() as Map<String, dynamic>;

            final at =
                ad['createdAt'] as Timestamp?;

            final bt =
                bd['createdAt'] as Timestamp?;

            if (at == null || bt == null) {
              return 0;
            }

            return bt.compareTo(at);
          });

          return ListView(
            padding: const EdgeInsets.fromLTRB(
              20,
              18,
              20,
              28,
            ),
            children: [
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      "Alerts & Notifications",
                      style: TextStyle(
                        color: darkText,
                        fontSize: 27,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    width: 41,
                    height: 41,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.settings_rounded,
                      color: Color(0xFF7882A2),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              if (docs.isEmpty)
                Container(
                  padding:
                      const EdgeInsets.symmetric(
                    vertical: 70,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.circular(23),
                  ),
                  child: const Column(
                    children: [
                      Icon(
                        Icons.notifications_none_rounded,
                        color: mainColor,
                        size: 63,
                      ),
                      SizedBox(height: 12),
                      Text(
                        "No notifications yet",
                        style: TextStyle(
                          color: darkText,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                )
              else
                ...docs.map((doc) {
                  final d =
                      doc.data() as Map<String, dynamic>;

                  final type =
                      d['type']?.toString() ??
                          'general';

                  final title =
                      d['title']?.toString() ??
                          'System Update';

                  final message =
                      d['message']?.toString() ?? '';

                  final isRead =
                      d['isRead'] == true;

                  final color =
                      notificationColor(type);

                  return InkWell(
                    onTap: () => markAsRead(doc.id),
                    borderRadius:
                        BorderRadius.circular(19),
                    child: Container(
                      margin:
                          const EdgeInsets.only(
                        bottom: 9,
                      ),
                      padding:
                          const EdgeInsets.all(13),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.circular(19),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black
                                .withOpacity(.025),
                            blurRadius: 9,
                            offset:
                                const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color:
                                  color.withOpacity(.10),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              notificationIcon(type),
                              color: color,
                              size: 21,
                            ),
                          ),
                          const SizedBox(width: 11),
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Text(
                                  title,
                                  style: const TextStyle(
                                    color: darkText,
                                    fontSize: 13.5,
                                    fontWeight:
                                        FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  message,
                                  maxLines: 2,
                                  overflow:
                                      TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 10.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 9),
                          Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.end,
                            children: [
                              Text(
                                formatTimestamp(
                                  d['createdAt']
                                      as Timestamp?,
                                ),
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 8.5,
                                ),
                              ),
                              const SizedBox(height: 7),
                              if (!isRead)
                                Container(
                                  width: 22,
                                  height: 22,
                                  alignment:
                                      Alignment.center,
                                  decoration:
                                      const BoxDecoration(
                                    color:
                                        Color(0xFFFF365C),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Text(
                                    "1",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 9,
                                      fontWeight:
                                          FontWeight.bold,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                }),
            ],
          );
        },
      ),
    );
  }
}



/* ===================== DOCTOR DEMO INNOVATION PACK ===================== */

class _DemoShell extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Widget child;
  const _DemoShell({required this.title, required this.subtitle, required this.icon, required this.child});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BabyBg(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(22),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1080),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(children: [
                    IconButton(onPressed: ()=>Navigator.pop(context), icon: const Icon(Icons.arrow_back_ios_new_rounded)),
                    const SizedBox(width: 8),
                    Container(width: 54,height:54,decoration: BoxDecoration(color: mainColor.withOpacity(.12),borderRadius: BorderRadius.circular(18)),child: Icon(icon,color:mainColor,size:28)),
                    const SizedBox(width: 12),
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start,children:[Text(title,style:premiumHeadingStyle(size:26)),const SizedBox(height:3),Text(subtitle,style:premiumBody3D(size:10,color:const Color(0xFF6B7890)))])),
                    const PremiumStatusPill(text:"AI ENABLED",color:successColor,icon:Icons.auto_awesome_rounded),
                  ]),
                  const SizedBox(height: 22), child,
                ]),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CryAnalyticsScreen extends StatelessWidget {
  const CryAnalyticsScreen({super.key});
  Widget stat(String value,String label,IconData icon,Color c)=>Container(padding:const EdgeInsets.all(18),decoration:BoxDecoration(color:Colors.white,borderRadius:BorderRadius.circular(24),boxShadow:[BoxShadow(color:c.withOpacity(.10),blurRadius:22,offset:const Offset(0,10))]),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Icon(icon,color:c),const SizedBox(height:12),Text(value,style:premiumMetricStyle(size:27,color:c)),Text(label,style:premiumBody3D(size:9,color:const Color(0xFF6B7890)))]));
  @override Widget build(BuildContext context)=>_DemoShell(title:"Cry History Analytics",subtitle:"AI-powered behavioral patterns from recent cry events",icon:Icons.insights_rounded,child:Column(children:[
    LayoutBuilder(builder:(context,c)=>GridView.count(crossAxisCount:c.maxWidth>720?4:2,shrinkWrap:true,physics:const NeverScrollableScrollPhysics(),mainAxisSpacing:12,crossAxisSpacing:12,mainAxisExtent:135,children:[stat("18","Cry events / week",Icons.graphic_eq_rounded,mainColor),stat("61%","Hunger pattern",Icons.restaurant_rounded,const Color(0xFFFFA928)),stat("8:20 PM","Peak cry time",Icons.schedule_rounded,const Color(0xFF7B61E8)),stat("92%","AI confidence",Icons.psychology_rounded,successColor)])),
    const SizedBox(height:16),
    Container(padding:const EdgeInsets.all(22),decoration:BoxDecoration(color:Colors.white,borderRadius:BorderRadius.circular(28)),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Text("7-Day Cry Trend",style:premiumHeadingStyle(size:18)),const SizedBox(height:18),SizedBox(height:190,child:CustomPaint(painter:_TrendPainter(),child:const SizedBox.expand())),const SizedBox(height:12),const Wrap(spacing:8,runSpacing:8,children:[PremiumStatusPill(text:"Hunger 61%",color:Color(0xFFFFA928),icon:Icons.restaurant_rounded),PremiumStatusPill(text:"Discomfort 24%",color:Color(0xFF7B61E8),icon:Icons.child_care_rounded),PremiumStatusPill(text:"Sleepy 15%",color:medicalBlue,icon:Icons.bedtime_rounded)])])),
    const SizedBox(height:16),Container(width:double.infinity,padding:const EdgeInsets.all(20),decoration:BoxDecoration(gradient:LinearGradient(colors:[medicalBlue.withOpacity(.12),mainColor.withOpacity(.10)]),borderRadius:BorderRadius.circular(25)),child:Row(children:[const Icon(Icons.auto_awesome_rounded,color:medicalBlue,size:30),const SizedBox(width:12),Expanded(child:Text("AI Insight: Cry frequency is stable. Hunger-related events are most common before the evening feeding window.",style:premiumBody3D(size:10.5,color:darkText,weight:FontWeight.w800))) ]))
  ]));
}

class _TrendPainter extends CustomPainter {
  @override void paint(Canvas canvas,Size size){final grid=Paint()..color=const Color(0xFFE9EEF5)..strokeWidth=1;for(int i=1;i<5;i++){final y=size.height*i/5;canvas.drawLine(Offset(0,y),Offset(size.width,y),grid);}final p=Paint()..color=mainColor..strokeWidth=4..style=PaintingStyle.stroke..strokeCap=StrokeCap.round;final path=Path();final vals=[.62,.38,.70,.48,.82,.55,.73];for(int i=0;i<vals.length;i++){final x=size.width*i/(vals.length-1);final y=size.height*(1-vals[i]);if(i==0)path.moveTo(x,y);else path.lineTo(x,y);}canvas.drawPath(path,p);final dot=Paint()..color=medicalBlue;for(int i=0;i<vals.length;i++){canvas.drawCircle(Offset(size.width*i/(vals.length-1),size.height*(1-vals[i])),5,dot);}}
  @override bool shouldRepaint(covariant CustomPainter oldDelegate)=>false;
}

class SmartRiskCenterScreen extends StatelessWidget {
  const SmartRiskCenterScreen({super.key});
  Widget factor(IconData i,String t,String v,Color c)=>Container(padding:const EdgeInsets.all(16),decoration:BoxDecoration(color:Colors.white,borderRadius:BorderRadius.circular(22)),child:Row(children:[CircleAvatar(backgroundColor:c.withOpacity(.12),child:Icon(i,color:c)),const SizedBox(width:11),Expanded(child:Text(t,style:premiumBody3D(size:10,color:darkText,weight:FontWeight.w900))),Text(v,style:premiumBody3D(size:10,color:c,weight:FontWeight.w900))]));
  @override Widget build(BuildContext context)=>_DemoShell(title:"Smart Risk Center",subtitle:"Multimodal pediatric screening for fast clinical attention",icon:Icons.health_and_safety_rounded,child:Column(children:[
    Container(width:double.infinity,padding:const EdgeInsets.all(24),decoration:BoxDecoration(gradient:LinearGradient(colors:[successColor.withOpacity(.14),mainColor.withOpacity(.08)]),borderRadius:BorderRadius.circular(30)),child:LayoutBuilder(builder:(context,c){final gauge=Container(width:150,height:150,decoration:BoxDecoration(shape:BoxShape.circle,border:Border.all(color:successColor,width:12),boxShadow:[BoxShadow(color:successColor.withOpacity(.18),blurRadius:30)]),child:Center(child:Column(mainAxisSize:MainAxisSize.min,children:[Text("LOW",style:premiumMetricStyle(size:27,color:successColor)),Text("18 / 100",style:premiumBody3D(size:9,color:darkText,weight:FontWeight.w900))])));final text=Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Text("No urgent warning signs detected",style:premiumHeadingStyle(size:21)),const SizedBox(height:8),Text("AI combined the latest cry pattern, temperature, heart-rate signal and recent history.",style:premiumBody3D(size:10,color:const Color(0xFF66758C))),const SizedBox(height:12),const PremiumStatusPill(text:"Routine monitoring recommended",color:successColor,icon:Icons.verified_rounded)]));return c.maxWidth>620?Row(children:[gauge,const SizedBox(width:25),text]):Column(children:[gauge,const SizedBox(height:18),text]);})),
    const SizedBox(height:14),factor(Icons.graphic_eq_rounded,"Cry acoustic risk","Low",successColor),const SizedBox(height:9),factor(Icons.thermostat_rounded,"Temperature signal","Normal",successColor),const SizedBox(height:9),factor(Icons.favorite_rounded,"Heart-rate trend","Stable",medicalBlue),const SizedBox(height:9),factor(Icons.history_rounded,"History flags","None",successColor),
    const SizedBox(height:16),Container(width:double.infinity,padding:const EdgeInsets.all(20),decoration:BoxDecoration(color:const Color(0xFFFFF4F5),borderRadius:BorderRadius.circular(25),border:Border.all(color:dangerColor.withOpacity(.15))),child:Row(children:[const Icon(Icons.emergency_rounded,color:dangerColor,size:30),const SizedBox(width:12),Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Text("Emergency Smart Alert",style:premiumHeadingStyle(size:16)),const SizedBox(height:3),Text("If multiple high-risk signals are detected, the app can immediately recommend pediatric attention and open Doctor Chat or Appointments.",style:premiumBody3D(size:9.5,color:const Color(0xFF66758C))) ]))]))
  ]));
}

class DoctorDemoTourScreen extends StatelessWidget {
  const DoctorDemoTourScreen({super.key});
  Widget feature(BuildContext context,IconData i,String title,String sub,Color c,VoidCallback tap)=>HoverLift(child:InkWell(onTap:tap,borderRadius:BorderRadius.circular(25),child:Container(padding:const EdgeInsets.all(18),decoration:BoxDecoration(color:Colors.white,borderRadius:BorderRadius.circular(25),boxShadow:[BoxShadow(color:c.withOpacity(.10),blurRadius:20,offset:const Offset(0,9))]),child:Row(children:[Container(width:52,height:52,decoration:BoxDecoration(color:c.withOpacity(.12),borderRadius:BorderRadius.circular(17)),child:Icon(i,color:c,size:27)),const SizedBox(width:12),Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Text(title,style:premiumHeadingStyle(size:15)),const SizedBox(height:3),Text(sub,style:premiumBody3D(size:9,color:const Color(0xFF6B7890)))])),Icon(Icons.arrow_forward_ios_rounded,color:c,size:16)]))));
  @override Widget build(BuildContext context)=>_DemoShell(title:"Pediatric AI Experience",subtitle:"A complete doctor-ready tour of the intelligent care workflow",icon:Icons.auto_awesome_rounded,child:Column(children:[
    Container(width:double.infinity,padding:const EdgeInsets.all(24),decoration:BoxDecoration(gradient:const LinearGradient(colors:[Color(0xFF163A70),Color(0xFF126B85),Color(0xFF38C9C7)]),borderRadius:BorderRadius.circular(30)),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[const Text("AI + Pediatrics + Connected Care",style:TextStyle(color:Colors.white,fontSize:25,fontWeight:FontWeight.w900,shadows:[Shadow(color:Colors.black26,blurRadius:8,offset:Offset(0,3))])),const SizedBox(height:7),Text("From cry capture to risk screening, clinical monitoring, analytics and doctor follow-up — in one pediatric workflow.",style:premiumBody3D(size:10.5,color:Colors.white.withOpacity(.92),weight:FontWeight.w700))])),
    const SizedBox(height:15),feature(context,Icons.mic_rounded,"1. AI Cry Recognition","Record, classify, confidence score and care guidance",mainColor,()=>Navigator.push(context,MaterialPageRoute(builder:(_)=>const RecordingScreen()))),const SizedBox(height:10),feature(context,Icons.monitor_heart_rounded,"2. Live Baby Health Monitor","Hospital-style heart and temperature monitoring",dangerColor,()=>Navigator.push(context,MaterialPageRoute(builder:(_)=>const VitalSignsScreen()))),const SizedBox(height:10),feature(context,Icons.insights_rounded,"3. Cry Analytics","Weekly behavior, causes and peak-time intelligence",const Color(0xFF7B61E8),()=>Navigator.push(context,MaterialPageRoute(builder:(_)=>const CryAnalyticsScreen()))),const SizedBox(height:10),feature(context,Icons.health_and_safety_rounded,"4. Smart Risk System","Low / moderate / high pediatric risk screening",successColor,()=>Navigator.push(context,MaterialPageRoute(builder:(_)=>const SmartRiskCenterScreen()))),const SizedBox(height:10),feature(context,Icons.description_rounded,"5. Medical Report","Doctor-ready AI-assisted clinical summary",medicalBlue,()=>Navigator.push(context,MaterialPageRoute(builder:(_)=>const MedicalReportScreen()))),const SizedBox(height:10),feature(context,Icons.calendar_month_rounded,"6. Connected Care","Doctor chat, appointments, alerts and follow-up",const Color(0xFFFFA928),()=>Navigator.push(context,MaterialPageRoute(builder:(_)=>const AppointmentScreen()))),
    const SizedBox(height:16),Container(width:double.infinity,padding:const EdgeInsets.all(18),decoration:BoxDecoration(color:Colors.white,borderRadius:BorderRadius.circular(24)),child:const Wrap(spacing:8,runSpacing:8,children:[PremiumStatusPill(text:"Patient 360°",color:mainColor,icon:Icons.child_care_rounded),PremiumStatusPill(text:"Health Score",color:successColor,icon:Icons.favorite_rounded),PremiumStatusPill(text:"Smart Alerts",color:dangerColor,icon:Icons.notifications_active_rounded),PremiumStatusPill(text:"Dark Medical Mode",color:medicalBlue,icon:Icons.dark_mode_rounded),PremiumStatusPill(text:"3D UI",color:Color(0xFF7B61E8),icon:Icons.layers_rounded)]) )
  ]));
}
