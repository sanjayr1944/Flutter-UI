# Firebase Firestore CRUD Implementation Guide

This guide walks you through implementing real-time CRUD operations in your Flutter app using **Cloud Firestore** and **BLoC**, where:
- **Admin**: Can **Create**, **Read**, **Update**, and **Delete** items (e.g., announcements, products, or posts).
- **User**: Has **Read-only** access and sees real-time updates as soon as an admin adds, edits, or deletes an item.

---

## Architecture Overview

```
lib/
├── features/
│   ├── items/
│   │   ├── data/
│   │   │   └── item_repository.dart       # Firestore CRUD logic
│   │   ├── domain/
│   │   │   └── item_model.dart            # Data model (Item)
│   │   └── presentation/
│   │       ├── bloc/
│   │       │   ├── item_bloc.dart         # Item state management
│   │       │   ├── item_event.dart        # Item events
│   │       │   └── item_state.dart        # Item states
│   │       └── widgets/
│   │           ├── add_edit_item_dialog.dart # Dialog for Admin
│   │           └── item_card.dart         # Reusable item display card
```

---

## Step 1: Firestore Security Rules (`firestore.rules`)

To enforce at the database level that only admins can write while regular users can read, configure your Firestore security rules:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    
    // Helper function to check if the user is authenticated
    function isAuthenticated() {
      return request.auth != null;
    }
    
    // Helper function to check if the current user has the admin role
    function isAdmin() {
      return isAuthenticated() && 
        get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role == 'admin';
    }

    // User profile collection
    match /users/{userId} {
      allow read: if isAuthenticated();
      allow create: if isAuthenticated() && request.auth.uid == userId;
      allow update, delete: if isAdmin();
    }

    // Items collection (Admin can CRUD, Users can only Read)
    match /items/{itemId} {
      allow read: if isAuthenticated();
      allow create, update, delete: if isAdmin();
    }
  }
}
```

---

## Step 2: Create Data Model (`lib/features/items/domain/item_model.dart`)

```dart
import 'package:cloud_firestore/cloud_firestore.dart';

class ItemModel {
  final String id;
  final String title;
  final String description;
  final DateTime createdAt;
  final String createdBy;

  ItemModel({
    required this.id,
    required this.title,
    required this.description,
    required this.createdAt,
    required this.createdBy,
  });

  // Convert Firestore DocumentSnapshot to ItemModel
  factory ItemModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return ItemModel(
      id: doc.id,
      title: data['title'] as String? ?? '',
      description: data['description'] as String? ?? '',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      createdBy: data['createdBy'] as String? ?? 'Admin',
    );
  }

  // Convert ItemModel to Map for Firestore writes
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'createdAt': FieldValue.serverTimestamp(),
      'createdBy': createdBy,
    };
  }

  ItemModel copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? createdAt,
    String? createdBy,
  }) {
    return ItemModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      createdBy: createdBy ?? this.createdBy,
    );
  }
}
```

---

## Step 3: Create Firestore Repository (`lib/features/items/data/item_repository.dart`)

```dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../domain/item_model.dart';

class ItemRepository {
  final FirebaseFirestore _firestore;
  late final CollectionReference _itemsCollection;

  ItemRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance {
    _itemsCollection = _firestore.collection('items');
  }

  // CREATE (Admin)
  Future<void> addItem({
    required String title,
    required String description,
    required String createdBy,
  }) async {
    await _itemsCollection.add({
      'title': title,
      'description': description,
      'createdAt': FieldValue.serverTimestamp(),
      'createdBy': createdBy,
    });
  }

