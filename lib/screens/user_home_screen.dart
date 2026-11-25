import 'package:firebase_app/features/auth/presentation/bloc/item_bloc.dart';
import 'package:firebase_app/features/auth/presentation/bloc/item_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../features/auth/presentation/bloc/auth_bloc.dart';
import '../features/auth/presentation/bloc/auth_event.dart';

class UserHomeScreen extends StatelessWidget {
  const UserHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("HI, USER"),
        actions: [
          IconButton(onPressed: ()
          {
            context.read<AuthBloc>().add(const AuthLogoutRequest());
          }, icon: Icon(Icons.logout))
        ],
      ),
      body:
        BlocBuilder<ItemBloc,ItemState>(
          builder: (context,state)
          {
      //LOADING,
            if(state is ItemLoading || state is ItemInitial)
            {
              return const Center(child: CircularProgressIndicator(),);
            }
      //ERROR
            if(state is ItemError)
            {
              return Center(child: Text("ERROR: ${state.message}"),);
            }
      //EMPTY
            if(state is ItemLoaded) //Is the contents loaded successfully
            {
              if(state.items.isEmpty)
              {
                return Center(child: Text("Item not added yet!"),
                );
              }
              //SUCCESS

              return ListView.builder
                (

                  itemCount: state.items.length,

                  itemBuilder: (context,index)
                  {
                    final item = state.items[index];

                    return Card(
                      child: Column(
                        children: [
                          Text(item.title),
                          Text(item.description),
                          Row(
                            children: [
                              Text("Posted By : ${item.createdBy}"),
                              Text("${item.createdAt.day}/${item.createdAt.month}/${item.createdAt.year}")
                            ],
                          )
                        ],
                      )
                    );
                  }
                  );
            }
            return const SizedBox.shrink();
          },
        )
    );
  }
}
