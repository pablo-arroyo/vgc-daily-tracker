import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../domain/backup/backup_format.dart';
import '../../../utils/result.dart';
import '../view_models/backup_view_model.dart';

/// Copy all data out as a JSON backup, or paste one back in.
class BackupScreen extends StatefulWidget {
  const BackupScreen({super.key});

  @override
  State<BackupScreen> createState() => _BackupScreenState();
}

class _BackupScreenState extends State<BackupScreen> {
  final _pasted = TextEditingController();

  @override
  void dispose() {
    _pasted.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<BackupViewModel>();
    final textTheme = Theme.of(context).textTheme;
    // Its own messenger, so snackbars stay on this screen.
    return ScaffoldMessenger(
      child: Builder(
        builder: (context) => Scaffold(
          appBar: AppBar(title: const Text('Backup & restore')),
          // A fixed, short form, so build it all rather than lazily.
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            // Capped like the tabs (this screen sits outside their shell).
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 640),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text('Back up', style: textTheme.titleMedium),
                    const SizedBox(height: 4),
                    const Text(
                      'Your teams, games and routine ticks live only on this '
                      'device. Copy a backup and keep it somewhere safe: a '
                      'note, an email or a file.',
                    ),
                    const SizedBox(height: 12),
                    ListenableBuilder(
                      listenable: viewModel.export,
                      builder: (context, _) => FilledButton(
                        onPressed: viewModel.export.running
                            ? null
                            : () => _copy(context),
                        child: const Text('Copy backup'),
                      ),
                    ),
                    const Divider(height: 40),
                    Text('Restore', style: textTheme.titleMedium),
                    const SizedBox(height: 4),
                    const Text(
                      'Restoring merges a backup in: anything with the same id '
                      "is replaced by the backup's copy, and everything else "
                      'stays.',
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _pasted,
                      decoration: const InputDecoration(
                        labelText: 'Paste a backup here',
                        alignLabelWithHint: true,
                        border: OutlineInputBorder(),
                      ),
                      style: const TextStyle(fontFamily: 'monospace'),
                      minLines: 6,
                      maxLines: 12,
                      keyboardType: TextInputType.multiline,
                    ),
                    const SizedBox(height: 12),
                    ListenableBuilder(
                      listenable: viewModel.restore,
                      builder: (context, _) => FilledButton(
                        onPressed: viewModel.restore.running
                            ? null
                            : () => _restore(context),
                        child: const Text('Restore'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _copy(BuildContext context) async {
    final export = context.read<BackupViewModel>().export;
    final messenger = ScaffoldMessenger.of(context);
    await export.execute();
    final String message;
    if (export.result case Ok(value: (:final text, :final summary))) {
      await Clipboard.setData(ClipboardData(text: text));
      message = 'Backup copied: $summary';
    } else {
      message = "Couldn't create the backup. Try again.";
    }
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _restore(BuildContext context) async {
    final restore = context.read<BackupViewModel>().restore;
    final messenger = ScaffoldMessenger.of(context);
    await restore.execute(_pasted.text);
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(switch (restore.result) {
            Ok(value: final summary) => 'Restored $summary',
            Failure(error: BackupFormatException(:final message)) => message,
            _ => "Couldn't restore the backup. Try again.",
          }),
        ),
      );
  }
}
