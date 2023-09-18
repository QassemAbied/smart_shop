import 'package:flutter/material.dart';
import 'package:new_store_app/inner_screen/detalis_screen.dart';
import 'package:new_store_app/models/product_model.dart';
import 'package:new_store_app/provider/product_provider.dart';
import 'package:new_store_app/provider/recently_provider.dart';
import 'package:new_store_app/screens/search/search_item_widget.dart';
import 'package:new_store_app/widget/text_widget.dart';
import 'package:new_store_app/widget/title_text_widget.dart';
import 'package:provider/provider.dart';
import '../../provider/theme_provider.dart';

class SearchScreen extends StatefulWidget {
  static const routName = '/searchScreen';
  const SearchScreen({super.key});
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchTextController = TextEditingController();

  final FocusNode searchTextFocusNode = FocusNode();

  @override
  void dispose() {
    searchTextController.dispose();
    searchTextFocusNode.dispose();
    super.dispose();
  }

  List<ProductModels> productSearchList = [];
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final productProvider = Provider.of<ProductProvider>(context);
    final viewedProvider = Provider.of<ViewedRecentlyProvider>(context);

    final passedCategory =
        ModalRoute.of(context)!.settings.arguments as String?;
    final List<ProductModels> catList = passedCategory == null
        ? productProvider.getProduct
        : productProvider.getProductByCat(passedCategory);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          title: TitleTextWidget(
            text: passedCategory ?? 'Search',
            color: themeProvider.getDarkTheme ? Colors.white : Colors.black,
          ),
          //title: AppNamedWidget(),

          leading: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
            child:
                Image(image: AssetImage('assets/images/bag/shopping_cart.png')),
          ),
          elevation: 0.0,
        ),
        body: StreamBuilder<Object>(
            stream: productProvider.fetchProductStream(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(
                  child: TextWidget(
                    text: 'your have error',
                    maxLines: 1,
                    sizeText: 18,
                    color: themeProvider.getDarkTheme
                        ? Colors.white38
                        : Colors.grey,
                  ),
                );
              } else if (snapshot.data == null) {
                return Center(
                  child: TextWidget(
                    text: 'no has been data',
                    maxLines: 1,
                    sizeText: 18,
                    color: themeProvider.getDarkTheme
                        ? Colors.white38
                        : Colors.grey,
                  ),
                );
              }
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 10.0),
                  child: Column(
                    children: [
                      TextFormField(
                        keyboardType: TextInputType.text,
                        controller: searchTextController,
                        cursorColor: themeProvider.getDarkTheme
                            ? Colors.white
                            : Colors.black,
                        onFieldSubmitted: (value) {
                          setState(() {
                            productSearchList = productProvider
                                .getProductBySearch(value, catList);
                          });
                        },
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.search,
                            color: themeProvider.getDarkTheme
                                ? Colors.white
                                : Colors.black,
                          ),
                          suffixIcon: IconButton(
                            onPressed: () {
                              searchTextController.clear();
                              FocusScope.of(context).unfocus();
                            },
                            icon: Icon(
                              Icons.clear,
                              color: searchTextFocusNode.hasFocus
                                  ? Colors.red
                                  : themeProvider.getDarkTheme
                                      ? Colors.white
                                      : Colors.black,
                            ),
                          ),
                          label: TextWidget(
                            text: 'Search',
                            maxLines: 1,
                            color: themeProvider.getDarkTheme
                                ? Colors.white
                                : Colors.black,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: themeProvider.getDarkTheme
                                  ? Colors.white
                                  : Colors.black,
                            ),
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: themeProvider.getDarkTheme
                                  ? Colors.white
                                  : Colors.black,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      if (searchTextController.text.isNotEmpty &&
                          productSearchList.isEmpty)
                        ...[],
                      GridView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          physics: const BouncingScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            childAspectRatio: 0.61,
                            mainAxisSpacing: 20,
                            crossAxisSpacing: 10,
                            crossAxisCount: 2,
                          ),
                          itemCount: searchTextController.text.isNotEmpty
                              ? productSearchList.length
                              : catList.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DetailsScreen(
                                      productId: searchTextController
                                              .text.isNotEmpty
                                          ? productSearchList[index].productId
                                          : catList[index].productId,
                                    ),
                                  ),
                                );
                                viewedProvider.addViewedRecently(
                                    proId: catList[index].productId);
                              },
                              child: ChangeNotifierProvider.value(
                                value: catList[index],
                                child: SearchItem(
                                  productId:
                                      searchTextController.text.isNotEmpty
                                          ? productSearchList[index].productId
                                          : catList[index].productId,
                                ),
                              ),
                            );
                          }),
                    ],
                  ),
                ),
              );
            }),
      ),
    );
  }
}
