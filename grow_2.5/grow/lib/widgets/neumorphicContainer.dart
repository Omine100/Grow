import 'package:flutter/material.dart';

class NeumorphicContainer extends StatefulWidget {
  NeumorphicContainer({Key key, this.child, this.bevel = 10.0, this.color}) : this.blurOffset = Offset(bevel / 2.0, bevel / 2.0), super(key: key);
  
  //VARIBLE DECLARATION: NEUMORPHIC CONTAINER FORMATTING
  final Widget child;
  final double bevel;
  final Offset blurOffset;
  final Color color;

  @override
  _NeumorphicContainerState createState() => _NeumorphicContainerState();
}

class _NeumorphicContainerState extends State<NeumorphicContainer> {
  //VARIABLE INITIALIZATION: NEUMORPHIC CONTAINER STATE VALUES
  bool _isPressed = false;

  //MECHANICS: SET _isPressed TO TRUE
  void _onPointerDown(PointerDownEvent event) {
    setState(() {
      _isPressed = true;
    });
  }

  //MECHANICS: SET _isPressed TO FALSE
  void _onPointerUp(PointerUpEvent event) {
    setState(() {
      _isPressed = false;
    });
  }

  //USER INTERFACE: NEUMORPHIC CONTAINER
  @override
  Widget build(BuildContext context) {
    final color = this.widget.color ?? Theme.of(context).backgroundColor;

    return Listener(
      onPointerDown: _onPointerDown,
      onPointerUp: _onPointerUp,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),

        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(widget.bevel * 20),
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                _isPressed ? color : color.mix(Colors.black, .05),
                _isPressed ? color.mix(Colors.black, .05) : color,
                _isPressed ? color.mix(Colors.black, .05) : color,
                color.mix(Colors.white, _isPressed ? .2 : .5),
              ],
              stops: [
                0.0,
                .3,
                .6,
                1.0,
              ]),
          boxShadow: _isPressed ? null : [
            BoxShadow(
              blurRadius: widget.bevel,
              offset: -widget.blurOffset,
              color: color.mix(Colors.white, .6),
            ),
            BoxShadow(
              blurRadius: widget.bevel,
              offset: widget.blurOffset,
              color: color.mix(Colors.black, .3),
            )
          ],
        ),
        child: widget.child,
      ),
    );
  }
}

//EXTENSION: COLOR PROPERTIES
extension ColorUtils on Color {
  Color mix(Color another, double amount) {
    return Color.lerp(this, another, amount);
  }
}