import 'package:flutter/material.dart';
import 'package:new_store_app/screens/home/product_home_widget.dart';
import 'package:new_store_app/screens/home/swiper_widget.dart';
import 'package:new_store_app/screens/search/search_screen.dart';
import 'package:new_store_app/widget/title_text_widget.dart';
import 'package:provider/provider.dart';
import '../../provider/product_provider.dart';
import '../../provider/theme_provider.dart';
import 'category_grid_view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  List<Map<String, dynamic>> categoryGrid = [
    {
      'image': 'assets/images/categories/watch.png',
      'title': 'Watch',
    },
    {
      'image': 'assets/images/categories/shoes.png',
      'title': 'Shoes',
    },
    {
      'image': 'assets/images/categories/mobiles.png',
      'title': 'Mobiles',
    },
    {
      'image': 'assets/images/categories/pc.png',
      'title': 'pc',
    },
    {
      'image': 'assets/images/categories/fashion.png',
      'title': 'Fashion',
    },
    {
      'image': 'assets/images/categories/electronics.png',
      'title': 'Elec',
    },
    {
      'image': 'assets/images/categories/cosmetics.png',
      'title': 'Cosmetics',
    },
    {
      'image': 'assets/images/categories/book_img.png',
      'title': 'Book',
    },
  ];

  @override
  Widget build(BuildContext context) {
    super.build(context);
    Size size = MediaQuery.of(context).size;
    final themeProvider = Provider.of<ThemeProvider>(context);
    final productProvider = Provider.of<ProductProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: TitleTextWidget(
          text: 'Home',
          color: themeProvider.getDarkTheme ? Colors.white : Colors.black,
        ),
        leading: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
          child:
              Image(image: AssetImage('assets/images/bag/shopping_cart.png')),
        ),
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
                width: double.infinity,
                height: size.height * 0.3,
                child: const SwiperWidget()),
            const SizedBox(
              height: 20,
            ),
            Visibility(
              visible: productProvider.getProduct.isNotEmpty,
              child: TitleTextWidget(
                text: 'Latest Arrival',
                color: themeProvider.getDarkTheme ? Colors.white : Colors.black,
                fontSize: 23,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Visibility(
              visible: productProvider.getProduct.isNotEmpty,
              child: SizedBox(
                width: double.infinity,
                height: size.height * 0.22,
                child: ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemCount: productProvider.getProduct.length,
                  itemBuilder: (context, index) {
                    return ChangeNotifierProvider.value(
                      value: productProvider.getProduct[index],
                      child: ProductHomeWidget(
                        productId: productProvider.getProduct[index].productId,
                      ),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return const SizedBox(
                      height: 10,
                    );
                  },
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            TitleTextWidget(
              text: 'Categories',
              color: themeProvider.getDarkTheme ? Colors.white : Colors.black,
              fontSize: 23,
            ),
            const SizedBox(
              height: 20,
            ),
            GridView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                physics: const BouncingScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio: 0.66,
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 10,
                  crossAxisCount: 5,
                ),
                itemCount: categoryGrid.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        SearchScreen.routName,
                        arguments: '${categoryGrid[index]['title']}',
                      );
                    },
                    child: CategoryGridView(
                      image: '${categoryGrid[index]['image']}',
                      title: '${categoryGrid[index]['title']}',
                    ),
                  );
                }),
          ],
        ),
      ),
    );
  }
}

// SizedBox(
// width: double.infinity,
// height:size.height *0.3 ,
// child: Row(
// mainAxisAlignment: MainAxisAlignment.start,
// children: [
// Image(
// image: AssetImage('assets/images/129.png'),
// fit: BoxFit.cover,
// height:  110,
// width: size.width *0.05,
// ),
// SizedBox(
// width: 10,
// ),
// Column(
// crossAxisAlignment: CrossAxisAlignment.start,
// children: [
// TextWidget(
// text: 'iphne 12 pro max (12GB) - Balk',
// maxLines: 2,
// fontWeight: FontWeight.w500,
// sizeText: 18,
// color: themeProvider.getDarkTheme
// ? Colors.white
//     : Colors.black,
// ) ,
// SizedBox(
// height: 10,
// ),
// Row(
// children: [
// Expanded(
// child: IconButton(
// onPressed: (){},
// icon: Icon(Icons.favorite_border),
// ),
// ),
// Expanded(
// child: IconButton(
// onPressed: (){},
// icon: Icon(Icons.add_shopping_cart),
// ),
// ),
// ],
// ),
// SizedBox(
// height: 10,
// ),
// TextWidget(
// text: '245644',
// maxLines: 1,
// sizeText: 18,
// color: themeProvider.getDarkTheme
// ? Colors.white38
//     : Colors.grey,
// ),
// ],
// ),
//
// ],
// ),
// ),
