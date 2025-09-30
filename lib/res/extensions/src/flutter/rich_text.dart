/*
 * Copyright 2020 Pawan Kumar. All rights reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * http://www.apache.org/licenses/LICENSE-2.0
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */


import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../extensions.dart'; // Assuming this contains Vx, VxNone, etc.
import 'velocityx_mixins/color_mixin.dart';
import 'velocityx_mixins/render_mixin.dart';

// Abstract base class for widget builders (if not already defined)
abstract class VxWidgetBuilder<T> {
  Widget make({Key? key});
}

// VxRichText class with mixins
class VxRichText with VxColorMixin<VxRichText>, VxRenderMixin<VxRichText> {
  VxRichText(String this._text) {
    setChildToColor(this);
    setChildForRender(this);
  }

  VxRichText.existing(String this._text, this._textStyle) {
    setChildToColor(this);
  }

  String? _text, _fontFamily;
  List<TextSpan>? _textSpanChildren;
  FontWeight? _fontWeight;
  TextAlign? _textAlign;
  double? _scaleFactor,
      _wordSpacing,
      _fontSize,
      _letterSpacing,
      _lineHeight,
      _maxFontSize,
      _stepGranularity,
      _minFontSize;
  int? _maxLines;
  FontStyle? _fontStyle;
  TextDecoration? _decoration;
  GestureRecognizer? _gestureRecognizer;
  TextStyle? _textStyle, _themedStyle;
  StrutStyle? _strutStyle;
  TextOverflow? _overflow;
  TextBaseline? _textBaseline;
  Widget? _replacement;
  bool? _softWrap, _wrapWords;
  bool _isIntrinsic = false;

  /// Set tap function
  VxRichText tap(void Function()? function) {
    final recognizer = TapGestureRecognizer()..onTap = function;
    return this.._gestureRecognizer = recognizer;
  }

  /// Set doubleTap function
  VxRichText doubleTap(void Function()? function) {
    final recognizer = DoubleTapGestureRecognizer()..onDoubleTap = function;
    return this.._gestureRecognizer = recognizer;
  }

  /// Set children with list of text spans
  VxRichText withTextSpanChildren(List<TextSpan> children) {
    _textSpanChildren = children;
    return this;
  }

  /// Set [color] of the text
  VxRichText color(Color color) {
    velocityColor = color;
    return this;
  }

  /// Set [color] of the text using hex value
  VxRichText hexColor(String colorHex) =>
      this..velocityColor = Vx.hexToColor(colorHex);

  /// Use intrinsic width/height (disables AutoSizeText)
  VxRichText get isIntrinsic => this.._isIntrinsic = true;

  /// Set maximum number of lines
  VxRichText maxLines(int lines) {
    _maxLines = lines;
    return this;
  }

  /// Set font family
  VxRichText fontFamily(String family) {
    _fontFamily = family;
    return this;
  }

  /// Use custom or theme text style
  VxRichText textStyle(TextStyle? style) {
    _themedStyle = style;
    return this;
  }

  /// Set minimum font size for auto-sizing
  VxRichText minFontSize(double minFontSize) {
    _minFontSize = minFontSize;
    return this;
  }

  /// Set maximum font size for auto-sizing
  VxRichText maxFontSize(double maxFontSize) {
    _maxFontSize = maxFontSize;
    return this;
  }

  /// Set step granularity for auto-sizing
  VxRichText stepGranularity(double stepGranularity) {
    _stepGranularity = stepGranularity;
    return this;
  }

  /// Set overflow replacement widget
  VxRichText overflowReplacement(Widget overflowReplacement) {
    _replacement = overflowReplacement;
    return this;
  }

  /// Set strut style
  VxRichText strutStyle(StrutStyle? style) {
    _strutStyle = style;
    return this;
  }

  /// Set text alignment
  VxRichText align(TextAlign align) => this.._textAlign = align;

  /// Align text to center
  VxRichText get center => this.._textAlign = TextAlign.center;

  /// Align text to start
  VxRichText get start => this.._textAlign = TextAlign.start;

  /// Align text to end
  VxRichText get end => this.._textAlign = TextAlign.end;

  /// Justify text
  VxRichText get justify => this.._textAlign = TextAlign.justify;

