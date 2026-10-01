import 'package:flutter/material.dart';

/// Edits one matchup's game plan ("Big Six vs Rival Grassy"); pops with
/// the text, or null on Cancel. Used by the team detail and Log Game.
class MatchupNotesDialog extends StatefulWidget {
  const MatchupNotesDialog({
    required this.title,
    required this.initial,
    super.key,
  });

  final String title;
  final String initial;

  @override
  State<MatchupNotesDialog> createState() => _MatchupNotesDialogState();
}

class _MatchupNotesDialogState extends State<MatchupNotesDialog> {
  late final _notes = TextEditingController(text: widget.initial);

  @override
  void dispose() {
    _notes.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      // A comfortable writing width; narrow screens still clamp it.
      content: SizedBox(
        width: 480,
        child: TextField(
          controller: _notes,
          autofocus: true,
          decoration: const InputDecoration(
            labelText: 'Game plan',
            hintText: 'Leads, what to watch for, who to save for the back…',
            alignLabelWithHint: true,
            border: OutlineInputBorder(),
          ),
          minLines: 4,
          maxLines: 10,
          keyboardType: TextInputType.multiline,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, _notes.text),
          child: const Text('Save'),
        ),
      ],
    );
  }
}
