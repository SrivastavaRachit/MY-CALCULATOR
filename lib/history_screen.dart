import 'package:flutter/material.dart';

class HistoryScreen extends StatefulWidget {
  final List<String> history;
  final Function(List<String>) onHistoryCleared;

  const HistoryScreen({
    super.key,
    required this.history,
    required this.onHistoryCleared,
  });

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final backgroundGradient = isDarkMode
        ? const LinearGradient(colors: [Color(0xFF0D1B2A), Color(0xFF1E2A47)])
        : const LinearGradient(
            colors: [Color(0xFFF9F9F9), Color(0xFFE5E5E5)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          );

    final cardColor = isDarkMode ? const Color(0xFF2E2E2E) : const Color(0xFF4399E3);
    final buttonColor = isDarkMode ? const Color(0xFF3A8DFF) : const Color(0xFFFD0000);
    final appBarColor = isDarkMode ? const Color(0xFF141414) : const Color(0xFFFF0000);
    final textColor = isDarkMode ? Colors.white : Colors.black;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text(
          "History",
          style: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: appBarColor,
        elevation: 10,
        centerTitle: true,
      ),
      body: DecoratedBox(
        decoration: BoxDecoration(gradient: backgroundGradient),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: widget.history.isEmpty
                    ? Center(
                        child: Text(
                          "No History available",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color:
                                  isDarkMode ? Colors.white : Colors.black54),
                        ),
                      )
                    : ListView.builder(
                        itemCount: widget.history.length,
                        itemBuilder: (context, index) {
                          return Dismissible(
                            key: Key(widget.history[index]),
                            direction: DismissDirection.endToStart,
                            background: Container(
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.only(right: 20.0),
                              color: Colors.black26,
                              child: const Icon(
                                Icons.delete,
                                color: Colors.white,
                              ),
                            ),
                            onDismissed: (direction) {
                              setState(() {
                                widget.history.removeAt(index);
                              });
                              widget.onHistoryCleared(widget.history);
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                              margin: const EdgeInsets.only(bottom: 15),
                              decoration: BoxDecoration(
                                color: cardColor,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black26,
                                    offset: Offset(0, 4),
                                    blurRadius: 8,
                                  ),
                                ],
                              ),
                              child: ListTile(
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 16, horizontal: 24),
                                title: Text(
                                  widget.history[index],
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800,
                                    color: textColor,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          backgroundColor: isDarkMode
                              ? const Color(0xFF2C2C2C)
                              : const Color(0xFFFAF9F9),
                          title: Text(
                            "Clear History",
                            style: TextStyle(color: textColor),
                          ),
                          content: Text(
                            "Are you sure you want to clear the history?",
                            style: TextStyle(color: textColor),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text(
                                "Cancel",
                                style: TextStyle(color: Colors.blue),
                              ),
                            ),
                            TextButton(
                              child: const Text(
                                "Clear",
                                style: TextStyle(color: Colors.red),
                              ),
                              onPressed: () {
                                setState(() {
                                  widget.history.clear();
                                });
                                widget.onHistoryCleared(widget.history);
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: buttonColor,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 8),
                  child: const Text(
                    "Clear History",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
