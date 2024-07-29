import 'package:flutter/material.dart';
import 'package:mini_memories_30/user_interface/routes/route_name.dart';

class PageUsername extends StatefulWidget {
  const PageUsername({super.key});

  @override
  State<PageUsername> createState() => _PageUsernameState();
}

class _PageUsernameState extends State<PageUsername> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _usernameController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _usernameController.dispose();
  }

  void _confirmSubmission() {
    if (_formKey.currentState!.validate()) {
      // Perform username validation and submission logic here
      // Reset the form
      _usernameController.clear();
      _formKey.currentState?.reset();

      Navigator.popAndPushNamed(context, RouteName.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 52, horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Mini-Memories-30", style: Theme.of(context).textTheme.headlineMedium,),
              const SizedBox(height: 24),

              Text(
                "Enter a username",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              
              const SizedBox(height: 12,),

              Form(
                key: _formKey,
                child: TextFormField(
                  controller: _usernameController,
                  style: Theme.of(context).textTheme.bodyLarge,

                  // validation
                  validator: (value){
                    if(value == null || value.isEmpty){
                      return 'username cannot be empty';
                    }
                    return null;
                  },
                )
              ),
              const SizedBox(height: 48,),

              ElevatedButton(
                onPressed: (){
                  _confirmSubmission();
                },
                child: Text("Submit", style: Theme.of(context).textTheme.labelMedium,)
              )
            ],
          ),
        ),
      ),
    );
  }
}