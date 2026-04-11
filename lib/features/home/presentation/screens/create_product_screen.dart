import 'package:flutter/material.dart';
import 'package:sun_gate_app/features/home/presentation/widgets/create_product_text_field.dart';

class CreateProductScreen extends StatelessWidget {
  const CreateProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Product's Details"),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        children: [
          const CreateProductTextField(
            label: 'Product Name',
            hintText: 'Portal Solar Power System',
          ),
          const SizedBox(height: 16),
          const CreateProductTextField(
            label: "Email's owner",
            hintText: 'Enter Your Email',
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 16),
          const CreateProductTextField(
            label: "phone's owner",
            hintText: 'Enter your phone number',
            keyboardType: TextInputType.phone,
            suffixIcon: Icon(Icons.call_outlined),
          ),
          const SizedBox(height: 16),
          const CreateProductTextField(
            label: 'Description',
            hintText: 'Enter your description',
            maxLines: 3,
          ),
          const SizedBox(height: 16),
          const CreateProductTextField(
            label: 'How it Works',
            hintText: 'Enter how its works',
            maxLines: 3,
          ),
          const SizedBox(height: 16),
          const CreateProductTextField(
            label: 'Product Price',
            hintText: 'Enter Your Price',
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 28),
          SizedBox(
            height: 54,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Text('Save'),
            ),
          ),
        ],
      ),
    );
  }
}