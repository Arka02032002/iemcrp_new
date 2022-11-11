import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iemcrp_new/quiz/components/progress_bar.dart';

import '../../Widgets/question_card.dart';
import '../../controllers/question_controller.dart';


class Body extends StatelessWidget {
  const Body({
    required Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const kSecondaryColor = Color(0xFF8B94BC);
    const kGreenColor = Color(0xFF6AC259);
    const kRedColor = Color(0xFFE92E30);
    const kGrayColor = Color(0xFFC1C1C1);
    const kBlackColor = Color(0xFF101010);
    const kPrimaryGradient = LinearGradient(
      colors: [Color(0xFF46A0AE), Color(0xFF00FFCB)],
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
    );

    const double kDefaultPadding = 20.0;
    // So that we have acccess our controller
    QuestionController _questionController = Get.put(QuestionController());
    return Stack(
      children: [
        Image.network('https://images.pexels.com/photos/13415959/pexels-photo-13415959.jpeg?auto=compress&cs=tinysrgb&w=600&lazy=load'),
        SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                child: ProgressBar(key: Key(AutofillHints.addressCity),),
              ),
              SizedBox(height: kDefaultPadding),
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                child: Obx(
                      () => Text.rich(
                    TextSpan(
                      text:
                      "Question ${_questionController.questionNumber.value}",
                      style: Theme.of(context)
                          .textTheme
                          .headline4
                          ?.copyWith(color: kSecondaryColor),
                      children: [
                        TextSpan(
                          text: "/${_questionController.questions.length}",
                          style: Theme.of(context)
                              .textTheme
                              .headline5
                              ?.copyWith(color: kSecondaryColor),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Divider(thickness: 1.5),
              SizedBox(height: kDefaultPadding),
              Expanded(
                child: PageView.builder(
                  // Block swipe to next qn
                  physics: NeverScrollableScrollPhysics(),
                  controller: _questionController.pageController,
                  onPageChanged: _questionController.updateTheQnNum,
                  itemCount: _questionController.questions.length,
                  itemBuilder: (context, index) => QuestionCard(
                      question: _questionController.questions[index]),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}