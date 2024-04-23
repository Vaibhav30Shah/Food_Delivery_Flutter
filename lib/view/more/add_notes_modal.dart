import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/common/color_extension.dart';
import 'package:food_delivery/common_widget/round_button.dart';

class AddNotesModal extends StatefulWidget {
  final Function(String) onSave;

  const AddNotesModal({Key? key, required this.onSave}) : super(key: key);

  @override
  State<AddNotesModal> createState() => _AddNotesModalState();
}

class _AddNotesModalState extends State<AddNotesModal> {
  final _instructionsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Text(
            'Add Delivery Instructions',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16),
          TextField(
            controller: _instructionsController,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: 'Enter your delivery instructions',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 16),
          RoundButton(
            onPressed: () {
              widget.onSave(_instructionsController.text);
              Navigator.pop(context);
            },
            title: 'Save',
          ),
        ],
      ),
    );
  }
}