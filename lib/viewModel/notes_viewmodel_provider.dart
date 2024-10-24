import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notizen_app/viewModel/notes_viewmodel.dart';

final notesViewModelProvider = ChangeNotifierProvider((ref) => NotesViewModel());