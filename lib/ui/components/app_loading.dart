// lib/ui/common/app_loading.dart

import 'package:flutter/cupertino.dart';

class AppLoading extends StatelessWidget {
  final String? message;

  const AppLoading({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CupertinoActivityIndicator(radius: 14),
          if (message != null) ...[
            const SizedBox(height: 12),
            Text(
              message!,
              style: TextStyle(color: CupertinoColors.systemGrey, fontSize: 15),
            ),
          ],
        ],
      ),
    );
  }
}
