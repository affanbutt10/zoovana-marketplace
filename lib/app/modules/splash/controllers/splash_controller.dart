import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/controllers/auth_controller.dart';
import '../../../routes/app_routes.dart';

class SplashController extends GetxController with GetTickerProviderStateMixin {
  late AnimationController particleController;
  late AnimationController shineController;
  late AnimationController textController;
  late AnimationController progressController;
  late AnimationController tiltAnimation;

  final RxDouble tiltX = 0.0.obs;
  final RxDouble tiltY = 0.0.obs;
  final RxString loadingText = 'Loading...'.obs;
  final RxString currentTagline = 'Everything for your furry friends'.obs;
  final RxBool isLoading = true.obs;
  Timer? _loadingTimer;
  Timer? _taglineTimer;
  bool _hasNavigated = false;

  final taglines = [
    'Everything for your furry friends',
    'Todo para tus amigos peludos', // Spanish
    'Premium pet care awaits',
    'Cuidado premium para mascotas', // Spanish
  ];

  final loadingMessages = [
    'Initializing catalog...',
    'Inicializando catálogo...',
    'Preparing your experience...',
    'Preparando tu experiencia...',
  ];

  @override
  void onInit() {
    super.onInit();

    particleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();

    shineController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();

    textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    progressController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    tiltAnimation = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    _startSequences();
  }

  void _startSequences() {
    // Start text animation
    Future.delayed(const Duration(milliseconds: 800), () {
      textController.forward();
    });

    // Simulate loading progress
    progressController.forward();

    // Cycle through bilingual messages
    int messageIndex = 0;
    _loadingTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (messageIndex < loadingMessages.length) {
        loadingText.value = loadingMessages[messageIndex];
        messageIndex++;
      } else {
        timer.cancel();
        isLoading.value = false;
        _navigateToNextScreen();
      }
    });

    // Cycle taglines
    _taglineTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      final currentIndex = taglines.indexOf(currentTagline.value);
      final nextIndex = (currentIndex + 1) % taglines.length;
      currentTagline.value = taglines[nextIndex];
    });
  }

  void updateTilt(Offset delta) {
    tiltX.value = (delta.dx * 0.01).clamp(-0.3, 0.3);
    tiltY.value = (delta.dy * 0.01).clamp(-0.3, 0.3);
  }

  void updateMousePosition(Offset position) {
    final screenSize = Get.size;
    final centerX = screenSize.width / 2;
    final centerY = screenSize.height / 2;

    tiltX.value = ((position.dx - centerX) / centerX * 0.2).clamp(-0.2, 0.2);
    tiltY.value = ((position.dy - centerY) / centerY * 0.2).clamp(-0.2, 0.2);
  }

  void navigateToHome() {
    _navigateToNextScreen();
  }

  void _navigateToNextScreen() {
    if (_hasNavigated) {
      return;
    }
    _hasNavigated = true;
    Future.delayed(const Duration(milliseconds: 500), () {
      if (isClosed) {
        return;
      }
      final authController = Get.find<AuthController>();
      if (authController.isAuthenticated) {
        Get.offAllNamed(AppRoutes.home);
      } else {
        Get.offAllNamed(AppRoutes.login);
      }
    });
  }

  @override
  void onClose() {
    _loadingTimer?.cancel();
    _taglineTimer?.cancel();
    particleController.dispose();
    shineController.dispose();
    textController.dispose();
    progressController.dispose();
    tiltAnimation.dispose();
    super.onClose();
  }
}
