import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_highlighter/flutter_highlighter.dart';
import 'package:flutter_highlighter/themes/atom-one-dark.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:markdown/markdown.dart' as md;

class AiChatBubble extends StatefulWidget {
  final String text;
  final bool isStreaming;
  final bool isMarkdown;
  final Duration typingSpeed;
  final BoxDecoration? decoration;
  final TextStyle? textStyle;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  const AiChatBubble({
    super.key,
    required this.text,
    this.isStreaming = false,
    this.isMarkdown = true,
    this.typingSpeed = const Duration(milliseconds: 30),
    this.decoration,
    this.textStyle,
    this.padding,
    this.margin,
  });

  @override
  State<AiChatBubble> createState() => _AiChatBubbleState();
}

class _AiChatBubbleState extends State<AiChatBubble> {
  String _displayedText = '';
  late int _currentIndex;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    if (widget.isStreaming && widget.isMarkdown) {
      _currentIndex = 0;
      _startStreaming();
    } else {
      _displayedText = widget.text;
    }
  }

  void _startStreaming() {
    _timer?.cancel();
    _timer = Timer.periodic(widget.typingSpeed, (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      if (_currentIndex < widget.text.length) {
        setState(() {
          _currentIndex++;
          _displayedText = widget.text.substring(0, _currentIndex);
        });
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void didUpdateWidget(AiChatBubble oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.text != widget.text) {
      if (widget.isStreaming && widget.isMarkdown) {
        if (_currentIndex > widget.text.length) {
          _currentIndex = widget.text.length;
        }
        _startStreaming();
      } else {
        _displayedText = widget.text;
      }
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: widget.margin ?? const EdgeInsets.symmetric(vertical: 8),
      padding: widget.padding ?? const EdgeInsets.all(16),
      decoration:
          widget.decoration ??
          BoxDecoration(
            color: Colors.blueGrey.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
      child: widget.isMarkdown
          ? MarkdownBody(
              data: widget.isStreaming ? _displayedText : widget.text,
              selectable: true,
              styleSheet: MarkdownStyleSheet(
                p: widget.textStyle,
                listBullet: widget.textStyle,
              ),
              builders: {'code': CodeElementBuilder()},
              extensionSet: md.ExtensionSet.gitHubWeb,
            )
          : (widget.isStreaming
                ? AnimatedTextKit(
                    animatedTexts: [
                      TypewriterAnimatedText(
                        widget.text,
                        speed: widget.typingSpeed,
                        textStyle: widget.textStyle,
                      ),
                    ],
                    isRepeatingAnimation: false,
                    displayFullTextOnTap: true,
                  )
                : SelectableText(widget.text, style: widget.textStyle)),
    );
  }
}

class CodeElementBuilder extends MarkdownElementBuilder {
  @override
  Widget? visitElementAfter(md.Element element, TextStyle? preferredStyle) {
    var language = '';
    bool isBlock = false;

    if (element.attributes['class'] != null) {
      String lg = element.attributes['class'] as String;
      if (lg.startsWith('language-')) {
        language = lg.substring(9);
      }
      isBlock = true;
    } else if (element.textContent.contains('\n')) {
      isBlock = true;
      language = 'plaintext';
    }

    if (!isBlock) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        decoration: BoxDecoration(
          color: Colors.grey.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          element.textContent,
          style:
              preferredStyle?.copyWith(
                fontFamily: 'monospace',
                backgroundColor: Colors.transparent,
              ) ??
              const TextStyle(fontFamily: 'monospace'),
        ),
      );
    }

    final textContent = element.textContent.trimRight();

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF282C34), // atomOneDark background
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: const BoxDecoration(
              color: Color(0xFF1E2227), // darker header
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  language.isEmpty ? 'code' : language,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                _CopyButton(textContent),
              ],
            ),
          ),
          ClipRRect(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(8),
              bottomRight: Radius.circular(8),
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Container(
                padding: const EdgeInsets.all(16),
                child: HighlightView(
                  textContent,
                  language: language.isEmpty ? 'plaintext' : language,
                  theme: atomOneDarkTheme,
                  padding: EdgeInsets.zero,
                  textStyle: const TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CopyButton extends StatefulWidget {
  final String text;
  const _CopyButton(this.text);

  @override
  State<_CopyButton> createState() => _CopyButtonState();
}

class _CopyButtonState extends State<_CopyButton> {
  bool _copied = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        await Clipboard.setData(ClipboardData(text: widget.text));
        setState(() {
          _copied = true;
        });
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            setState(() {
              _copied = false;
            });
          }
        });
      },
      child: Row(
        children: [
          Icon(
            _copied ? Icons.check : Icons.copy,
            size: 14,
            color: _copied ? Colors.green : Colors.white70,
          ),
          const SizedBox(width: 4),
          Text(
            _copied ? 'Copied!' : 'Copy Code',
            style: TextStyle(
              color: _copied ? Colors.green : Colors.white70,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
