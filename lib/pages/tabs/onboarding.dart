import 'package:flutter/material.dart';
import 'package:meal/meal.dart';
import 'package:onboarding/onboarding.dart';
import 'package:meal_planner/utils/images.dart';

class OnboardingTab extends StatefulWidget {
  const OnboardingTab({super.key});

  @override
  State<OnboardingTab> createState() => _OnboardingTabState();
}

class _OnboardingTabState extends State<OnboardingTab> {
  late int index;
  final onboardingPagesList = [
    PageModel(
      widget: DecoratedBox(
        decoration: BoxDecoration(
          color: neutral100,
          border: Border.all(
            width: 0.0,
            color: neutral100,
          ),
        ),
        child: SingleChildScrollView(
          controller: ScrollController(),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(32.0),
                child: Align(child: SkipButton(), alignment: Alignment.centerRight,),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 96),
                child: imgLogo,
              ),
              const Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32,),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: MealText.heading("Meal Planner"),
                ),
              ),
              const Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: MealText.body("Welcome to Meal Planner"),
                ),
              ),
            ],
          ),
        ),
      )
    ),
    PageModel(
        widget: DecoratedBox(
          decoration: BoxDecoration(
            color: neutral100,
            border: Border.all(
              width: 0.0,
              color: neutral100,
            ),
          ),
          child: SingleChildScrollView(
            controller: ScrollController(),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Align(child: SkipButton(), alignment: Alignment.centerRight,),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 96),
                  child: imgPea,
                ),
                const Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32,),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: MealText.heading("Plan Meals"),
                  ),
                ),
                const Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: MealText.body("Create custom meal plans"),
                  ),
                ),
              ],
            ),
          ),
        )
    ),
    PageModel(
        widget: DecoratedBox(
          decoration: BoxDecoration(
            color: neutral100,
            border: Border.all(
              width: 0.0,
              color: neutral100,
            ),
          ),
          child: SingleChildScrollView(
            controller: ScrollController(),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Align(child: SkipButton(), alignment: Alignment.centerRight,),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 96),
                  child: imgPepper,
                ),
                const Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32,),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: MealText.heading("Manage Groceries"),
                  ),
                ),
                const Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: MealText.body("Create a grocery list"),
                  ),
                ),
              ],
            ),
          ),
        )
    ),
    PageModel(
        widget: DecoratedBox(
          decoration: BoxDecoration(
            color: neutral100,
            border: Border.all(
              width: 0.0,
              color: neutral100,
            ),
          ),
          child: SingleChildScrollView(
            controller: ScrollController(),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(64.0),
                  child: Align(child: SizedBox.shrink(), alignment: Alignment.centerRight,),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 96),
                  child: imgTomato,
                ),
                const Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32,),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: MealText.heading("Meal Ideas"),
                  ),
                ),
                const Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: MealText.body("Create custom meal ideas for the future"),
                  ),
                ),
              ],
            ),
          ),
        )
    ),
  ];

  @override
  void initState() {
    super.initState();
    index = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Onboarding(
        pages: onboardingPagesList,
        onPageChange: (pageIndex) {
          index = pageIndex;
        },
        startPageIndex: 0,
        footerBuilder: (context, dragDistance, pagesLength, setIndex) {
          return Container(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomIndicator(
                      netDragPercent: dragDistance,
                      indicator: Indicator(
                        indicatorDesign: IndicatorDesign.polygon(polygonDesign: PolygonDesign(polygon: DesignType.polygon_circle)),
                        activeIndicator: ActiveIndicator(color: neutral200, borderWidth: 1),
                        closedIndicator: ClosedIndicator(color: primary600)
                      ),
                      pagesLength: pagesLength
                  ),
                  index == pagesLength - 1 ? SignUpButton() : SizedBox.shrink()
                ],
              ),
            ),
          );
        },
      )
    );
  }
}

class SkipButton extends StatelessWidget {
  const SkipButton({super.key});

  @override
  Widget build(BuildContext context) {
    return MealButton.primary_text(
      onPressed: () {
        Future((){Navigator.of(context).pushReplacementNamed('/login');});
      },
      label: "Skip",
    );
  }
}

class SignUpButton extends StatelessWidget {
  const SignUpButton({super.key});

  @override
  Widget build(BuildContext context) {
    return MealButton.primary(
      onPressed: () {
        Future((){Navigator.of(context).pushReplacementNamed('/login');});
      },
      label: "Get Started",
    );
  }
}


