import 'package:flutter/material.dart';

class NeumorphicContainer extends StatefulWidget {
  NeumorphicContainer({Key key, this.child, this.bevel = 10.0, this.color, this.radius, this.clickable, this.padding, this.height, this.width}) : this.blurOffset = Offset(bevel / 2.0, bevel / 2.0), super(key: key);

  //VARIABLE DECLARATION: NEUMOPRHIC CONTAINER FORMATTING
  final Widget child;
  final double bevel;
  final Offset blurOffset;
  final Color color;
  final bool clickable;
  final double radius;
  final double padding;
  final double height;
  final double width;

  @override
  _NeumorphicContainerState createState() => _NeumorphicContainerState();
}

class _NeumorphicContainerState extends State<NeumorphicContainer> {
  //VARIABLE INITIALIZATION: NEUMORPHIC CONTAINER STATE VALUES
  bool clickable = false;
  bool _isPressed = false;

  //MECHANICS: CLICKABLE VARIABLE INITIALIZATION
  bool _clickable() {
    clickable = widget.clickable;
    return clickable;
  }

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
    final radius = this.widget.radius;
    final padding = this.widget.padding;
    final height = this.widget.height;
    final width = this.widget.width;

    return Listener(
      onPointerDown: _clickable() ? _onPointerDown : null,
      onPointerUp: _clickable() ? _onPointerUp : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius),
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment(1.0, 1.0),
              colors: [
                _isPressed ? color : color.mix(Colors.black, .0725),
                _isPressed ? color.mix(Colors.black, .05) : color,
                _isPressed ? color.mix(Colors.black, .05) : color,
                color.mix(Colors.white, _isPressed ? .2 : .025),
              ],
              stops: [
                0.0,
                0.3,
                0.6,
                1.0,
              ]
          ),
          boxShadow: _isPressed ? null : [
            BoxShadow(
              blurRadius: widget.bevel,
              offset: -widget.blurOffset * 1,
              color: color.mix(Colors.black, 0.125),
            ),
            BoxShadow(
              blurRadius: widget.bevel,
              offset: widget.blurOffset * 1.1,
              color: color.mix(Colors.black, .25),
            )
          ],
        ),
        child: Container(
          padding: EdgeInsets.all(padding),
          height: height,
          width: width,
          child: widget.child,
        ),
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