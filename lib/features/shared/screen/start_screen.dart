import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:mysen/core/approut.dart';
import 'package:mysen/core/constant.dart';
import 'package:mysen/core/utiles.dart';
import 'package:mysen/features/shared/services/sharedprefrenceservice.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Startscreen extends StatefulWidget {
  const Startscreen({super.key});

  @override
  State<Startscreen> createState() => _StartscreenState();
}

class _StartscreenState extends State<Startscreen>
    with TickerProviderStateMixin {
  final sharedPref = Get.find<SharedPrefService>();
  final session = Supabase.instance.client.auth.currentSession;

  bool isWhite = false;
  Color color = blackcolor;

  @override
  void initState() {
    super.initState();

    // after end animation
    Future.delayed(const Duration(seconds: 1), () async {
      await Future.delayed(const Duration(milliseconds: 2500));
      setState(() {
        color = whitecolor;
        isWhite = true;
      });

      await Future.delayed(const Duration(milliseconds: 1500));
      try {
        if (session == null) {
          Get.offAllNamed(Approut.log);
        } else {
          final role = sharedPref.getRole();
          if (role == null) {
            Get.offAllNamed(Approut.log);

            return;
          }
          if (role == 'doctor') {
            Get.offAllNamed(Approut.doctor);

            return;
          }
          if (role == 'user') {
            Get.offAllNamed(Approut.mainscreen);

            return;
          }
        }
      } catch (e) {
        return;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = context.mediaSize;

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        backgroundColor: context.primarycolor,
        body: SizedBox.expand(
          child: Stack(
            alignment: Alignment.center,
            children: [
              Align(
                alignment: const FractionalOffset(.5, .5),
                child: TweenAnimationBuilder(
                  duration: const Duration(seconds: 1),
                  tween: ColorTween(begin: blackcolor, end: color),
                  builder: (context, value, child) => ShaderMask(
                    shaderCallback: (bounds) => LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [value!, whitecolor],
                    ).createShader(bounds),
                    child: FaIcon(
                      FontAwesomeIcons.tooth,
                      color: whitecolor,
                      size: size.shortestSide * .09,
                    ),
                  ),
                ),
              ).animate().shake(duration: const Duration(seconds: 1)),

              Align(
                    alignment: FractionalOffset(
                      .5,
                      context.mediaSize.width > 600 ? 0.4 : .43,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [Text('MySen', style: context.mysen)],
                    ),
                  )
                  .animate()
                  .then(delay: const Duration(seconds: 1))
                  .fadeIn()
                  .then(delay: const Duration(seconds: 1))
                  .slideY(begin: -0.1, end: .1)
                  .then()
                  .slideY(begin: .1, end: -0.1),
            ],
          ),
        ),
      ),
    );
  }
}
