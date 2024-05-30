import "package:flutter/material.dart";

showSnackbar({required BuildContext context, required String message, bool isError = true}) {
  SnackBar snackBar = SnackBar(
    content: Text(message),
    backgroundColor: isError ? const Color(0xFFB10203) : const Color(0xFF808080),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    duration: const Duration(seconds: 3),
    showCloseIcon: true,
    margin: const EdgeInsets.all(10),
    behavior: SnackBarBehavior.floating,
    

  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
