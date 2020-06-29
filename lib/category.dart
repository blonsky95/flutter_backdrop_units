// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// To keep your imports tidy, follow the ordering guidelines at
// https://www.dartlang.org/guides/language/effective-dart/style#ordering
import 'package:flutter/material.dart';
import 'package:rectangleflutter/unit_converter.dart';
import 'package:rectangleflutter/unit.dart';

/// A custom [Category] widget.
///
/// The widget is composed on an [Icon] and [Text]. Tapping on the widget shows
/// a colored [InkWell] animation.
///
//final _height = 100.0;
//final _padding = 8.0;
//final _radius = BorderRadius.circular(_height / 2);

class Category {
  /// Creates a [Category].
  ///
  /// A [Category] saves the name of the Category (e.g. 'Length'), its color for
  /// the UI, and the icon that represents it (e.g. a ruler).
  final String name;
  final ColorSwatch color;
  final String iconLocation;
  final List<Unit> units;

  const Category({
    @required this.name,
    @required this.color,
    @required this.iconLocation,
    @required this.units,
  })
      : assert(name != null),
        assert(color != null),
        assert(iconLocation != null),
        assert(units != null);

  /// Builds a custom widget that shows [Category] information.
  ///
  /// This information includes the icon, name, and color for the [Category].
//  @override
  // This `context` parameter describes the location of this widget in the
  // widget tree. It can be used for obtaining Theme data from the nearest
  // Theme ancestor in the tree. Below, we obtain the display1 text theme.
  // See https://docs.flutter.io/flutter/material/Theme-class.html
//  Widget build(BuildContext context) {
//    // TODO: Build the custom widget here, referring to the Specs.
//    return Material(
//        color: Colors.transparent,
//        child: Container(
//            height: _height,
////            color: Colors.blue,
//            child: InkWell(
//              borderRadius: _radius,
//              highlightColor: color,
//              splashColor: color,
//              onTap: () {
//                print("Bro, I'm going to $name unit");
//                _navigateToConverter(context);
//              },
//              child: Row(
//                crossAxisAlignment: CrossAxisAlignment.stretch,
//                children: <Widget>[
//                  Padding(
//                    padding: EdgeInsets.all(16.0),
//                    child: Icon(
//                      iconLocation,
//                      size: 60.0,
//                    ),
//                  ),
//                  Center(
//                    child: Text(
//                      name,
//                      textAlign: TextAlign.center,
//                      style: new TextStyle(
//                        fontSize: 26.0,
//                        color: Colors.black87
//                      ),
//
//                    ),
//                  )
//                ],
//              ),
//            )
//        ),
//    );
  }

//  void _navigateToConverter(BuildContext context) {
//    Navigator.of(context).push(MaterialPageRoute<Null>(
//      builder: (BuildContext context) {
//        return Scaffold(
//          appBar: AppBar(
//            elevation: 1.0,
//            title: Text(
//              name,
//              style: Theme.of(context).textTheme.headline4,
//            ),
//            centerTitle: true,
//            backgroundColor: color
//          ),
//          body: UnitConverter(
//            converterColor: color,
//            units: units,
//          ),
//        );
//      }
//    ));
//  }

