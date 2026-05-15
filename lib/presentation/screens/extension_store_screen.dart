import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/extension_manager.dart';

final extensionsStateProvider = FutureProvider((ref) async {
  final manager = ref.read(extensionManagerProvider);
  await manager.fetchRemoteExtensions();
  return manager.availableExtensions;
});

class ExtensionStoreScreen extends ConsumerWidget {
  const ExtensionStoreScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final extensionsFuture = ref.watch(extensionsStateProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Extensions Store')),
      body: extensionsFuture.when(
        data: (extensions) {
          if(extensions.isEmpty){
             return const Center(child: Text('No extensions found in global repo.'));
          }

          return ListView.builder(
            itemCount: extensions.length,
            itemBuilder: (context, index) {
              final ext = extensions[index];
              final isInstalled = ext.isInstalled;

              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.grey.shade800,
                  child: Text(ext.name[0].toUpperCase()),
                ),
                title: Text(ext.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text('${ext.type.toUpperCase()} • v${ext.version} • ${ext.lang}'),
                trailing: ElevatedButton(
                  onPressed: () async {
                    final manager = ref.read(extensionManagerProvider);
                    if (isInstalled) {
                      await manager.uninstallExtension(ext);
                    } else {
                      await manager.installExtension(ext);
                    }
                    // Triggers the UI to reload locally and sync storage states exactly as tachiyomi/aniyomi does
                    ref.refresh(extensionsStateProvider);
                  },
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: isInstalled ? Colors.red.shade900.withOpacity(0.2) : Colors.blueAccent.withOpacity(0.2),
                    foregroundColor: isInstalled ? Colors.redAccent : Colors.blueAccent,
                  ),
                  child: Text(isInstalled ? 'Uninstall' : 'Install'),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Network Configuration Error: $e')),
      ),
    );
  }
}