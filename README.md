# AI Chat UI Pro

A powerful and highly customizable Flutter package for building professional AI chat interfaces. `ai_chat_ui_pro` provides a complete, drop-in solution to display AI responses with beautiful Markdown rendering, syntax-highlighted code blocks, a "Copy Code" button, and a smooth typewriter streaming effect.

## Features

* **Typewriter Effect:** Stream text seamlessly character-by-character just like ChatGPT.
* **Markdown Rendering:** Fully supports bold text, italics, lists, and tables.
* **Syntax Highlighting:** Automatically detects code blocks and highlights syntax (Atom One Dark theme included).
* **Copy to Clipboard:** Interactive "Copy Code" button on code blocks for easy extraction.
* **Customizable:** Easily modify bubble decorations, padding, margins, and text styles.

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  ai_chat_ui_pro: ^0.0.1
```

Then run:

```bash
flutter pub get
```

## Usage

Import the package and use the `AiChatBubble` widget:

```dart
import 'package:ai_chat_ui_pro/ai_chat_ui_pro.dart';
import 'package:flutter/material.dart';

class MyChatScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: AiChatBubble(
          text: 'Hello! Here is some code:\\n```dart\\nprint("Hello World!");\\n```',
          isStreaming: true, // Enables the typewriter effect
          isMarkdown: true,  // Enables markdown parsing and syntax highlighting
          typingSpeed: const Duration(milliseconds: 30),
        ),
      ),
    );
  }
}
```

## Demo

Check out the `example/` folder for a fully working demonstration of the package.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
Copyright (c) 2026 BalochCodes.
