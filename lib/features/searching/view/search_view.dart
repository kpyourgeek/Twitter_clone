import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_iconic/common/common.dart';
import 'package:the_iconic/features/searching/controller/search_controller.dart';
import 'package:the_iconic/features/searching/widgets/search_tile.dart';
import 'package:the_iconic/theme/theme.dart';

class SearchView extends ConsumerStatefulWidget {
  const SearchView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SearchViewState();
}

class _SearchViewState extends ConsumerState<SearchView> {
  final searchController = TextEditingController();
  bool isShowUsers = false;

  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appBarTextFieldBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(40),
      borderSide: const BorderSide(color: Pallete.searchBarColor),
    );
    return Scaffold(
      appBar: AppBar(
        title: SizedBox(
          height: 50,
          child: TextField(
            controller: searchController,
            onSubmitted: (value) {
              setState(() {
                isShowUsers = true;
              });
            },
            decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(10).copyWith(left: 20),
                fillColor: Pallete.searchBarColor,
                filled: true,
                enabledBorder: appBarTextFieldBorder,
                focusedBorder: appBarTextFieldBorder,
                hintText: 'Search in Twitter'),
          ),
        ),
      ),
      body: isShowUsers
          ? ref.watch(searchUserProvider(searchController.text)).when(
                data: (users) {
                  return ListView.builder(
                      itemCount: users.length,
                      itemBuilder: (context, index) {
                        final user = users[index];
                        return SearchTile(userModel: user);
                      });
                },
                error: (error, st) => ErrorText(error: error.toString()),
                loading: () => const Loader(),
              )
          : const SizedBox(),
    );
  }
}
