import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../theme/room_design_system.dart';

class ExpandableSettingsPanel extends StatefulWidget {
  final Widget title;
  final List<Widget> children;
  final bool canEdit;
  final bool initiallyExpanded;

  const ExpandableSettingsPanel({
    super.key,
    required this.title,
    required this.children,
    this.canEdit = false,
    this.initiallyExpanded = false,
  });

  @override
  State<ExpandableSettingsPanel> createState() => _ExpandableSettingsPanelState();
}

class _ExpandableSettingsPanelState extends State<ExpandableSettingsPanel>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _expandAnimation;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.initiallyExpanded;
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    
    if (_isExpanded) {
      _controller.value = 1.0;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: RoomDesignSystem.settingsPanelDecoration(AppTheme.surfaceColor),
      child: Column(
        children: [
          InkWell(
            onTap: _handleTap,
            borderRadius: BorderRadius.vertical(top: Radius.circular(RoomDesignSystem.radiusMedium)),
            child: Padding(
              padding: const EdgeInsets.all(RoomDesignSystem.cardPadding),
              child: Row(
                children: [
                  Expanded(child: widget.title),
                  if (widget.canEdit)
                    Icon(
                      Icons.edit,
                      size: 16,
                      color: AppTheme.secondaryColor,
                    ),
                  const SizedBox(width: 8),
                  AnimatedRotation(
                    turns: _isExpanded ? 0.5 : 0.0,
                    duration: const Duration(milliseconds: 300),
                    child: Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizeTransition(
            sizeFactor: _expandAnimation,
            child: Column(
              children: [
                const Divider(
                  height: 1,
                  color: Colors.white24,
                  indent: 16,
                  endIndent: 16,
                ),
                Padding(
                  padding: const EdgeInsets.all(RoomDesignSystem.cardPadding),
                  child: Column(
                    children: widget.children,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SettingRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool canEdit;
  final VoidCallback? onTap;

  const SettingRow({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.canEdit = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: canEdit ? onTap : null,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: RoomDesignSystem.spacingSm, 
          horizontal: RoomDesignSystem.spacingMd
        ),
        decoration: BoxDecoration(
          color: canEdit 
              ? AppTheme.primaryColor.withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(RoomDesignSystem.radiusSmall),
          border: canEdit 
              ? Border.all(color: AppTheme.primaryColor.withValues(alpha: 0.3))
              : null,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: AppTheme.primaryColor,
              size: 20,
            ),
            const SizedBox(width: RoomDesignSystem.spacingMd),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                  fontFamily: 'Caudex',
                ),
              ),
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: canEdit ? AppTheme.secondaryColor : Colors.white70,
                fontFamily: 'Caudex',
              ),
            ),
            if (canEdit) ...[
              const SizedBox(width: RoomDesignSystem.spacingSm),
              Icon(
                Icons.edit,
                size: 16,
                color: AppTheme.secondaryColor,
              ),
            ],
          ],
        ),
      ),
    );
  }
}