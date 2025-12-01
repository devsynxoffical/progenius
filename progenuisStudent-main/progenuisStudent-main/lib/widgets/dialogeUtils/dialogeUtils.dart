import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:progenius/student/utils/appColors.dart';

class DialogUtil {
  // Basic customizable dialog
  static Future<T?> showCustomDialog<T>({
    String? title,
    String? message,
    Widget? content,
    String? positiveText = 'OK',
    String? negativeText,
    VoidCallback? onPositivePressed,
    VoidCallback? onNegativePressed,
    bool barrierDismissible = true,
    Color? positiveColor,
    Color? negativeColor,
    bool showIcon = false,
    IconData? icon,
    Color? iconColor,
  }) {
    return Get.dialog<T>(
      WillPopScope(
        onWillPop: () async => barrierDismissible,
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          titlePadding: const EdgeInsets.only(top: 20, left: 20, right: 20),
          contentPadding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
          actionsPadding: const EdgeInsets.only(bottom: 10, right: 10),
          title: title != null ? Column(
            children: [
              if (showIcon && icon != null)
                Icon(icon, size: 40, color: iconColor ?? AppColors.secondary),
              if (showIcon && icon != null) const SizedBox(height: 8),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ) : null,
          content: content ?? (message != null ? Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16),
          ) : null),
          actions: [
            if (negativeText != null)
              TextButton(
                onPressed: onNegativePressed ?? () => Get.back(),
                child: Text(
                  negativeText,
                  style: TextStyle(
                    color: negativeColor ?? Colors.grey[700],
                    fontSize: 16,
                  ),
                ),
              ),
            TextButton(
              onPressed: onPositivePressed ?? () => Get.back(),
              child: Text(
                positiveText!,
                style: TextStyle(
                  color: positiveColor ?? AppColors.secondary,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
      barrierDismissible: barrierDismissible,
    );
  }

  // Success dialog
  static Future<T?> showSuccessDialog<T>({
    String? title = 'Success',
    String? message,
    Widget? content,
    String? buttonText = 'OK',
    VoidCallback? onPressed,
  }) {
    return showCustomDialog<T>(
      title: title,
      message: message,
      content: content,
      positiveText: buttonText,
      onPositivePressed: onPressed,
      showIcon: true,
      icon: Icons.check_circle,
      iconColor: Colors.green,
      positiveColor: Colors.green,
    );
  }

  // Error dialog
  static Future<T?> showErrorDialog<T>({
    String? title = 'Error',
    String? message,
    Widget? content,
    String? buttonText = 'OK',
    VoidCallback? onPressed,
  }) {
    return showCustomDialog<T>(
      title: title,
      message: message,
      content: content,
      positiveText: buttonText,
      onPositivePressed: onPressed,
      showIcon: true,
      icon: Icons.error,
      iconColor: Colors.red,
      positiveColor: Colors.red,
    );
  }

  // Confirmation dialog
  static Future<T?> showConfirmationDialog<T>({
    String? title = 'Are you sure?',
    String? message,
    Widget? content,
    String? confirmText = 'Confirm',
    String? cancelText = 'Cancel',
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
  }) {
    return showCustomDialog<T>(
      title: title,
      message: message,
      content: content,
      positiveText: confirmText,
      negativeText: cancelText,
      onPositivePressed: onConfirm,
      onNegativePressed: onCancel,
      showIcon: true,
      icon: Icons.warning_rounded,
      iconColor: Colors.orange,
      positiveColor: Colors.red,
    );
  }

  // Loading dialog
  static Future<T?> showLoadingDialog<T>({
    String? message = 'Loading...',
    bool barrierDismissible = false,
  }) {
    return Get.dialog<T>(
      WillPopScope(
        onWillPop: () async => barrierDismissible,
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          content: Row(
            children: [
              const CircularProgressIndicator(),
              const SizedBox(width: 20),
              Expanded(
                child: Text(
                  message!,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: barrierDismissible,
    );
  }

  // Dismiss all dialogs
  static void dismissDialog<T>([T? result]) {
    if (Get.isDialogOpen ?? false) {
      Get.back<T>(result: result);
    }
  }
}