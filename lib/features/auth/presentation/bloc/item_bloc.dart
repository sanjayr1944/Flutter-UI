import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/item_repo.dart';
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