  /// Set overflow to fade
  VxRichText get fade => this.._overflow = TextOverflow.fade;

  /// Set overflow to ellipsis
  VxRichText get ellipsis => this.._overflow = TextOverflow.ellipsis;

  /// Set overflow to visible
  VxRichText get visible => this.._overflow = TextOverflow.visible;

  /// Set font size
  VxRichText size(double size) => this.._fontSize = size;

  /// Theme text styles
  VxRichText displayLarge(BuildContext context) {
    _themedStyle = context.textTheme.displayLarge;
    return this;
  }

  VxRichText displayMedium(BuildContext context) {
    _themedStyle = context.textTheme.displayMedium;
    return this;
  }

  VxRichText displaySmall(BuildContext context) {
    _themedStyle = context.textTheme.displaySmall;
    return this;
  }

  VxRichText headlineLarge(BuildContext context) {
    _themedStyle = context.textTheme.headlineLarge;
    return this;
  }

  VxRichText headlineMedium(BuildContext context) {
    _themedStyle = context.textTheme.headlineMedium;
    return this;
  }

  VxRichText headlineSmall(BuildContext context) {
    _themedStyle = context.textTheme.headlineSmall;
    return this;
  }

  VxRichText titleLarge(BuildContext context) {
    _themedStyle = context.textTheme.titleLarge;
    return this;
  }

  VxRichText titleMedium(BuildContext context) {
    _themedStyle = context.textTheme.titleMedium;
    return this;
  }

  VxRichText titleSmall(BuildContext context) {
    _themedStyle = context.textTheme.titleSmall;
    return this;
  }

  VxRichText bodyLarge(BuildContext context) {
    _themedStyle = context.textTheme.bodyLarge;
    return this;
  }

  VxRichText bodyMedium(BuildContext context) {
    _themedStyle = context.textTheme.bodyMedium;
    return this;
  }

  VxRichText bodySmall(BuildContext context) {
    _themedStyle = context.textTheme.bodySmall;
    return this;
  }

  VxRichText labelLarge(BuildContext context) {
    _themedStyle = context.textTheme.labelLarge;
    return this;
  }

  VxRichText labelMedium(BuildContext context) {
    _themedStyle = context.textTheme.labelMedium;
    return this;
  }

  VxRichText labelSmall(BuildContext context) {
    _themedStyle = context.textTheme.labelSmall;
    return this;
  }

  /// Scale factor shortcuts
  VxRichText get xs => _fontSizedText(child: this, scaleFactor: 0.75);
  VxRichText get sm => _fontSizedText(child: this, scaleFactor: 0.875);
  VxRichText get base => _fontSizedText(child: this, scaleFactor: 1);
  VxRichText get lg => _fontSizedText(child: this, scaleFactor: 1.125);
  VxRichText get xl => _fontSizedText(child: this, scaleFactor: 1.25);
  VxRichText get xl2 => _fontSizedText(child: this, scaleFactor: 1.5);
  VxRichText get xl3 => _fontSizedText(child: this, scaleFactor: 1.875);
  VxRichText get xl4 => _fontSizedText(child: this, scaleFactor: 2.25);
  VxRichText get xl5 => _fontSizedText(child: this, scaleFactor: 3);
  VxRichText get xl6 => _fontSizedText(child: this, scaleFactor: 4);

  VxRichText scale(double value) =>
      _fontSizedText(child: this, scaleFactor: value);

  VxRichText _fontSizedText(
      {required double scaleFactor, required VxRichText child}) {
    _scaleFactor = scaleFactor;
    return this;
  }

  /// Set text baseline
  VxRichText textBaseLine(TextBaseline baseline) {
    _textBaseline = baseline;
    return this;
  }

  /// Set word spacing
  VxRichText wordSpacing(double spacing) {
    _wordSpacing = spacing;
    return this;
  }

