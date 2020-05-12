import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:animations/animations.dart';

import 'package:grow/services/authentication.dart';
import 'package:grow/services/themes.dart';
import 'package:grow/widgets/interfaceStandards.dart';
import 'package:grow/pages/addGoal.dart';
import 'package:grow/pages/profile.dart';
import 'package:grow/pages/userGoal.dart';

class AnimationStandards {
  //VARIABLE DECLARATION
  InterfaceStandards interfaceStandards = new InterfaceStandards();
  Themes themes = new Themes();
  ContainerTransitionType containerTransitionType = ContainerTransitionType.fade;

  //USER EXPERIENCE: CONTAINER TRANSITION ANIMATION
  OpenContainer showContainerTransitionAnimation(BuildContext context, int animationCase, BaseAuth auth, VoidCallback logoutCallback, String userId, DocumentSnapshot document, Widget child) {
    return OpenContainer(
      transitionType: containerTransitionType,
      transitionDuration: Duration(milliseconds: 675),
      closedElevation: 0.0,
      closedColor: animationCase == 1 ? 
        Theme.of(context).accentColor : 
        (animationCase == 2 ? 
          Colors.transparent :
          Colors.transparent
        ),
      closedShape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(45),
        ),
      ),
      closedBuilder: (BuildContext context, VoidCallback openContainer) {
        return animationCase == 1 ? 
          SizedBox(
            height: 56.0,
            width: 56.0,
            child: Center(
              child: Icon(
                Icons.add,
                color: Theme.of(context).scaffoldBackgroundColor,
              ),
            ),
          ) : 
          (animationCase == 2 ? 
            Container(
              height: MediaQuery.of(context).size.height * 0.01,
              width: MediaQuery.of(context).size.width * 0.32,
              decoration: BoxDecoration(
                gradient: interfaceStandards.cardLinearGradient(context, document),
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(62.0),
                  topLeft: Radius.circular(15.0),
                  bottomRight: Radius.circular(15.0),
                  bottomLeft: Radius.circular(15.0),
                ),
                boxShadow: [new BoxShadow(
                  color: themes.checkDarkTheme(context) ? Colors.grey.shade900 : Colors.grey.shade400,
                  blurRadius: 1,
                  offset: new Offset(10, 10)
                )]
              ),
              child: child,
            ) :
            Container()
          );
      },
      openBuilder: (BuildContext context, VoidCallback _) {
        return animationCase == 1 ? 
          AddGoalScreen(auth: auth, logoutCallback: logoutCallback, userId: userId,) : 
          (animationCase == 2 ? 
            UserGoal(auth: auth, logoutCallback: logoutCallback, userId: userId, documentSnapshot: document,) :
            ProfileScreen(auth: auth, logoutCallback: logoutCallback, userId: userId,)
          );
      },
    );
  }
}