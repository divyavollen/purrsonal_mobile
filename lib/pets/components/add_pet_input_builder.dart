import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddPetInputBuilder extends StatelessWidget {
  const AddPetInputBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }

  static Widget buildTextField({
    required String label,
    required TextEditingController controller,
    String? Function(String?)? validator,
    List<TextInputFormatter>? formatters,
    int maxLength = 30,
  }) {
    return TextFormField(
      controller: controller,
      style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
      decoration: InputDecoration(
        labelText: label,
        counterText: '',
      ),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: validator,
      inputFormatters: formatters,
      maxLength: maxLength,
      textCapitalization: TextCapitalization.sentences,
      keyboardType: TextInputType.text,
      onTapOutside: (PointerDownEvent event) {
        FocusManager.instance.primaryFocus?.unfocus();
      },
    );
  }
}
