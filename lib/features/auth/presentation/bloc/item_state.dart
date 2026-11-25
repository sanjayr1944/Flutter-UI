import 'package:equatable/equatable.dart';
import '../../../domain/item_model.dart';

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