  /// Font weight shortcuts
  VxRichText get hairLine =>
      _fontWeightedText(child: this, weight: FontWeight.w100);
  VxRichText get thin =>
      _fontWeightedText(child: this, weight: FontWeight.w200);
  VxRichText get light =>
      _fontWeightedText(child: this, weight: FontWeight.w300);
  VxRichText get normal =>
      _fontWeightedText(child: this, weight: FontWeight.w400);
  VxRichText get medium =>
      _fontWeightedText(child: this, weight: FontWeight.w500);
  VxRichText get semiBold =>
      _fontWeightedText(child: this, weight: FontWeight.w600);
  VxRichText get bold =>
      _fontWeightedText(child: this, weight: FontWeight.w700);
  VxRichText get extraBold =>
      _fontWeightedText(child: this, weight: FontWeight.w800);
  VxRichText get extraBlack =>
      _fontWeightedText(child: this, weight: FontWeight.w900);

  VxRichText _fontWeightedText(
      {required FontWeight weight, required VxRichText child}) {
    _fontWeight = weight;
    return this;
  }

  /// Set italic font style
  VxRichText get italic => this.._fontStyle = FontStyle.italic;

  /// Letter spacing shortcuts
  VxRichText get tightest => this.._letterSpacing = -3.0;
  VxRichText get tighter => this.._letterSpacing = -2.0;
  VxRichText get tight => this.._letterSpacing = -1.0;
  VxRichText get wide => this.._letterSpacing = 1.0;
  VxRichText get wider => this.._letterSpacing = 2.0;
  VxRichText get widest => this.._letterSpacing = 3.0;

  VxRichText letterSpacing(double val) => this.._letterSpacing = val;

  /// Text decoration shortcuts
  VxRichText get underline => this.._decoration = TextDecoration.underline;
  VxRichText get lineThrough => this.._decoration = TextDecoration.lineThrough;
  VxRichText get overline => this.._decoration = TextDecoration.overline;

  /// Text transformation shortcuts
  VxRichText get uppercase => this.._text = _text!.toUpperCase();
  VxRichText get lowercase => this.._text = _text!.toLowerCase();
  VxRichText get capitalize => this.._text = _text!.allWordsCapitilize();
  VxRichText get hidePartial => this.._text = _text!.hidePartial();

  /// Line height shortcuts
  VxRichText get heightTight => this.._lineHeight = 0.75;
  VxRichText get heightSnug => this.._lineHeight = 0.875;
  VxRichText get heightRelaxed => this.._lineHeight = 1.25;
  VxRichText get heightLoose => this.._lineHeight = 1.5;

  VxRichText lineHeight(double val) => this.._lineHeight = val;

  Widget make({Key? key}) {
    if (!willRender) return const VxNone();
    final ts = TextStyle(
      color: velocityColor,
      fontSize: _fontSize,
      fontStyle: _fontStyle,
      fontFamily: _fontFamily,
      fontWeight: _fontWeight,
      letterSpacing: _letterSpacing,
      decoration: _decoration,
      height: _lineHeight,
      textBaseline: _textBaseline ?? TextBaseline.alphabetic,
      wordSpacing: _wordSpacing,
    );
    return _isIntrinsic
        ? Text.rich(
            TextSpan(
              text: _text,
              children: _textSpanChildren,
              recognizer: _gestureRecognizer,
              style: _themedStyle?.merge(ts) ?? _textStyle?.merge(ts) ?? ts,
            ),
            key: key,
            textAlign: _textAlign,
            maxLines: _maxLines,
            textScaler:
                _scaleFactor == null ? null : TextScaler.linear(_scaleFactor!),
            softWrap: _softWrap ?? true,
            overflow: _overflow ?? TextOverflow.clip,
            strutStyle: _strutStyle,
          )
        : AutoSizeText.rich(
            TextSpan(
              text: _text,
              children: _textSpanChildren,
              recognizer: _gestureRecognizer,
              style: _themedStyle?.merge(ts) ?? _textStyle?.merge(ts) ?? ts,
            ),
            key: key,
            textAlign: _textAlign,
            maxLines: _maxLines,
            textScaleFactor: _scaleFactor,
            softWrap: _softWrap ?? true,
            minFontSize: _minFontSize ?? 12,
            maxFontSize: _maxFontSize ?? double.infinity,
            stepGranularity: _stepGranularity ?? 1,
            overflowReplacement: _replacement,
            overflow: _overflow ?? TextOverflow.clip,
            strutStyle: _strutStyle,
            wrapWords: _wrapWords ?? true,
          );
  }
}

