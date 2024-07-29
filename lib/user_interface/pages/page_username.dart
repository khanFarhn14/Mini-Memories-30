import 'package:flutter/material.dart';

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
                )
              ),
              const SizedBox(height: 48,),

              ElevatedButton(
                onPressed: (){},
                child: Text("Submit", style: Theme.of(context).textTheme.labelMedium,)
              )
            ],
          ),
        ),
      ),
    );
  }
}