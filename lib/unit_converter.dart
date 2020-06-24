import 'package:flutter/material.dart';
import 'package:rectangleflutter/category.dart';
import 'package:rectangleflutter/unit.dart';

const _padding = EdgeInsets.all(16.0);

class UnitConverter extends StatefulWidget {
//  final ColorSwatch converterColor;
//  final List<Unit> units;

final Category category;

  const UnitConverter(
    this.category,
  )
      : assert(category != null);

  @override
  State<StatefulWidget> createState() => _MyConverterScreenState();
}

class _MyConverterScreenState extends State<UnitConverter> {
  bool _showValidationError = false;

  Unit _fromValue;
  Unit _toValue;

  String _convertedValue = "";
  List<DropdownMenuItem> _unitMenuItems;

  double _inputValue;

  @override
  void initState() {
    super.initState();
    _createDropdownMenuItems();
    _setDefaultValues();
  }

  @override
  void didUpdateWidget(UnitConverter old) {
    super.didUpdateWidget(old);
    // We update our [DropdownMenuItem] units when we switch [Categories].
    if (old.category != widget.category) {
      _createDropdownMenuItems();
      _setDefaultValues();
    }
  }

  void _setDefaultValues() {
    setState(() {
      _fromValue=widget.category.units[0];
      _toValue=widget.category.units[1];
    });
  }

  /// Clean up conversion; trim trailing zeros, e.g. 5.500 -> 5.5, 10.0 -> 10
  String _format(double conversion) {
    var outputNum = conversion.toStringAsPrecision(7);
    if (outputNum.contains('.') && outputNum.endsWith('0')) {
      var i = outputNum.length - 1;
      while (outputNum[i] == '0') {
        i -= 1;
      }
      outputNum = outputNum.substring(0, i + 1);
    }
    if (outputNum.endsWith('.')) {
      return outputNum.substring(0, outputNum.length - 1);
    }
    return outputNum;
  }

  void _updateConversion() {
    setState(() {
      _convertedValue =
          _format(_inputValue * (_toValue.conversion / _fromValue.conversion));
    });
  }

  void _updateInputValue(String input) {
    setState(() {
      if (input == null || input.isEmpty) {
        _convertedValue = '';
      } else {
        // Even though we are using the numerical keyboard, we still have to check
        // for non-numerical input such as '5..0' or '6 -3'
        try {
          final inputDouble = double.parse(input);
          _showValidationError = false;
          _inputValue = inputDouble;
          _updateConversion();
        } on Exception catch (e) {
          print('Error: $e');
          _showValidationError = true;
        }
      }
    });
  }

  Unit _getUnit(String unitName) {
    return widget.category.units.firstWhere(
          (Unit unit) {
        return unit.name == unitName;
      },
      orElse: null,
    );
  }

  //basically this updates the currently active values, and gets their respective Units.
  //they call set state to rebuild everything with the variable change.
  void _updateFromConversion(dynamic unitName) {
    setState(() {
      _fromValue = _getUnit(unitName);
    });
    if (_inputValue != null) {
      _updateConversion();
    }
  }

  void _updateToConversion(dynamic unitName) {
    setState(() {
      _toValue = _getUnit(unitName);
    });
    if (_inputValue != null) {
      _updateConversion();
    }
  }

  void _createDropdownMenuItems() {
    var newItems = <DropdownMenuItem>[];
    for (var unit in widget.category.units) {
      newItems.add(DropdownMenuItem(
        value: unit.name,
        child: Container(
          child: Text(
            unit.name,
            softWrap: true,
          ),
        ),
      ));
    }

    setState(() {
      _unitMenuItems = newItems;
      print("unit menu items set to ${_unitMenuItems.length}");
    });
  }

  Widget _createDropdown(String currentValue, ValueChanged<dynamic> onChangedAction) {
    return Container(
        margin: EdgeInsets.only(top: 16.0),
        decoration: BoxDecoration(
            color: Colors.grey[50],
            border: Border.all(color: Colors.grey[400], width: 1.0)),
        padding: EdgeInsets.symmetric(vertical: 8.0),
        child: Theme(
          data: Theme.of(context).copyWith(canvasColor: Colors.grey[50]),
          child: DropdownButtonHideUnderline(
            child: ButtonTheme(
              alignedDropdown: true,
              child: DropdownButton(
                value: currentValue,
                items: _unitMenuItems,
                onChanged:onChangedAction,
                style: Theme
                    .of(context)
                    .textTheme
                    .headline6,
              ),
            ),
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    //so you from the state changer class you can access variables of the "parent" class by calling widget

    final input = Padding(
      padding: _padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          TextField(
            style: Theme
                .of(context)
                .textTheme
                .headline4,
            decoration: InputDecoration(
                labelText: "Input",
                labelStyle: Theme
                    .of(context)
                    .textTheme
                    .headline4,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(0.0)),
                errorText:
                _showValidationError ? "Invalid number entered" : null),
            keyboardType: TextInputType.number,
            onChanged: _updateInputValue,
          ),
          _createDropdown(_fromValue.name, _updateFromConversion)
        ],
      ),
    );

    final arrows = RotatedBox(
      quarterTurns: 1,
      child: Icon(
        Icons.compare_arrows,
        size: 40.0,
      ),
    );

    final output = Padding(
      padding: _padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          InputDecorator(
            child: Text(
              _convertedValue,
              style: Theme
                  .of(context)
                  .textTheme
                  .headline4,
            ),
            decoration: InputDecoration(
                labelText: "Output",
                labelStyle: Theme
                    .of(context)
                    .textTheme
                    .headline4,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(0.0))),
          ),
          _createDropdown(_toValue.name, _updateToConversion)
        ],
      ),
    );

    final converter = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[input, arrows, output],
    );

    return Padding(
      padding: _padding,
      child: converter,
    );
  }

}
