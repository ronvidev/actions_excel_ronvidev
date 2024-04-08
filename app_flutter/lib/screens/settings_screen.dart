import 'package:autocells/providers/app_provider.dart';
import 'package:autocells/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isReady = false;

  void _updateApp() {
    context.read<AppProvider>().updateApp();

  }

  @override
  void initState() {
    context.read<AppProvider>().verifyUpdate().whenComplete(() {
      setState(() => _isReady = true);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final appProvider = context.watch<AppProvider>();
    final isUpdated = appProvider.isUpdated;
    final isUpdating = appProvider.isUpdating;
    final appVersion = appProvider.versionApp;
    final newVersionApp = appProvider.newVersionApp;

    return Scaffold(
      appBar: mainBar(
          context: context,
          title: 'Configuración',
          leading: ActionButton(
            child: const Icon(Icons.arrow_back_ios_new_rounded),
            onPressed: () => Navigator.pop(context),
          )),
      body: _isReady
          ? Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isUpdated
                                ? 'Aplicación actualizada'
                                : 'Actualización disponible',
                            style: const TextStyle(fontSize: 20.0),
                          ),
                          const SizedBox(width: 8.0),
                          if (!isUpdated)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Versión actual: $appVersion'),
                                Text('Versión nueva: $newVersionApp'),
                              ],
                            ),
                        ],
                      ),
                      Row(
                        children: [
                          if (isUpdating)
                            const SizedBox.square(
                              dimension: 20.0,
                              child: CircularProgressIndicator(),
                            ),
                          const SizedBox(width: 8.0),
                          ActionButton(
                            padding: const EdgeInsets.all(16.0),
                            onPressed:
                                isUpdated || isUpdating ? null : _updateApp,
                            child: const Text('Actualizar'),
                          ),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }

  // void _showDialog() {
  //   showDialog(
  //       context: context,
  //       builder: (context) {
  //         //
  //         return const UpdateDialog();
  //       });
  // }
}
