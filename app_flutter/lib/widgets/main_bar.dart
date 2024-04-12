import 'package:flutter/material.dart';

class MainBar extends StatefulWidget {
  const MainBar({
    super.key,
    this.title,
    this.leading,
    this.actions,
    this.child,
  });

  final String? title;
  final Widget? leading;
  final List<Widget>? actions;
  final Widget? child;

  @override
  State<MainBar> createState() => _MainBarState();
}

class _MainBarState extends State<MainBar> {
  bool _configIsOpened = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: Theme.of(context).appBarTheme.backgroundColor,
          padding: const EdgeInsets.symmetric(
            vertical: 12.0,
            horizontal: 8.0,
          ),
          child: Row(
            children: [
              if (widget.leading != null)
                Padding(
                  padding: const EdgeInsets.only(right: 12.0),
                  child: widget.leading,
                ),
              Expanded(
                child: Text(
                  widget.title ?? '',
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 18.0,
                  ),
                ),
              ),
              ...?widget.actions,
              if (widget.child != null)
                IconButton(
                  onPressed: () => setState(() {
                    _configIsOpened = !_configIsOpened;
                    // insertImageProvider.loadData();
                  }),
                  icon: Icon(
                    _configIsOpened
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                  ),
                ),
            ],
          ),
        ),
        AnimatedContainer(
          color: Theme.of(context).primaryColor,
          duration: Durations.medium2,
          curve: Curves.easeOutQuart,
          width: double.infinity,
          height: _configIsOpened ? 160.0 : 0.0,
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            child: widget.child,
          ),
        ),
      ],
    );
  }
}
