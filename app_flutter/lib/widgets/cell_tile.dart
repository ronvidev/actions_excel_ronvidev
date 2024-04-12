import 'package:autocells/models/models.dart';
import 'package:autocells/widgets/widgets.dart';
import 'package:flutter/material.dart';

class CellTile extends StatefulWidget {
  const CellTile({
    super.key,
    required this.textCell,
    this.onDelete,
    this.onChanged,
    this.onEdit,
  });

  final TextSlot textCell;
  final void Function(TextSlot)? onChanged;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  @override
  State<CellTile> createState() => _CellTileState();
}

class _CellTileState extends State<CellTile> {
  final valueController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    valueController.text = widget.textCell.value;

    return Material(
      clipBehavior: Clip.antiAlias,
      color: Theme.of(context).cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
        side: BorderSide(color: Theme.of(context).hintColor.withOpacity(0.2), width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                color: Theme.of(context).primaryColor,
                padding: const EdgeInsets.symmetric(
                  vertical: 4.0,
                  horizontal: 8.0,
                ),
                child: Text(
                  widget.textCell.cell,
                  style: const TextStyle(
                    fontSize: 16.0,
                  ),
                ),
              ),
              const SizedBox(width: 8.0),
              Expanded(
                child: Text(
                  widget.textCell.title,
                  style: const TextStyle(
                      fontSize: 16.0, fontWeight: FontWeight.w500),
                ),
              ),
              if (widget.onEdit != null)
                IconButton(
                  style: const ButtonStyle(
                    shape: MaterialStatePropertyAll(LinearBorder.none),
                  ),
                  icon: const Icon(Icons.edit),
                  onPressed: widget.onEdit,
                ),
              if (widget.onDelete != null)
                IconButton(
                  style: const ButtonStyle(
                    shape: MaterialStatePropertyAll(LinearBorder.none),
                  ),
                  color: Colors.red,
                  icon: const Icon(Icons.close_rounded),
                  onPressed: widget.onDelete,
                ),
            ],
          ),
          const SizedBox(height: 8.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: InputTextBox(
              controller: valueController,
              onChanged: (val) => widget.onChanged?.call(TextSlot(
                title: widget.textCell.title,
                value: val,
                cell: widget.textCell.cell,
              )),
            ),
          ),
        ],
      ),
    );
  }
}
