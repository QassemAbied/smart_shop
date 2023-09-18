import 'package:flutter/material.dart';
import 'package:new_store_app/inner_screen/viewed_recently/viewed_iem.dart';
import 'package:provider/provider.dart';
import '../../provider/recently_provider.dart';
import '../../provider/theme_provider.dart';
import '../../screens/empty_screen.dart';
import '../../widget/title_text_widget.dart';

class ViewedRecentlyScreen extends StatelessWidget {
  const ViewedRecentlyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final viewedProvider= Provider.of<ViewedRecentlyProvider>(context);

    return viewedProvider.getViewedItem.isEmpty?EmptyForScreen(
      image: 'assets/images/empty_search.png',
      title: 'Whoops!',
      subTitle: 'Your History is Empty',
      lastTitle: 'look like you have added no anything to you History ',
      bottomTitle: 'Shop Now',
      onPressed: (){}, textAppBar: 'History',
    ):Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: TitleTextWidget(
          text:  'ViewedRecently (${viewedProvider.getViewedItem.length})',
          color: themeProvider.getDarkTheme
              ? Colors.white
              : Colors.black,
        ),

        leading: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 5,vertical: 2),
          child: Image(image: AssetImage('assets/images/bag/shopping_cart.png')),
        ),
        elevation: 0.0,
        actions: [
          IconButton(
              onPressed: (){
                viewedProvider.removeAllViewedRecently();
              },
              icon: const Icon(Icons.delete , color: Colors.red,)
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Column(
            children: [
              ListView.separated(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                physics: const BouncingScrollPhysics(),
                itemCount: viewedProvider.getViewedItem.length,
                  itemBuilder: (context , index){

                     return ChangeNotifierProvider.value(
                        value: viewedProvider.getViewedItem.values.toList()[index],
                        child: const ViewedRecentlyItem());
                  },
                separatorBuilder: (BuildContext context, int index) {
                    return Divider(
                      height: 26,
                      thickness: 2,
                      color: themeProvider.getDarkTheme? Colors.white:Colors.black,);
                },),
            ],
          ),
        ),
      ),
    );
  }
}
