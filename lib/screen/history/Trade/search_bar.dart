import 'package:flutter/material.dart';

class CharacterSearchTextField extends StatefulWidget {
  final Function(String) onSearchTextChanged;
  TextEditingController searchController = TextEditingController();


  CharacterSearchTextField({ this.onSearchTextChanged,this.searchController});

  @override
  _CharacterSearchTextFieldState createState() =>
      _CharacterSearchTextFieldState();
}

class _CharacterSearchTextFieldState extends State<CharacterSearchTextField> {

  @override
  void initState() {
    super.initState();
    widget.searchController.addListener(_onSearchTextChanged);
  }

  @override
  void dispose() {
    widget.searchController.removeListener(_onSearchTextChanged);
    widget.searchController.dispose();
    super.dispose();
  }

  void _onSearchTextChanged() {
    widget.onSearchTextChanged(widget.searchController.text);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 45,
      child: TextField(
        cursorColor: Colors.grey[700],
        controller: widget.searchController,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.only(left: 10,right: 5),
          suffix: Icon(Icons.search,color: Colors.grey[700],),
          focusedBorder:  OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.grey[700]
            ),
              borderRadius: BorderRadius.circular(12)
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
                color: Colors.grey[700]
            ),
          ),
          hintText: 'Search...',
        ),
      ),
    );
  }
}

class MyWidget extends StatefulWidget {
  @override
  _MyWidgetState createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  String _searchText = '';
  List<String> _characterList = [
    'Iron Man',
    'Captain America',
    'Thor',
    'Hulk',
    'Black Widow',
    'Hawkeye',
    'Black Panther',
    'Spider-Man',
    'Doctor Strange',
    'Captain Marvel',
  ];
  List<String> _filteredCharacterList = [];

  @override
  void initState() {
    super.initState();
    _filteredCharacterList = _characterList;
  }

  void _handleSearchTextChanged(String searchText) {
    setState(() {
      _searchText = searchText;
      _filteredCharacterList = _characterList
          .where((character) =>
          character.toLowerCase().contains(searchText.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Character Search'),
      ),
      body: Column(
        children: [
          CharacterSearchTextField(onSearchTextChanged: _handleSearchTextChanged),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredCharacterList.length,
              itemBuilder: (context, index) {
                final character = _filteredCharacterList[index];
                return ListTile(
                  title: Text(character),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
