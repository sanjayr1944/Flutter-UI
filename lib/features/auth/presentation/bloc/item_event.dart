import 'package:equatable/equatable.dart';

import '../../../domain/item_model.dart';

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