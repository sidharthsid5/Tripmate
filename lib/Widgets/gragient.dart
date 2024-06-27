// import 'package:flutter/material.dart';

// class GradientLoadingButton extends StatefulWidget {
//   final VoidCallback onPressed;
//   final String text;

//   const GradientLoadingButton({
//     Key? key,
//     required this.onPressed,
//     required this.text,
//   }) : super(key: key);

//   @override
//   _GradientLoadingButtonState createState() => _GradientLoadingButtonState();
// }

// class _GradientLoadingButtonState extends State<GradientLoadingButton>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<Color?> _animation;

//   bool _loading = false;

//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       vsync: this,
//       duration: const Duration(seconds: 2),
//     );
//     _animation = ColorTween(
//       begin: Colors.green,
//       end: Colors.lightGreen,
//     ).animate(_controller);
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   void _startAnimation() {
//     _controller.repeat(reverse: true);
//   }

//   void _stopAnimation() {
//     _controller.reset();
//   }

//   void _onPressed() async {
//     setState(() {
//       _loading = true;
//     });
//     _startAnimation();

//     widget.onPressed();

//     setState(() {
//       _loading = false;
//     });
//     _stopAnimation();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return ElevatedButton(
//       onPressed: _loading ? null : _onPressed,
//       style: ButtonStyle(
//         backgroundColor: WidgetStateProperty.all<Color>(Colors.green),
//         shadowColor: WidgetStateProperty.all<Color>(Colors.green),
//         shape: WidgetStateProperty.all<RoundedRectangleBorder>(
//           RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(18.0),
//           ),
//         ),
//       ),
//       child: Ink(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             colors: [_animation.value!, Colors.green],
//             begin: Alignment.centerLeft,
//             end: Alignment.centerRight,
//           ),
//           borderRadius: BorderRadius.circular(18.0),
//         ),
//         child: _loading
//             ? const SizedBox(
//                 width: 24.0,
//                 height: 24.0,
//                 child: CircularProgressIndicator(
//                   strokeWidth: 2.0,
//                   valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
//                 ),
//               )
//             : Text(
//                 widget.text,
//                 textAlign: TextAlign.center,
//                 style: const TextStyle(
//                   color: Colors.white,
//                   fontSize: 16.0,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//       ),
//     );
//   }
// }
