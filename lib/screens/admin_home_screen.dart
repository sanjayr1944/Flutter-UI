import 'package:firebase_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:firebase_app/features/auth/presentation/bloc/auth_event.dart';
import 'package:firebase_app/features/auth/presentation/bloc/auth_state.dart';
import 'package:firebase_app/features/auth/presentation/bloc/item_bloc.dart';
import 'package:firebase_app/features/auth/presentation/bloc/item_state.dart';
import 'package:firebase_app/features/presentation/item/widgets/edit_add_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../features/auth/presentation/bloc/item_event.dart';

class AdminHomeScreen extends StatelessWidget {
   const AdminHomeScreen({super.key});



  @override
  Widget build(BuildContext context) {
    final authState = context.read<AuthBloc>().state;
    final adminEmail = authState is AuthAuthenticated ? authState.user.email : "Admin";

    return Scaffold(
      appBar: AppBar(
        title: const Text("HI, ADMIN"),
      actions: [
        IconButton(onPressed:()=>
            context.read<AuthBloc>().add(AuthLogoutRequest()),
            icon: Icon(Icons.logout))
      ],),
      body: BlocBuilder<ItemBloc, ItemState>
        (
        builder: (context, state)
        {
          //LOADING STATE
          if(state is ItemLoading || state is ItemInitial)
          {
            return const Center(child: CircularProgressIndicator(),);
          }
          //ERROR STATE
          if(state is ItemError)
          {
            return Center(
              child: Text("ERROR : ${state.message}")
            );
          }
          //EMPTY STATE
          if(state is ItemLoaded)
          {
            if(state.items.isEmpty)
            {
              return Center(
                child: Text("NO ITEM FOUND!"),
              );
            }
            //SUCCESS STATE
            return ListView.builder(
              itemCount: state.items.length,
                itemBuilder:(context,index)
                {
                  final item = state.items[index];
                  return Card
                    (
                    child: ListTile(
                      title: Text(item.title),

                      subtitle:Column(
                        children: [
                          Text(item.description),
                          Text(item.createdBy),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (_) => EditAddItem(
                                  itemEdit: item,
                                  adminEmail: adminEmail,
                                ),
                              );
                            },
                            icon: const Icon(Icons.edit),
                          ),
                          IconButton(
                            onPressed: () {
                              context.read<ItemBloc>().add(DeleteItemRequest(item.id));
                            },
                            icon: const Icon(Icons.delete),
                          ),
                        ],
                      ),
                    ),
                  );
                }
                );
          }
          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: FloatingActionButton.extended
        (
        icon: Icon(Icons.add),
        label: Text("Add Item"),
          onPressed:()
          {
            showDialog(context: context, builder:(_)=> EditAddItem(adminEmail: adminEmail,));
          } ),
    );
  }
}
