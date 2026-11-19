import 'package:firebase_app/features/auth/presentation/bloc/item_bloc.dart';
import 'package:firebase_app/features/auth/presentation/bloc/item_event.dart';
import 'package:firebase_app/features/domain/item_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditAddItem extends StatefulWidget {
  const EditAddItem({
    super.key,
    required this.itemEdit,
    required this.adminEmail,
  });
  final ItemModel itemEdit;
  final String adminEmail;

  @override
  State<EditAddItem> createState() => _EditAddItemState();
}

class _EditAddItemState extends State<EditAddItem> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _titleController.text = widget.itemEdit.title;
    _descriptionController.text = widget.itemEdit.description;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  late final isEditing =
      widget.itemEdit !=
      null; //if there is no item added isEditing will be false

  void _submitItem() {
    if (_formKey.currentState?.validate() ?? false) {
      if (isEditing) {
        context.read<ItemBloc>().add(
          UpdateItemRequest(
            id: widget.itemEdit.id,
            title: _titleController.text.trim(),
            description: _descriptionController.text.trim(),
          ),
        );
      } else {
        context.read<ItemBloc>().add(
          AddItemRequest(
            title: _titleController.text.trim(),
            description: _descriptionController.text.trim(),
            createdBy: widget.adminEmail,
          ),
        );
      }
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(isEditing ? "Edit Item" : "Add Item"),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(hintText: "Title"),
                validator: (value) => value == null || value.trim().isEmpty
                    ? "Title Required"
                    : null,
              ),
              TextFormField(
                decoration: InputDecoration(hintText: "Description"),
                controller: _descriptionController,
                validator: (value) => value == null || value.trim().isEmpty
                    ? "Description is required"
                    : null,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: _submitItem,
          child: Text(isEditing ? "Update" : "Add"),
        ),

      ],
    );
  }
}
