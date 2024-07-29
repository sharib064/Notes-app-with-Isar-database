import 'package:flutter/material.dart';
import 'package:notesapp/models/notes.dart';
import 'package:notesapp/models/notes_database.dart';
import 'package:popover/popover.dart';
import 'package:provider/provider.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  final textController = TextEditingController();
  @override
  void initState() {
    super.initState();
    readNotes();
  }

  void updateNote(Notes note) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Update note"),
        content: TextField(
          controller: textController,
        ),
        actions: [
          MaterialButton(
            onPressed: () {
              context
                  .read<NotesDatabase>()
                  .updateNotes(note.id, textController.text);
              textController.clear();
              Navigator.pop(context);
            },
            child: const Text("Update"),
          )
        ],
      ),
    );
  }

  void deleteNote(int id) {
    context.read<NotesDatabase>().deleteNote(id);
  }

  void readNotes() {
    context.read<NotesDatabase>().fetchNotes();
  }

  void addNote() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Add note"),
        content: TextField(
          controller: textController,
        ),
        actions: [
          MaterialButton(
            onPressed: () {
              context.read<NotesDatabase>().addNote(textController.text);
              textController.clear();
              Navigator.pop(context);
            },
            child: const Text("Create"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final notesDatabase = context.watch<NotesDatabase>();
    List<Notes> currentNotes = notesDatabase.currentNotes;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      drawer: Drawer(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        child: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30),
              child: SizedBox(
                height: 100,
                width: double.infinity,
                child: Icon(
                  Icons.note,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
            ListTile(
              onTap: () {
                Navigator.pop(context);
              },
              leading: Icon(
                Icons.home,
                color: Theme.of(context).colorScheme.primary,
              ),
              title: Text(
                "Home",
                style: TextStyle(color: Theme.of(context).colorScheme.primary),
              ),
            ),
            ListTile(
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/setting_page');
              },
              leading: Icon(
                Icons.settings,
                color: Theme.of(context).colorScheme.primary,
              ),
              title: Text(
                "Setting",
                style: TextStyle(color: Theme.of(context).colorScheme.primary),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        onPressed: () => addNote(),
        shape: const CircleBorder(eccentricity: 0),
        child: Icon(
          Icons.add,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
      body: currentNotes.isEmpty
          ? const Center(
              child: Text("No notes found"),
            )
          : ListView.builder(
              itemCount: currentNotes.length,
              itemBuilder: (context, index) {
                final note = currentNotes[index];
                return Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  margin: const EdgeInsets.only(top: 10, left: 20, right: 20),
                  child: ListTile(
                    textColor: Theme.of(context).colorScheme.inversePrimary,
                    iconColor: Theme.of(context).colorScheme.inversePrimary,
                    title: Text(note.text),
                    trailing: Builder(
                      builder: (context) => IconButton(
                        icon: const Icon(Icons.more_vert),
                        onPressed: () => showPopover(
                          width: 100,
                          height: 100,
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                          context: context,
                          bodyBuilder: (context) {
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pop(context);
                                    updateNote(note);
                                  },
                                  child: SizedBox(
                                    width: 50,
                                    child: Center(
                                        child: Text(
                                      "Edit",
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .inversePrimary,
                                          fontWeight: FontWeight.bold),
                                    )),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pop(context);
                                    deleteNote(note.id);
                                  },
                                  child: SizedBox(
                                    width: 50,
                                    child: Center(
                                      child: Text(
                                        "Delete",
                                        style: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .inversePrimary,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
