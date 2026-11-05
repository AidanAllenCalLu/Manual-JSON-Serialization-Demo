
import 'package:flutter/material.dart';

class ResultCard extends StatelessWidget {
  final String result;
  final String jsonOutput;
  final bool hasError;

  const ResultCard({
    super.key,
    required this.result,
    required this.jsonOutput,
    required this.hasError,
  });

  @override
  Widget build(BuildContext context) {
    if (result.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          hasError ? 'Error Result' : 'User Information',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 12),

        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: hasError
                ? Colors.red.shade50
                : Colors.green.shade50,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            result,
            style: TextStyle(
              color: hasError
                  ? Colors.red.shade900
                  : Colors.green.shade900,
            ),
          ),
        ),

        if (!hasError) ...[
          const SizedBox(height: 20),

          const Text(
            'Converted JSON:',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(12),
            ),
            child: SelectableText(jsonOutput),
          ),
        ],
      ],
    );
  }
}
