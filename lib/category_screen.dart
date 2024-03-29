import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rectangleflutter/main.dart';
import 'package:rectangleflutter/unit.dart';
import 'package:rectangleflutter/unit_converter.dart';
import 'backdrop.dart';
import 'category.dart';
import 'category_tile.dart';

import 'dart:async';
import 'dart:convert';
import 'api.dart';


final _backgroundColor = Colors.green[100];

class CategoryScreen extends StatefulWidget {
  const CategoryScreen();

  @override
  State<StatefulWidget> createState() => _MyCategoryScreenState();
}

class _MyCategoryScreenState extends State<CategoryScreen> {
  Category _defaultCategory;
  Category _currentCategory;

  final _categories = <Category>[];

  static const _categoryNames = <String>[
    'Length',
    'Area',
    'Volume',
    'Mass',
    'Time',
    'Digital Storage',
    'Energy',
    'Currency',
  ];

  static const _baseColors = <Color>[
    ColorSwatch(0xFF6AB7A8, {
      'highlight': Color(0xFF6AB7A8),
      'splash': Color(0xFF0ABC9B),
    }),
    ColorSwatch(0xFFFFD28E, {
      'highlight': Color(0xFFFFD28E),
      'splash': Color(0xFFFFA41C),
    }),
    ColorSwatch(0xFFFFB7DE, {
      'highlight': Color(0xFFFFB7DE),
      'splash': Color(0xFFF94CBF),
    }),
    ColorSwatch(0xFF8899A8, {
      'highlight': Color(0xFF8899A8),
      'splash': Color(0xFFA9CAE8),
    }),
    ColorSwatch(0xFFEAD37E, {
      'highlight': Color(0xFFEAD37E),
      'splash': Color(0xFFFFE070),
    }),
    ColorSwatch(0xFF81A56F, {
      'highlight': Color(0xFF81A56F),
      'splash': Color(0xFF7CC159),
    }),
    ColorSwatch(0xFFD7C0E2, {
      'highlight': Color(0xFFD7C0E2),
      'splash': Color(0xFFCA90E5),
    }),
    ColorSwatch(0xFFCE9A9A, {
      'highlight': Color(0xFFCE9A9A),
      'splash': Color(0xFFF94D56),
      'error': Color(0xFF912D2D),
    }),
  ];

  static const _icons = <String>[
    'assets/icons/length.png',
    'assets/icons/area.png',
    'assets/icons/volume.png',
    'assets/icons/mass.png',
    'assets/icons/time.png',
    'assets/icons/digital_storage.png',
    'assets/icons/power.png',
    'assets/icons/currency.png',
  ];

//  static const _categoryIcons = <IconData>[];

  @override
  Future<void> didChangeDependencies() async {
    super.didChangeDependencies();
    // We have static unit conversions located in our
    // assets/data/regular_units.json
    if (_categories.isEmpty) {
      await _retrieveLocalCategories();
      await _retrieveApiCategory();
    }
  }

  Future<void> _retrieveLocalCategories() async {
    // Consider omitting the types for local variables. For more details on Effective
    // Dart Usage, see https://www.dartlang.org/guides/language/effective-dart/usage
    final json = DefaultAssetBundle
        .of(context)
        .loadString('assets/data/regular_units.json');
    final data = JsonDecoder().convert(await json);
    print("data size: ${data}");

    if (data is! Map) {
      throw ('Data retrieved from API is not a Map');
    }
    var categoryIndex = 0;
    data.keys.forEach((key) {
      final List<Unit> units =
      data[key].map<Unit>((dynamic data) => Unit.fromJson(data)).toList();
      print("key name: ${units[categoryIndex].name} and value unit: ${units[categoryIndex].conversion}");
      var category = Category(
        name: key,
        units: units,
        color: _baseColors[categoryIndex],
        iconLocation: _icons[categoryIndex],
      );
      setState(() {
        if (categoryIndex == 0) {
          _defaultCategory = category;
        }
        _categories.add(category);
      });
      categoryIndex += 1;
    });
  }

  /// Retrieves a [Category] and its [Unit]s from an API on the web
  Future<void> _retrieveApiCategory() async {
    // Add a placeholder while we fetch the Currency category using the API
    setState(() {
      _categories.add(Category(
        name: apiCategory['name'],
        units: [],
        color: _baseColors.last,
        iconLocation: _icons.last,
      ));
    });
    final api = Api();
    final jsonUnits = await api.getUnits(apiCategory['route']);
    // If the API errors out or we have no internet connection, this category
    // remains in placeholder mode (disabled)
    if (jsonUnits != null) {
      final units = <Unit>[];
      for (var unit in jsonUnits) {
        units.add(Unit.fromJson(unit));
      }
      setState(() {
        _categories.removeLast();
        _categories.add(Category(
          name: apiCategory['name'],
          units: units,
          color: _baseColors.last,
          iconLocation: _icons.last,
        ));
      });
    }
  }

//  @override
//  void initState() {
//    print("Init STATE");
//
//    super.initState();
//    for (var i = 0; i < _categoryNames.length; i++) {
//      var category = Category(
//        name: _categoryNames[i],
//        color: _baseColors[i],
//        iconLocation: Icons.cake,
//        units: _retrieveUnitList(_categoryNames[i]),
//      );
//      if (i == 0) {
//        _defaultCategory = category;
//      }
//      _categories.add(category);
//    }
//  }

//  List<Unit> _retrieveUnitList(String categoryName) {
//    return List.generate(10, (int i) {
//      i += 1;
//      return Unit(
//        name: '$categoryName Unit $i',
//        conversion: i.toDouble(),
//      );
//    });
//  }

  Widget _buildCategoryWidgets() {
    return ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          return CategoryTile(
            category: _categories[index],
            onTap: _onCategoryTap,
          );
        },
        itemCount: _categories.length);
  }

  void _onCategoryTap(Category category) {
    setState(() {
      _currentCategory=category;
    });
  }



  @override
  Widget build(BuildContext context) {
    final listView = Padding(
        padding: EdgeInsets.only(left: 8.0,
          right: 8.0,
          bottom: 48.0,),
        child: _buildCategoryWidgets());

    return Backdrop(
      currentCategory: _currentCategory == null ? _defaultCategory : _currentCategory,
      frontPanel: _currentCategory == null ? UnitConverter(_defaultCategory) :UnitConverter(_currentCategory),
      backPanel: listView,
      frontTitle: Text("Unit Converter"),
      backTitle: Text("Select a category"),
    );

//    final appBar = AppBar(
//      elevation: 0.0,
//      title: Text(
//        "Unit Converter",
//        style: TextStyle(color: Colors.black87, fontSize: 30.0),
//      ),
//      centerTitle: true,
//      backgroundColor: _backgroundColor,
//    );
//
//    return Scaffold(
//      appBar: appBar,
//      body: listView,
//    );
  }
}