// VelocityXTextSpan class with mixin
class VelocityXTextSpan with VxColorMixin<VelocityXTextSpan> {
  VelocityXTextSpan(String this._text) {
    setChildToColor(this);
  }

  String? _text, _fontFamily;
  GestureRecognizer? _gestureRecognizer;
  TextDecoration? _decoration;
  FontWeight? _fontWeight;
  double? _fontSize, _letterSpacing, _lineHeight, _wordSpacing;
  FontStyle? _fontStyle;
  List<TextSpan>? _textSpanChildren;
  TextStyle? _textStyle, _themedStyle;
  TextBaseline? _textBaseline;

  /// Set tap function
  VelocityXTextSpan tap(void Function()? function) {
    final recognizer = TapGestureRecognizer()..onTap = function;
    return this.._gestureRecognizer = recognizer;
  }

  /// Set doubleTap function
  VelocityXTextSpan doubleTap(void Function()? function) {
    final recognizer = DoubleTapGestureRecognizer()..onDoubleTap = function;
    return this.._gestureRecognizer = recognizer;
  }

  /// Set children with list of text spans
  VelocityXTextSpan withChildren(List<TextSpan> children) {
    return this.._textSpanChildren = children;
  }

  /// Set [color] of the text
  VelocityXTextSpan color(Color color) {
    velocityColor = color;
    return this;
  }

  /// Set [color] of the text using hex value
  VelocityXTextSpan hexColor(String colorHex) =>
      this..velocityColor = Vx.hexToColor(colorHex);

  /// Set font family
  VelocityXTextSpan fontFamily(String family) {
    _fontFamily = family;
    return this;
  }

  /// Set text baseline
  VelocityXTextSpan textBaseLine(TextBaseline baseline) {
    _textBaseline = baseline;
    return this;
  }

  /// Set word spacing
  VelocityXTextSpan wordSpacing(double spacing) {
    _wordSpacing = spacing;
    return this;
  }

  /// Use custom or theme text style
  VelocityXTextSpan textStyle(TextStyle style) {
    _themedStyle = style;
    return this;
  }

  /// Theme text styles
  VelocityXTextSpan displayLarge(BuildContext context) {
    _themedStyle = context.textTheme.displayLarge;
    return this;
  }

  VelocityXTextSpan displayMedium(BuildContext context) {
    _themedStyle = context.textTheme.displayMedium;
    return this;
  }

  VelocityXTextSpan displaySmall(BuildContext context) {
    _themedStyle = context.textTheme.displaySmall;
    return this;
  }

  VelocityXTextSpan headlineLarge(BuildContext context) {
    _themedStyle = context.textTheme.headlineLarge;
    return this;
  }

  VelocityXTextSpan headlineMedium(BuildContext context) {
    _themedStyle = context.textTheme.headlineMedium;
    return this;
  }

  VelocityXTextSpan headlineSmall(BuildContext context) {
    _themedStyle = context.textTheme.headlineSmall;
    return this;
  }

  VelocityXTextSpan titleLarge(BuildContext context) {
    _themedStyle = context.textTheme.titleLarge;
    return this;
  }

  VelocityXTextSpan titleMedium(BuildContext context) {
    _themedStyle = context.textTheme.titleMedium;
    return this;
  }

  VelocityXTextSpan titleSmall(BuildContext context) {
    _themedStyle = context.textTheme.titleSmall;
    return this;
  }

  VelocityXTextSpan bodyLarge(BuildContext context) {
    _themedStyle = context.textTheme.bodyLarge;
    return this;
  }

  VelocityXTextSpan bodyMedium(BuildContext context) {
    _themedStyle = context.textTheme.bodyMedium;
    return this;
  }

  VelocityXTextSpan bodySmall(BuildContext context) {
    _themedStyle = context.textTheme.bodySmall;
    return this;
  }

  VelocityXTextSpan labelLarge(BuildContext context) {
    _themedStyle = context.textTheme.labelLarge;
    return this;
  }

  VelocityXTextSpan labelMedium(BuildContext context) {
    _themedStyle = context.textTheme.labelMedium;
    return this;
  }

  VelocityXTextSpan labelSmall(BuildContext context) {
    _themedStyle = context.textTheme.labelSmall;
    return this;
  }

