import 'package:flutter/material.dart';

/// Widget menu item với icon, label, và chevron cho điều hướng
class AccountMenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color iconColor;
  final bool showDivider;
  final bool isDanger;

  const AccountMenuItem({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.iconColor = const Color(0xFF667EEA),
    this.showDivider = true,
    this.isDanger = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDanger 
        ? Colors.redAccent 
        : (isDark ? Colors.white : Colors.black87);
    final chevronColor = isDark ? const Color.fromRGBO(255, 255, 255, 0.3) : const Color.fromRGBO(0, 0, 0, 0.3);
    final dividerColor = isDark ? const Color.fromRGBO(255, 255, 255, 0.08) : const Color.fromRGBO(0, 0, 0, 0.08);

    return Column(
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(12),
            splashColor: const Color.fromRGBO(102, 126, 234, 0.15),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 4),
              child: Row(
                children: [
                  // Icon container
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: (isDanger ? Colors.red : iconColor)
                          .withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      icon,
                      color: isDanger ? Colors.redAccent : iconColor,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 14),
                  // Label
                  Expanded(
                    child: Text(
                      label,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: textColor,
                      ),
                    ),
                  ),
                  // Chevron
                  if (!isDanger)
                    Icon(
                      Icons.chevron_right,
                      color: chevronColor,
                      size: 22,
                    ),
                ],
              ),
            ),
          ),
        ),
        if (showDivider)
          Divider(
            color: dividerColor,
            height: 1,
          ),
      ],
    );
  }
}
