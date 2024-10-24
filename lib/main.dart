import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notizen_app/viewModel/notes_viewmodel_provider.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notizen App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const NotesScreen(),
    );
  }
}

class NotesScreen extends ConsumerStatefulWidget {
  const NotesScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _NotesScreenState createState() => _NotesScreenState();
}

class _NotesScreenState extends ConsumerState<NotesScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  FocusNode titleFocusNode = FocusNode();
  FocusNode contentFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    Future.microtask(
        () => ref.read(notesViewModelProvider.notifier).fetchNotes());
  }

  @override
  void dispose() {
    titleFocusNode.dispose();
    contentFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(notesViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notizen mit Backend'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.read(notesViewModelProvider.notifier).fetchNotes();
            },
          ),
        ],
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context)
              .unfocus();
        },
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              if (viewModel.isLoading) const CircularProgressIndicator(),
              Expanded(
                child: viewModel.notes.isEmpty
                    ? const Center(
                        child: Text(
                          'Keine Notizen verfügbar',
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                      )
                    : ListView.builder(
                        itemCount: viewModel.notes.length,
                        itemBuilder: (context, index) {
                          final note = viewModel.notes[index];
                          return Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            elevation: 5,
                            margin: const EdgeInsets.symmetric(vertical: 8.0),
                            child: ExpansionTile(
                              title: Text(
                                note['title'],
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Text(
                                    note['content'],
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit,
                                          color: Colors.blue),
                                      onPressed: () {
                                        setState(() {
                                          viewModel.editingNoteId = note['id'];
                                          titleController.text = note['title'];
                                          contentController.text =
                                              note['content'];
                                        });
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete,
                                          color: Colors.red),
                                      onPressed: () {
                                        ref
                                            .read(
                                                notesViewModelProvider.notifier)
                                            .deleteNote(note['id']);
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: titleController,
                focusNode: titleFocusNode,
                decoration: InputDecoration(
                  labelText: 'Titel der Notiz',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: contentController,
                focusNode: contentFocusNode,
                maxLines: 1,
                decoration: InputDecoration(
                  labelText: 'Inhalt der Notiz',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: viewModel.editingNoteId == null
                          ? () {
                              ref.read(notesViewModelProvider.notifier).addNote(
                                    titleController.text,
                                    contentController.text,
                                  );
                              titleController.clear();
                              contentController.clear();
                              FocusScope.of(context).unfocus();
                            }
                          : () {
                              ref
                                  .read(notesViewModelProvider.notifier)
                                  .updateNote(
                                    titleController.text,
                                    contentController.text,
                                  );
                              titleController.clear();
                              contentController.clear();
                              FocusScope.of(context).unfocus();
                            },
                      child: Text(viewModel.editingNoteId == null
                          ? 'Notiz hinzufügen'
                          : 'Änderungen speichern'),
                    ),
                  ),
                  if (viewModel.editingNoteId != null)
                    const SizedBox(width: 10),
                  if (viewModel.editingNoteId != null)
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey,
                        ),
                        onPressed: () {
                          ref
                              .read(notesViewModelProvider.notifier)
                              .clearEditing();
                          titleController.clear();
                          contentController.clear();
                          FocusScope.of(context).unfocus();
                        },
                        child: const Text('Abbrechen'),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
