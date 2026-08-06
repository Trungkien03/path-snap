// lib/ui/settings/settings_screen.dart

import 'package:flutter/cupertino.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('Settings'),
        automaticallyImplyLeading: false,
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          child: const Icon(CupertinoIcons.xmark, size: 22),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      child: SafeArea(
        child: ListView(
          children: [
            const SizedBox(height: 20),

            // Section: App
            CupertinoListSection.insetGrouped(
              header: const Text('APP'),
              children: [
                CupertinoListTile(
                  title: const Text('Phiên bản'),
                  trailing: Text(
                    '1.0.0',
                    style: TextStyle(color: CupertinoColors.systemGrey),
                  ),
                ),
                CupertinoListTile(
                  title: const Text('Giao diện'),
                  trailing: const Text('Hệ thống'),
                  onTap: () {
                    // TODO: chọn Light / Dark / System
                  },
                ),
              ],
            ),

            // Section: Data
            CupertinoListSection.insetGrouped(
              header: const Text('DỮ LIỆU'),
              children: [
                CupertinoListTile(
                  title: const Text('Sao lưu dữ liệu'),
                  leading: const Icon(CupertinoIcons.cloud_upload),
                  onTap: () {
                    // TODO: backup
                  },
                ),
                CupertinoListTile(
                  title: const Text('Khôi phục dữ liệu'),
                  leading: const Icon(CupertinoIcons.cloud_download),
                  onTap: () {
                    // TODO: restore
                  },
                ),
              ],
            ),

            // Section: About
            CupertinoListSection.insetGrouped(
              header: const Text('THÔNG TIN'),
              children: [
                CupertinoListTile(
                  title: const Text('Về PathSnap'),
                  leading: const Icon(CupertinoIcons.info),
                  onTap: () {
                    // TODO: about
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
