import 'package:flutter/material.dart';
import 'package:intro_slider/dot_animation_enum.dart';

import 'package:intro_slider/intro_slider.dart';
import 'package:intro_slider/slide_object.dart';

import 'package:grow/widgets/neumorphicContainer.dart';

class IntroScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  List<Slide> slides = new List();

  Function goToTab;

  @override
  void initState() {
    super.initState();

    slides.add(
      new Slide(
        title: "IDEA",
        styleTitle: TextStyle(
          color: Colors.grey.shade700,
          fontSize: 30.0,
          fontWeight: FontWeight.bold,
        ),
        description: "This is a test idea.",
        styleDescription: TextStyle(
          color: Colors.grey.shade600,
          fontSize: 20.0,
          fontStyle: FontStyle.italic,
        ),
      ),
    );
    slides.add(
      new Slide(
        title: "SUCCULENTS",
        styleTitle: TextStyle(
          color: Colors.grey.shade700,
          fontSize: 30.0,
          fontWeight: FontWeight.bold,
        ),
        description: "This is a test idea.",
        styleDescription: TextStyle(
          color: Colors.grey.shade600,
          fontSize: 20.0,
          fontStyle: FontStyle.italic,
        ),
      ),
    );
    slides.add(
      new Slide(
        title: "PRODUCE",
        styleTitle: TextStyle(
          color: Colors.grey.shade700,
          fontSize: 30.0,
          fontWeight: FontWeight.bold,
        ),
        description: "This is a test idea.",
        styleDescription: TextStyle(
          color: Colors.grey.shade600,
          fontSize: 20.0,
          fontStyle: FontStyle.italic,
        ),
      ),
    );
  }

  void onTabChangeCompleted(index) {
    // Index of current tab is focused
  }

  void onDonePress() {
    this.goToTab(0);
  }

  Widget showNextButton() {
    return NeumorphicContainer(
      child: Padding(
        padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 5.0, bottom: 5.0),
        child: Icon(
          Icons.navigate_next,
          color: Colors.grey.shade700,
          size: 35.0,
        ),
      ),
    );
  }

  Widget showDoneButton() {
    return NeumorphicContainer(
      child: Padding(
        padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 5.0, bottom: 5.0),
        child: Icon(
          Icons.done,
          color: Colors.grey.shade700,
          size: 35.0,
        ),
      ),
    );
  }

  Widget showSkipButton() {
    return NeumorphicContainer(
      child: Padding(
        padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 5.0, bottom: 5.0),
        child: Icon(
          Icons.skip_next,
          color: Colors.grey.shade700,
          size: 35.0,
        ),
      ),
    );
  }

  List<Widget> renderListCustomTabs() {
    List<Widget> tabs = new List();
    for (int i = 0; i < slides.length; i++) {
      Slide currentSlide = slides[i];
      tabs.add(Container(
        width: double.infinity,
        height: double.infinity,
        child: Container(
          margin: EdgeInsets.only(bottom: 60.0, top: 60.0),
          child: ListView(
            children: <Widget>[
              Container(
                child: Text(
                  currentSlide.title,
                  style: currentSlide.styleTitle,
                  textAlign: TextAlign.center,
                ),
                margin: EdgeInsets.only(top: 20.0),
              ),
              Container(
                child: Text(
                  currentSlide.description,
                  style: currentSlide.styleDescription,
                  textAlign: TextAlign.center,
                  maxLines: 5,
                  overflow: TextOverflow.ellipsis,
                ),
                margin: EdgeInsets.only(top: 20.0),
              ),
            ],
          ),
        ),
      ));
    }
    return tabs;
  }

  @override
  Widget build(BuildContext context) {
    return new IntroSlider(
      slides: this.slides,

      renderSkipBtn: this.showSkipButton(),

      renderNextBtn: this.showNextButton(),

      renderDoneBtn: this.showDoneButton(),
      onDonePress: this.onDonePress,

      colorDot: Theme.of(context).dialogBackgroundColor,
      sizeDot: 13.0,
      typeDotAnimation: dotSliderAnimation.SIZE_TRANSITION,

      listCustomTabs: this.renderListCustomTabs(),
      backgroundColorAllSlides: Theme.of(context).backgroundColor,
      refFuncGoToTab: (refFunc) {
        this.goToTab = refFunc;
      },

      shouldHideStatusBar: false,

      onTabChangeCompleted: this.onTabChangeCompleted,
    );
  }
}