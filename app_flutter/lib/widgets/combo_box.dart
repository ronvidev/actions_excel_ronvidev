import 'package:autocells/widgets/widgets.dart';
import 'package:flutter/material.dart';

class ComboBoxItem<T> {
  final T value;
  final String? label;

  ComboBoxItem({
    required this.value,
    this.label,
  });
}

class ComboBox<T> extends StatefulWidget {
  const ComboBox({
    super.key,
    this.controller,
    this.hintText,
    this.initialValue,
    this.onSelected,
    this.width,
    this.suffix,
    required this.items,
  });

  final double? width;
  final String? initialValue;
  final List<ComboBoxItem<T>> items;
  final String? hintText;
  final TextEditingController? controller;
  final void Function(T? item)? onSelected;
  final Widget? suffix;

  @override
  State<ComboBox<T>> createState() => _ComboBoxState<T>();
}

class _ComboBoxState<T> extends State<ComboBox<T>> {
  late TextEditingController _controller;
  final layerLink = LayerLink();
  final _focusNode = FocusNode();
  OverlayEntry? _overlayEntry;
  bool overlayOpened = false;
  bool hoverOverlay = false;

  @override
  void initState() {
    _controller = widget.controller ?? TextEditingController();
    _controller.text = widget.initialValue ?? '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: layerLink,
      child: SizedBox(
        width: widget.width,
        child: InputTextBox(
          focusNode: _focusNode,
          controller: _controller,
          hintText: widget.hintText,
          onChanged: (value) => _showOverlay(),
          onTapOutside: (_) {
            if (!hoverOverlay) {
              final items = widget.items
                  .where((a) => a.label == _controller.text)
                  .toList();

              if (items.isNotEmpty) {
                widget.onSelected!(items[0].value);
              } else {
                _controller.clear();
                widget.onSelected!(null);
              }

              _closeOverlay();
            }
          },
          suffix: MouseRegion(
            onEnter: (_) => setState(() => hoverOverlay = true),
            onExit: (_) => setState(() => hoverOverlay = false),
            child: Row(
              children: [
                if (widget.suffix != null) widget.suffix!,
                ActionButton(
                  borderRadius: BorderRadius.zero,
                  child: Icon(overlayOpened
                      ? Icons.keyboard_arrow_up_rounded
                      : Icons.keyboard_arrow_down_rounded),
                  onPressed: () {
                    !overlayOpened ? _showOverlay() : _closeOverlay();
                    // print(templatesPath);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showOverlay() {
    _closeOverlay();

    FocusScope.of(context).requestFocus(_focusNode);

    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;

    final items = widget.items;
    final indexFounded = items.indexWhere(
        (e) => e.label?.toLowerCase() == _controller.text.toLowerCase());

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        width: size.width,
        child: CompositedTransformFollower(
          link: layerLink,
          showWhenUnlinked: false,
          offset: Offset(0, size.height + 5),
          child: Material(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(8.0),
            clipBehavior: Clip.antiAlias,
            elevation: 1.0,
            child: MouseRegion(
              onEnter: (_) => setState(() => hoverOverlay = true),
              onExit: (_) => setState(() => hoverOverlay = false),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 300.0),
                child: items.isNotEmpty
                    ? ListView.builder(
                        shrinkWrap: true,
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          final itemValue = items[index].value;
                          final itemLabel = items[index].label;
                          return Material(
                            color: index == indexFounded
                                ? Theme.of(context).focusColor
                                : Colors.transparent,
                            child: InkWell(
                              splashFactory: NoSplash.splashFactory,
                              onTap: () {
                                _controller.text = itemLabel ?? '';
                                if (widget.onSelected != null) {
                                  widget.onSelected!(itemValue);
                                }
                                // valText = itemValue.toString();
                                _closeOverlay();
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(items[index].label ?? ''),
                              ),
                            ),
                          );
                        },
                      )
                    : Container(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'No hay coincidencias',
                          style: TextStyle(color: Theme.of(context).hintColor),
                        ),
                      ),
              ),
            ),
          ),
        ),
      ),
    );

    setState(() => overlayOpened = true);
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _closeOverlay() {
    _focusNode.unfocus();
    _overlayEntry?.remove();
    _overlayEntry = null;
    setState(() => overlayOpened = false);
  }
}
