import 'package:flutter/material.dart';

class Snackbar {
  static void showSnackBar(BuildContext context,
      {required String content, required bool isSuccess}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isSuccess ? Icons.done_rounded : Icons.close_rounded,
              color: Colors.white,
            ),
            const SizedBox(
              width: 8,
            ),
            Flexible(
              child: Text(
                content,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: isSuccess ? Colors.green : Colors.red,
      ),
    );
  }
}
