import 'package:flutter/material.dart';

class EmotionSticker extends StatefulWidget {
  final VoidCallback onTransform;
  final String imagePath;
  final isSelected;
  const EmotionSticker({
    super.key,
    required this.onTransform,
    required this.imagePath,
    this.isSelected,
  });

  @override
  State<EmotionSticker> createState() => _EmotionStickerState();
}

class _EmotionStickerState extends State<EmotionSticker> {
  double scale = 1;
  double hTransform = 0;
  double vTransform = 0;
  double actualScale = 1;

  @override
  Widget build(BuildContext context) {
    return Transform(
      transform: Matrix4.identity()
        ..translate(hTransform, vTransform)
        ..scale(
          scale,
          scale,
        ),
      child: Container(
        decoration: widget.isSelected
            ? BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: Colors.blue, width: 1),
              )
            : BoxDecoration(
                border: Border.all(
                  width: 1,
                  color: Colors.transparent,
                ),
              ),
        child: GestureDetector(
          onTap: () {
            widget.onTransform();
          },
          onScaleUpdate: (details) {
            widget.onTransform();
            setState(() {
              scale = details.scale * actualScale;
              vTransform += details.focalPointDelta.dy;
              hTransform += details.focalPointDelta.dx;
            });
          },
          onScaleEnd: (details) {
            actualScale = scale;
          },
          child: Image.asset(
            widget.imagePath,
          ),
        ),
      ),
    );
  }
}
