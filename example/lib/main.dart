import 'package:flutter/material.dart';
import 'package:ai_chat_ui_pro/ai_chat_ui_pro.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AI Chat Bubble Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const ChatExampleScreen(),
    );
  }
}

class ChatExampleScreen extends StatefulWidget {
  const ChatExampleScreen({super.key});

  @override
  State<ChatExampleScreen> createState() => _ChatExampleScreenState();
}

class _ChatExampleScreenState extends State<ChatExampleScreen> {
  final String dummyResponse = '''
Hello! I am an AI assistant. I can help you with writing code.

Here is an example of a simple Dart function:
```dart
void sayHello({
  String name = 'Shahzain Baloch',
  String organization = 'BalochCodes',
}) {
  print('Hello, \$name from \$organization!');
}
```

And here is a table:

| Feature | Supported |
|---------|-----------|
| Markdown | Yes |
| Code Highlighting | Yes |
| Streaming | Yes |

Let me know if you need any more help!
''';

  bool _isStreaming = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Chat Bubble Example'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                _isStreaming = true;
              });
            },
            tooltip: 'Replay Stream',
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          AiChatBubble(
            key: ValueKey(
              _isStreaming ? DateTime.now().millisecondsSinceEpoch : 0,
            ),
            text: dummyResponse,
            isStreaming: _isStreaming,
            isMarkdown: true,
            typingSpeed: const Duration(milliseconds: 20),
          ),
        ],
      ),
    );
  }
}
