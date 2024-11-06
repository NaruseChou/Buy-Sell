import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';

class BannerWidget extends StatelessWidget {
  const BannerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Neumorphic(
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * .25,
        color: Colors.cyan,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        const Text(
                          'CARS',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 1,
                              fontSize: 18),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          height: 45.0,
                          child: DefaultTextStyle(
                            style: const TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold,
                            ),
                            child: AnimatedTextKit(
                              repeatForever: true,
                              isRepeatingAnimation: true,
                              animatedTexts: [
                                FadeAnimatedText(
                                  'Search for all the things\nyou are Interested',
                                  duration: const Duration(seconds: 4),
                                ),
                                FadeAnimatedText(
                                  'New way to\nBuy or Sell',
                                  duration: const Duration(seconds: 4),
                                ),
                                FadeAnimatedText(
                                  'Over 1 thousand\nCars to Buy',
                                  duration: const Duration(seconds: 4),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                    Neumorphic(
                      style: const NeumorphicStyle(
                          color: Colors.white, oppositeShadowLightSource: true),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.network(
                            'https://firebasestorage.googleapis.com/v0/b/buysell-f6ad3.firebasestorage.app/o/banner%2Fracing-car.png?alt=media&token=4fcb00c1-b646-4dfb-bcb6-69683132b090'),
                      ),
                    )
                  ],
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: NeumorphicButton(
                      onPressed: () {},
                      style: const NeumorphicStyle(color: Colors.white),
                      child: const Text(
                        'Buy Car',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: NeumorphicButton(
                      onPressed: () {},
                      style: const NeumorphicStyle(color: Colors.white),
                      child: const Text(
                        'Sell Car',
                        textAlign: TextAlign.center,
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
}
