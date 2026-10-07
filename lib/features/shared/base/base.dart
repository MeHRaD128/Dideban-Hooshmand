// import 'package:flutter/material.dart';

// class Base extends StatelessWidget {
//   final Widget child;
//   final double minWidth;
//   final EdgeInsets padding;

//   const Base({
//     super.key,
//     required this.child,
//     this.minWidth = 400,
//     this.padding = const EdgeInsets.all(8.0),
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       resizeToAvoidBottomInset: true,
//       body: SafeArea(
//         child: Center(
//           child: ConstrainedBox(
//             constraints: BoxConstraints(minWidth: minWidth),
//             child: Padding(padding: padding, child: child),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';

class Base extends StatelessWidget {
  final Widget child;
  final double maxWidth;
  final EdgeInsets padding;

  const Base({
    super.key,
    required this.child,
    this.maxWidth = 600,
    this.padding = const EdgeInsets.all(20.0),
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Padding(
          padding: padding,
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxWidth),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