  /// Set font size
  VelocityXTextSpan size(double size) => this.._fontSize = size;

  /// Font weight shortcuts
  VelocityXTextSpan get hairLine =>
      _fontWeightedText(child: this, weight: FontWeight.w100);
  VelocityXTextSpan get thin =>
      _fontWeightedText(child: this, weight: FontWeight.w200);
  VelocityXTextSpan get light =>
      _fontWeightedText(child: this, weight: FontWeight.w300);
  VelocityXTextSpan get normal =>
      _fontWeightedText(child: this, weight: FontWeight.w400);
  VelocityXTextSpan get medium =>
      _fontWeightedText(child: this, weight: FontWeight.w500);
  VelocityXTextSpan get semiBold =>
      _fontWeightedText(child: this, weight: FontWeight.w600);
  VelocityXTextSpan get bold =>
      _fontWeightedText(child: this, weight: FontWeight.w700);
  VelocityXTextSpan get extraBold =>
      _fontWeightedText(child: this, weight: FontWeight.w800);
  VelocityXTextSpan get extraBlack =>
      _fontWeightedText(child: this, weight: FontWeight.w900);

  VelocityXTextSpan _fontWeightedText(
      {required FontWeight weight, required VelocityXTextSpan child}) {
    _fontWeight = weight;
    return this;
  }

  /// Set italic font style
  VelocityXTextSpan get italic => this.._fontStyle = FontStyle.italic;

  /// Letter spacing shortcuts
  VelocityXTextSpan get tightest => this.._letterSpacing = -3.0;
  VelocityXTextSpan get tighter => this.._letterSpacing = -2.0;
  VelocityXTextSpan get tight => this.._letterSpacing = -1.0;
  VelocityXTextSpan get wide => this.._letterSpacing = 1.0;
  VelocityXTextSpan get wider => this.._letterSpacing = 2.0;
  VelocityXTextSpan get widest => this.._letterSpacing = 3.0;

  VelocityXTextSpan letterSpacing(double val) => this.._letterSpacing = val;

  /// Text decoration shortcuts
  VelocityXTextSpan get underline =>
      this.._decoration = TextDecoration.underline;
  VelocityXTextSpan get lineThrough =>
      this.._decoration = TextDecoration.lineThrough;
  VelocityXTextSpan get overline => this.._decoration = TextDecoration.overline;

  /// Text transformation shortcuts
  VelocityXTextSpan get uppercase => this.._text = _text!.toUpperCase();
  VelocityXTextSpan get lowercase => this.._text = _text!.toLowerCase();
  VelocityXTextSpan get capitalize => this.._text = _text!.allWordsCapitilize();
  VelocityXTextSpan get hidePartial => this.._text = _text!.hidePartial();

  /// Line height shortcuts
  VelocityXTextSpan get heightTight => this.._lineHeight = 0.75;
  VelocityXTextSpan get heightSnug => this.._lineHeight = 0.875;
  VelocityXTextSpan get heightRelaxed => this.._lineHeight = 1.25;
  VelocityXTextSpan get heightLoose => this.._lineHeight = 1.5;

  VelocityXTextSpan lineHeight(double val) => this.._lineHeight = val;

  TextSpan make({Key? key}) {
    final ts = TextStyle(
      color: velocityColor,
      fontSize: _fontSize,
      fontStyle: _fontStyle,
      fontFamily: _fontFamily,
      fontWeight: _fontWeight,
      letterSpacing: _letterSpacing,
      decoration: _decoration,
      height: _lineHeight,
      textBaseline: _textBaseline ?? TextBaseline.alphabetic,
      wordSpacing: _wordSpacing,
    );
    return TextSpan(
      text: _text,
      recognizer: _gestureRecognizer,
      children: _textSpanChildren,
      style: _themedStyle?.merge(ts) ?? _textStyle?.merge(ts) ?? ts,
    );
  }
}

extension VelocityXRichTextExtension on RichText {
  VxRichText get richText =>
      VxRichText.existing((text as TextSpan).text!, text.style);
}

extension VelocityXTextSpanExtension on TextSpan {
  VelocityXTextSpan get textSpan => VelocityXTextSpan(text!);
}