  // READ (Stream for real-time updates for both Admin & User)
  Stream<List<ItemModel>> getItemsStream() {
    return _itemsCollection
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => ItemModel.fromFirestore(doc)).toList();
    });
  }

  // UPDATE (Admin)
  Future<void> updateItem({
    required String id,
    required String title,
    required String description,
  }) async {
    await _itemsCollection.doc(id).update({
      'title': title,
      'description': description,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // DELETE (Admin)
  Future<void> deleteItem(String id) async {
    await _itemsCollection.doc(id).delete();
  }
}
```

---

## Step 4: Create Item BLoC

### 4.1 Events (`lib/features/items/presentation/bloc/item_event.dart`)

```dart
import 'package:equatable/equatable.dart';
import '../../domain/item_model.dart';

abstract class ItemEvent extends Equatable {
  const ItemEvent();

  @override
  List<Object?> get props => [];
}

// Start listening to the real-time stream
class LoadItemsSubscription extends ItemEvent {
  const LoadItemsSubscription();
}

// Internal event emitted when stream pushes new items
class ItemsUpdated extends ItemEvent {
  final List<ItemModel> items;
  const ItemsUpdated(this.items);

  @override
  List<Object?> get props => [items];
}

// Add item (Admin)
class AddItemRequest extends ItemEvent {
  final String title;
  final String description;
  final String createdBy;

  const AddItemRequest({
    required this.title,
    required this.description,
    required this.createdBy,
  });

  @override
  List<Object?> get props => [title, description, createdBy];
}

// Update item (Admin)
class UpdateItemRequest extends ItemEvent {
  final String id;
  final String title;
  final String description;

  const UpdateItemRequest({
    required this.id,
    required this.title,
    required this.description,
  });

  @override
  List<Object?> get props => [id, title, description];
}

// Delete item (Admin)
class DeleteItemRequest extends ItemEvent {
  final String id;
  const DeleteItemRequest(this.id);

  @override
  List<Object?> get props => [id];
}
```

### 4.2 States (`lib/features/items/presentation/bloc/item_state.dart`)

```dart
import 'package:equatable/equatable.dart';
import '../../domain/item_model.dart';

abstract class ItemState extends Equatable {
  const ItemState();

  @override
  List<Object?> get props => [];
}

class ItemInitial extends ItemState {
  const ItemInitial();
}

class ItemLoading extends ItemState {
  const ItemLoading();
}

class ItemLoaded extends ItemState {
  final List<ItemModel> items;
  const ItemLoaded(this.items);

  @override
  List<Object?> get props => [items];
}

class ItemError extends ItemState {
  final String message;
  const ItemError(this.message);

  @override
  List<Object?> get props => [message];
}

class ItemActionSuccess extends ItemState {
  final String message;
  const ItemActionSuccess(this.message);

  @override
  List<Object?> get props => [message];
}
```

### 4.3 BLoC Implementation (`lib/features/items/presentation/bloc/item_bloc.dart`)

```dart
import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/item_repository.dart';
import 'item_event.dart';
import 'item_state.dart';

class ItemBloc extends Bloc<ItemEvent, ItemState> {
  final ItemRepository itemRepository;
  StreamSubscription? _itemsSubscription;

  ItemBloc(this.itemRepository) : super(const ItemInitial()) {
    on<LoadItemsSubscription>(_onLoadItemsSubscription);
    on<ItemsUpdated>(_onItemsUpdated);
    on<AddItemRequest>(_onAddItem);
    on<UpdateItemRequest>(_onUpdateItem);
    on<DeleteItemRequest>(_onDeleteItem);
  }

  Future<void> _onLoadItemsSubscription(
    LoadItemsSubscription event,
    Emitter<ItemState> emit,
  ) async {
    emit(const ItemLoading());
    await _itemsSubscription?.cancel();
    _itemsSubscription = itemRepository.getItemsStream().listen(
      (items) => add(ItemsUpdated(items)),
      onError: (error) => emit(ItemError(error.toString())),
    );
  }

  void _onItemsUpdated(ItemsUpdated event, Emitter<ItemState> emit) {
    emit(ItemLoaded(event.items));
  }

  Future<void> _onAddItem(
    AddItemRequest event,
    Emitter<ItemState> emit,
  ) async {
    try {
      await itemRepository.addItem(
        title: event.title,
        description: event.description,
        createdBy: event.createdBy,
      );
    } catch (e) {
      emit(ItemError('Failed to add item: $e'));
    }
  }

  Future<void> _onUpdateItem(
    UpdateItemRequest event,
    Emitter<ItemState> emit,
  ) async {
    try {
      await itemRepository.updateItem(
        id: event.id,
        title: event.title,
        description: event.description,
      );
    } catch (e) {
      emit(ItemError('Failed to update item: $e'));
    }
  }

  Future<void> _onDeleteItem(
    DeleteItemRequest event,
    Emitter<ItemState> emit,
  ) async {
    try {
      await itemRepository.deleteItem(event.id);
    } catch (e) {
      emit(ItemError('Failed to delete item: $e'));
    }
  }

  @override
  Future<void> close() {
    _itemsSubscription?.cancel();
    return super.close();
  }
}
```

---

## Step 5: Add Item Dialog for Admin (`lib/features/items/presentation/widgets/add_edit_item_dialog.dart`)

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/item_bloc.dart';
import '../bloc/item_event.dart';
import '../../domain/item_model.dart';

class AddEditItemDialog extends StatefulWidget {
  final ItemModel? itemToEdit;
  final String adminEmail;

  const AddEditItemDialog({
    super.key,
    this.itemToEdit,
    required this.adminEmail,
  });

  @override
  State<AddEditItemDialog> createState() => _AddEditItemDialogState();
}

class _AddEditItemDialogState extends State<AddEditItemDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _descController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.itemToEdit?.title ?? '');
    _descController = TextEditingController(text: widget.itemToEdit?.description ?? '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      final isEditing = widget.itemToEdit != null;

      if (isEditing) {
        context.read<ItemBloc>().add(
              UpdateItemRequest(
                id: widget.itemToEdit!.id,
                title: _titleController.text.trim(),
                description: _descController.text.trim(),
              ),
            );
      } else {
        context.read<ItemBloc>().add(
              AddItemRequest(
                title: _titleController.text.trim(),
                description: _descController.text.trim(),
                createdBy: widget.adminEmail,
              ),
            );
      }
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.itemToEdit != null;

    return AlertDialog(
      title: Text(isEditing ? 'Edit Item' : 'Add New Item'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  hintText: 'Enter item title',
                ),
                validator: (val) =>
                    val == null || val.trim().isEmpty ? 'Title is required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  hintText: 'Enter description',
                ),
                maxLines: 3,
                validator: (val) =>
                    val == null || val.trim().isEmpty ? 'Description is required' : null,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _submit,
          child: Text(isEditing ? 'Save Changes' : 'Add Item'),
        ),
      ],
    );
  }
}
```

---

## Step 6: Update `AdminHomeScreen` (Full CRUD + Add Button)

In `lib/screens/admin_home_screen.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../features/auth/presentation/bloc/auth_bloc.dart';
import '../features/auth/presentation/bloc/auth_event.dart';
import '../features/auth/presentation/bloc/auth_state.dart';
import '../features/items/presentation/bloc/item_bloc.dart';
import '../features/items/presentation/bloc/item_event.dart';
import '../features/items/presentation/bloc/item_state.dart';
import '../features/items/presentation/widgets/add_edit_item_dialog.dart';

class AdminHomeScreen extends StatelessWidget {
  const AdminHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Retrieve logged in admin email
    final authState = context.read<AuthBloc>().state;
    final adminEmail = authState is AuthAuthenticated ? authState.user.email : 'Admin';

    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Dashboard"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: "Logout",
            onPressed: () {
              context.read<AuthBloc>().add(const AuthLogoutRequest());
            },
          ),
        ],
      ),
      body: BlocBuilder<ItemBloc, ItemState>(
        builder: (context, state) {
          if (state is ItemLoading || state is ItemInitial) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ItemError) {
            return Center(
              child: Text(
                'Error: ${state.message}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          if (state is ItemLoaded) {
            if (state.items.isEmpty) {
              return const Center(
                child: Text('No items added yet. Click + to add one!'),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: state.items.length,
              itemBuilder: (context, index) {
                final item = state.items[index];
                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    title: Text(
                      item.title,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text(item.description),
                        const SizedBox(height: 6),
                        Text(
                          'Added by ${item.createdBy}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Edit Item Button
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (_) => AddEditItemDialog(
                                itemToEdit: item,
                                adminEmail: adminEmail,
                              ),
                            );
                          },
                        ),
                        // Delete Item Button
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            context.read<ItemBloc>().add(DeleteItemRequest(item.id));
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }

          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add),
        label: const Text("Add Item"),
        onPressed: () {
          showDialog(
            context: context,
            builder: (_) => AddEditItemDialog(adminEmail: adminEmail),
          );
        },
      ),
    );
  }
}
```

---

## Step 7: Update `UserHomeScreen` (Read-Only Real-Time View)

In `lib/screens/user_home_screen.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../features/auth/presentation/bloc/auth_bloc.dart';
import '../features/auth/presentation/bloc/auth_event.dart';
import '../features/items/presentation/bloc/item_bloc.dart';
import '../features/items/presentation/bloc/item_state.dart';

class UserHomeScreen extends StatelessWidget {
  const UserHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("User Feed"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: "Logout",
            onPressed: () {
              context.read<AuthBloc>().add(const AuthLogoutRequest());
            },
          ),
        ],
      ),
      body: BlocBuilder<ItemBloc, ItemState>(
        builder: (context, state) {
          if (state is ItemLoading || state is ItemInitial) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ItemError) {
            return Center(
              child: Text(
                'Error: ${state.message}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          if (state is ItemLoaded) {
            if (state.items.isEmpty) {
              return const Center(
                child: Text('No announcements or items available yet.'),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: state.items.length,
              itemBuilder: (context, index) {
                final item = state.items[index];
                return Card(
                  elevation: 1,
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          item.description,
                          style: TextStyle(
                            color: Colors.grey.shade800,
                            height: 1.3,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Posted by: ${item.createdBy}',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey.shade500,
                              ),
                            ),
                            Text(
                              '${item.createdAt.day}/${item.createdAt.month}/${item.createdAt.year}',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey.shade500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
```

---

## Step 8: Wire `ItemBloc` in `lib/main.dart`

To provide both `AuthBloc` and `ItemBloc` to the widget tree, use `MultiBlocProvider` in `lib/main.dart`:

```dart
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'firebase_options.dart';
import 'features/auth/data/auth_repo.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/bloc/auth_event.dart';
import 'features/auth/presentation/bloc/auth_state.dart';
import 'features/items/data/item_repository.dart';
import 'features/items/presentation/bloc/item_bloc.dart';
import 'features/items/presentation/bloc/item_event.dart';
import 'features/presentation/login_screen.dart';
import 'screens/admin_home_screen.dart';
import 'screens/user_home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final authRepo = AuthRepository();
  final itemRepo = ItemRepository();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => AuthBloc(authRepo)..add(const AuthCheckRequest()),
        ),
        BlocProvider(
          create: (_) => ItemBloc(itemRepo)..add(const LoadItemsSubscription()),
        ),
      ],
      child: const MyApp(),
    ),
  );
}
```

---

## Summary of Permissions

| Action | Admin | Regular User |
| :--- | :---: | :---: |
| **View items** (Real-time stream) | Yes | Yes |
| **Add item** (Create in Firestore) | Yes | No |
| **Edit item** (Update in Firestore) | Yes | No |
| **Delete item** (Remove from Firestore) | Yes | No |
| **Security enforcement** | Firestore Rules | Firestore Rules |
