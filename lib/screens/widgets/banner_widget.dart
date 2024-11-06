import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';

// Виджет для отображения баннера с анимацией и кнопками
class BannerWidget extends StatelessWidget {
  const BannerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Neumorphic(
      child: Container(
        width: MediaQuery.of(context).size.width, // Ширина равна ширине экрана
        height: MediaQuery.of(context).size.height *
            .25, // Высота - 25% от высоты экрана
        color: Colors.cyan, // Фоновый цвет контейнера
        child: Padding(
          padding: const EdgeInsets.all(10.0), // Внутренние отступы
          child: Column(
            mainAxisAlignment: MainAxisAlignment
                .spaceBetween, // Расположение дочерних виджетов с равными промежутками
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment
                      .spaceBetween, // Равномерное расположение элементов по горизонтали
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment
                          .start, // Выравнивание по левому краю
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        const Text(
                          'CARS', // Заголовок баннера
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
                          height: 45.0, // Высота для анимированного текста
                          child: DefaultTextStyle(
                            style: const TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold,
                            ),
                            child: AnimatedTextKit(
                              repeatForever: true, // Повторение анимации
                              isRepeatingAnimation: true,
                              animatedTexts: [
                                // Последовательность анимаций с разными текстами
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
                    // Neumorphic контейнер с изображением
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
                mainAxisSize: MainAxisSize.min, // Минимальная ширина строки
                children: [
                  // Кнопка "Buy Car"
                  Expanded(
                    child: NeumorphicButton(
                      onPressed: () {}, // Действие при нажатии на кнопку
                      style: const NeumorphicStyle(color: Colors.white),
                      child: const Text(
                        'Buy Car',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 20, // Промежуток между кнопками
                  ),
                  // Кнопка "Sell Car"
                  Expanded(
                    child: NeumorphicButton(
                      onPressed: () {}, // Действие при нажатии на кнопку
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
