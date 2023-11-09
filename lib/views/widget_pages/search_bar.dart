import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todolist1/provider/username_provider.dart.dart';

class AnimatedSearchBar extends StatefulWidget {
  final Function(String) onSearch;
  const AnimatedSearchBar({super.key, required this.onSearch});

  @override
  State<AnimatedSearchBar> createState() => _AnimatedSearchBarState();
}


class _AnimatedSearchBarState extends State<AnimatedSearchBar> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
        final searchProvider1 = Provider.of<SearchProvider>(context, listen: false);
    searchProvider1.controller.addListener(() {
      if (searchProvider1.controller.text.isNotEmpty) {
        widget.onSearch(searchProvider1.controller.text);
      }
    });
  }
  Widget build(BuildContext context) {
 
    final searchProvider = Provider.of<SearchProvider>(context, listen: true);
    return AnimatedContainer(
      curve: Curves.easeIn,
      duration: const Duration(milliseconds: 300),
      width: searchProvider.isSearching ? 290.0 : 48,
      height: 50.0,
      alignment: searchProvider.isSearching
          ? Alignment.centerLeft
          : Alignment.centerRight,
      child: Row(
        children: <Widget>[
          IconButton(
            alignment: Alignment.center,
            icon: Icon(
              searchProvider.isSearching ? Icons.close : Icons.search,
              size: 25,
              color: const Color.fromARGB(255, 255, 255, 255),
            ),
            onPressed: () {
                searchProvider.searching();
            },
          ),
          Expanded(
            child: searchProvider.isSearching
                ? TextField(
                    controller: searchProvider.controller,
                    onChanged: (value) {
                      widget.onSearch(value);
                    },
                    decoration: const InputDecoration(
                      hintText: 'Search...',
                      hintStyle:
                          TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
                      border: InputBorder.none,
                    ),
                    style: const TextStyle(color: Colors.white),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
