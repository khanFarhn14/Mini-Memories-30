import 'package:flutter/material.dart';

class Components{
  static void showSnackBarForFeedback({
    required BuildContext context,
    required String message,
    required bool isError
  }){
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        elevation: 0,
        margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        backgroundColor: const Color(0xff000000),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8)
        ),
        content: Row(
          children: [
            isError ? const Icon(Icons.error_outline_rounded, color: Colors.red,size: 24,):
            const Icon(Icons.done, color: Colors.green,size: 24,),
            const SizedBox(width: 12,),
            Text(
                message,
                style: const TextStyle(color: Colors.white, fontSize: 14),
                textAlign: TextAlign.start,
            ),
          ],
        ),
        duration: const Duration(milliseconds: 800),
      )
    );
  }
}