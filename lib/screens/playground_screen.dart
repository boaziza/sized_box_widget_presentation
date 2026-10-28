import 'package:flutter/material.dart';

/// Live playground for the three SizedBox constructor properties:
/// [SizedBox.width], [SizedBox.height] and [SizedBox.child].
///
/// Each property can be switched OFF (back to its default, `null`) or
/// changed with a slider, and the preview updates immediately.
class PlaygroundScreen extends StatefulWidget {
  const PlaygroundScreen({super.key});

  @override
  State<PlaygroundScreen> createState() => _PlaygroundScreenState();
}

class _PlaygroundScreenState extends State<PlaygroundScreen> {
  // Slider values. They are only applied when the matching switch is on.
  double _width = 200;
  double _height = 80;

  // Switches. false means "leave the property at its default (null)".
  bool _useWidth = true;
  bool _useHeight = true;
  bool _hasChild = true;

  // Used to read the size the SizedBox actually rendered at.
  final GlobalKey _boxKey = GlobalKey();
  Size? _renderedSize;

  double? get _widthValue => _useWidth ? _width : null;
  double? get _heightValue => _useHeight ? _height : null;

  /// Puts every property back to its default value: width, height and child
  /// all null.
  void _resetToDefaults() {
    setState(() {
      _useWidth = false;
      _useHeight = false;
      _hasChild = false;
    });
  }

  /// After each frame, read the real size of the SizedBox so it can be shown
  /// on screen (useful when width/height are null).
  void _measureAfterFrame() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final size = _boxKey.currentContext?.size;
      if (mounted && size != null && size != _renderedSize) {
        setState(() => _renderedSize = size);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _measureAfterFrame();

    return Scaffold(
      appBar: AppBar(
        title: const Text('SizedBox Playground'),
        actions: [
          TextButton.icon(
            onPressed: _resetToDefaults,
            icon: const Icon(Icons.restart_alt),
            label: const Text('Defaults'),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildPreview(),
          _buildCodeLabel(),
          Expanded(child: _buildControls()),
        ],
      ),
    );
  }

  /// The grey stage with the SizedBox in the middle. The red border is drawn
  /// around the SizedBox, so it shows exactly how big the box is.
  Widget _buildPreview() {
    return Container(
      height: 220,
      width: double.infinity,
      color: Colors.grey.shade200,
      child: Center(
        child: DecoratedBox(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.red, width: 2),
          ),
          // ======== THE WIDGET BEING DEMONSTRATED ========
          child: SizedBox(
            key: _boxKey,
            width: _widthValue, //   default: null
            height: _heightValue, // default: null
            child:
                _hasChild //      default: null
                ? const ColoredBox(
                    color: Color(0xFF8D6E63),
                    child: Padding(
                      padding: EdgeInsets.all(12),
                      child: Text(
                        'Pay \$6.49',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  )
                : null,
          ),
          // ===============================================
        ),
      ),
    );
  }

  /// Shows the SizedBox call as code, plus the size it rendered at.
  Widget _buildCodeLabel() {
    String fmt(double? v) => v == null ? 'null' : v.toStringAsFixed(0);
    final size = _renderedSize;
    final sizeText = size == null
        ? ''
        : '  →  rendered ${size.width.toStringAsFixed(0)} × '
              '${size.height.toStringAsFixed(0)}';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      color: const Color(0xFF263238),
      child: Text(
        'SizedBox(width: ${fmt(_widthValue)}, height: ${fmt(_heightValue)}, '
        'child: ${_hasChild ? 'Text(...)' : 'null'})$sizeText',
        style: const TextStyle(
          fontFamily: 'monospace',
          color: Colors.greenAccent,
          fontSize: 13,
        ),
      ),
    );
  }

  Widget _buildControls() {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 8),
      children: [
        _PropertyControl(
          name: 'width',
          hint: 'null = as wide as the child (0 if no child)',
          enabled: _useWidth,
          value: _width,
          max: 320,
          onToggle: (on) => setState(() => _useWidth = on),
          onChanged: (v) => setState(() => _width = v),
        ),
        _PropertyControl(
          name: 'height',
          hint: 'null = as tall as the child (0 if no child)',
          enabled: _useHeight,
          value: _height,
          max: 200,
          onToggle: (on) => setState(() => _useHeight = on),
          onChanged: (v) => setState(() => _height = v),
        ),
        SwitchListTile(
          title: const Text('child'),
          subtitle: const Text('null = empty box, used as a spacer'),
          value: _hasChild,
          onChanged: (on) => setState(() => _hasChild = on),
        ),
      ],
    );
  }
}

/// A switch (property set / null) plus a slider for one numeric property.
class _PropertyControl extends StatelessWidget {
  const _PropertyControl({
    required this.name,
    required this.hint,
    required this.enabled,
    required this.value,
    required this.max,
    required this.onToggle,
    required this.onChanged,
  });

  final String name;
  final String hint;
  final bool enabled;
  final double value;
  final double max;
  final ValueChanged<bool> onToggle;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SwitchListTile(
          title: Text(
            enabled ? '$name: ${value.toStringAsFixed(0)}' : '$name: null',
          ),
          subtitle: Text(hint),
          value: enabled,
          onChanged: onToggle,
        ),
        Slider(
          value: value,
          max: max,
          divisions: max ~/ 10,
          label: value.toStringAsFixed(0),
          // Disabled slider while the property is null.
          onChanged: enabled ? onChanged : null,
        ),
      ],
    );
  }
}
