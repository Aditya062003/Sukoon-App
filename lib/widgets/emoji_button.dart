import 'package:flutter/material.dart';

class EmojiButton extends StatelessWidget {
  final String emoji;
  final String title;
  final String subtitle;
  final double height;
  final bool enableSubtitle;
  final void Function()? onPressed; // Change to 'void Function()?' type
  Color backgroundColor;
  Color outlineColor;

  EmojiButton({
    required this.emoji,
    required this.title,
    this.subtitle = '',
    this.height = 55.0,
    this.enableSubtitle = false,
    required this.onPressed,
    this.backgroundColor = Colors.transparent,
    this.outlineColor = Colors.grey,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          8.0,
        ),
        color: backgroundColor,
      ),
      child: ButtonTheme(
        height: height,
        child: OutlinedButton(
          onPressed: onPressed, // This is now compatible with 'void Function()?'
          style: OutlinedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            side: BorderSide(
              color: outlineColor ?? Colors.grey.shade100, // outline color
            ),
            foregroundColor: Colors.black, // text color, set to black or any color you prefer
            backgroundColor: Colors.transparent, // background color, keep transparent for outlined button
          ),
          child: Row(
            children: <Widget>[
              Text(
                emoji,
                style: const TextStyle(
                  fontSize: 18.0,
                ),
              ),
              SizedBox(
                width: 20.0,
              ),
              enableSubtitle
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                        SizedBox(
                          height: 2,
                        ),
                        Text(
                          subtitle,
                          style: const TextStyle(
                            fontSize: 12.0,
                          ),
                        )
                      ],
                    )
                  : Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16.0,
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
