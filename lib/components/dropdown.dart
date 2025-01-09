import 'package:flutter/material.dart';

class MyDropdown extends StatelessWidget {
  final String hintText;
  final List<String> items;
  final String? value;
  final ValueChanged<String?> onChanged;
  final Icon? prefixIcon;

  const MyDropdown({
    super.key,
    this.hintText = "Select Item",
    required this.items,
    required this.onChanged,
    this.value,
    this.prefixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          Expanded(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                dropdownColor: Colors.white,
                value: value,
                hint: Text(
                  hintText,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 16,
                  ),
                ),
                icon: Icon(
                  Icons.arrow_drop_down,
                  color: Colors.grey.shade600,
                ),
                isExpanded: true,
                items: items.map((String item) {
                  return DropdownMenuItem<String>(
                    value: item,
                    child: Text(
                      item,
                      style: TextStyle(
                        color: Colors.grey.shade800,
                        fontSize: 16,
                      ),
                    ),
                  );
                }).toList(),
                onChanged: onChanged,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
