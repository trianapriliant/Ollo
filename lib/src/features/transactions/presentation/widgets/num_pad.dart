import 'package:flutter/material.dart';
import '../../../../constants/app_colors.dart';
import '../../../../constants/app_text_styles.dart';

class NumPad extends StatelessWidget {
  final Function(String) onNumberTap;
  final VoidCallback onBackspaceTap;
  final VoidCallback onDoneTap;
  final DateTime selectedDate;
  final VoidCallback onDateTap;

  const NumPad({
    super.key,
    required this.onNumberTap,
    required this.onBackspaceTap,
    required this.onDoneTap,
    required this.selectedDate,
    required this.onDateTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Numbers Grid (3x4)
          Expanded(
            flex: 3,
            child: Column(
              children: [
                _buildNumberRow('1', '2', '3'),
                const SizedBox(height: 8),
                _buildNumberRow('4', '5', '6'),
                const SizedBox(height: 8),
                _buildNumberRow('7', '8', '9'),
                const SizedBox(height: 8),
                _buildNumberRow('.', '0', '000'),
              ],
            ),
          ),
          const SizedBox(width: 8),
          // Actions Column (1x2)
          Expanded(
            flex: 1,
            child: Column(
              children: [
                _buildActionButton(
                  icon: Icons.backspace_outlined,
                  onTap: onBackspaceTap,
                  color: Colors.red[50],
                  iconColor: Colors.red,
                  height: 55, // Match number button height
                ),
                const SizedBox(height: 8),
                // Date Button
                _buildDateButton(
                  date: selectedDate,
                  onTap: onDateTap,
                  height: (55 * 3 + 16 - 8) / 2, // Half of the remaining space
                ),
                const SizedBox(height: 8),
                // Done Button
                _buildDoneButton(
                  height: (55 * 3 + 16 - 8) / 2, // Half of the remaining space
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNumberRow(String n1, String n2, String n3) {
    return Row(
      children: [
        _buildNumberButton(n1),
        const SizedBox(width: 8),
        _buildNumberButton(n2),
        const SizedBox(width: 8),
        _buildNumberButton(n3),
      ],
    );
  }

  Widget _buildNumberButton(String text) {
    return Expanded(
      child: InkWell(
        onTap: () => onNumberTap(text),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          height: 55,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.02),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: Text(
            text,
            style: AppTextStyles.h2.copyWith(fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton({required IconData icon, required VoidCallback onTap, Color? color, Color? iconColor, required double height}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        height: height,
        width: double.infinity,
        decoration: BoxDecoration(
          color: color ?? Colors.grey[100],
          borderRadius: BorderRadius.circular(16),
        ),
        alignment: Alignment.center,
        child: Icon(icon, color: iconColor ?? Colors.black87),
      ),
    );
  }

  Widget _buildDateButton({required DateTime date, required VoidCallback onTap, required double height}) {
    // Format: "Nov 30"
    //          "10:30"
    final month = _getMonthName(date.month);
    final day = date.day.toString();
    final time = "${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}";

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        height: height,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.orange[50],
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "$month $day",
              style: AppTextStyles.bodySmall.copyWith(
                color: Colors.grey[800],
                fontWeight: FontWeight.bold,
                height: 1.0,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              time,
              style: AppTextStyles.h3.copyWith(
                height: 1.0,
                fontSize: 18,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDoneButton({required double height}) {
    return InkWell(
      onTap: onDoneTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        height: height,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(16),
        ),
        alignment: Alignment.center,
        child: const Icon(Icons.check, color: Colors.white, size: 28),
      ),
    );
  }

  String _getMonthName(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month - 1];
  }
}
