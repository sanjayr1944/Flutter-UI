import 'package:firebase_app/features/auth/presentation/bloc/auth_bloc.dart';
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
        title: const Text("HI, ADMIN"),),
      body: BlocBuilder<ItemBloc, ItemState>
        (
        builder: (context, state)
        {
          if(state is ItemLoading || state is ItemInitial)
          {
            return const Center(child: CircularProgressIndicator(),);
          }
          if(state is ItemError)
          {
            return Center(
              child: Text("ERROR : ${state.message}")
            );
          }
          if(state is ItemLoaded)
          {
            if(state.items.isEmpty)
            {
              return Center(
                child: Text("NO ITEM FOUND!"),
              );
            }
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
                        children: [
                          IconButton(onPressed: ()
                          {
                            showDialog(context: context, builder: (_)=>
                                EditAddItem(itemEdit: item,
                                  adminEmail: adminEmail,));
                          }, icon: Icon(Icons.edit),
                          ),
                          IconButton(onPressed: ()
                          {
                            context.read<ItemBloc>().add(DeleteItemRequest(item.id));
                          }, icon: Icon(Icons.delete),
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
    );
  }
}
