import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
//import 'package:connectivity/connectivity.dart';

import '../widgets/products_grid.dart';
import '../widgets/app_drawer.dart';
import '../widgets/badge.dart';
import '../providers/cart.dart';
import '../providers/products.dart';
import '../screens/cart_screen.dart';

enum FilterOptions {
  Favorites,
  All,
}

class ProductsOverviewScreen extends StatefulWidget {
  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  var _showOnlyFavorites = false;
  var _isInit = true;
  var _isLoading = false;

  @override
  void initState() {
    // Provider.of<Products>(context).fetchAndSetProducts(); WON"T WORK DUE TO CONTEXT AND STATE TRUE
    //  Future.delayed(Duration.zero).then((value) => (_){
    //    Provider.of<Products>(context).fetchAndSetProducts();
    //  });
    super.initState();
  }

//  Widget _buildShowDialog(BuildContext context, String title, String text) {
//       showDialog(
//           context: context,
//           builder: (context) => AlertDialog(
//                 title: Text(title),
//                 content: Text(text),
//                 actions: [
//                   FlatButton(
//                     onPressed: () {
//                       Navigator.of(context).pop();
//                     },
//                     child: Text('Ok'),
//                   ),
//                 ],
//               ));
//     }

  
  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });

      Provider.of<Products>(context).fetchAndSetProducts(false)
      .catchError((error){
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('An error occured!'),
            content: Text('Something went wrong.'),
            actions: [
              FlatButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                  child: Text('Okay')),
            ],
          ),
        );
      })
      .then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    //final productsContainer  = Provider.of<Products>(context, listen: false);
    // Widget _checkInternetConnectivity() async {
    // var result = await Connectivity().checkConnectivity();
    // if (result == ConnectivityResult.none) {
    //  return  _buildShowDialog(context, 'No Internet', 'You are not connected to internet');
    //   }
    // }
 
    return Scaffold(
      appBar: AppBar(
        title: Text('My Shop App'),
        actions: [
          PopupMenuButton(
            onSelected: (FilterOptions selectedValue) {
              setState(() {
                if (selectedValue == FilterOptions.Favorites) {
                  //productsContainer.showFavoritesOnly();
                  _showOnlyFavorites = true;
                } else {
                  _showOnlyFavorites = false;
                  //productsContainer.showALL();
                }
              });
            },
            icon: Icon(
              Icons.more_vert,
            ),
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text('Only Favorites'),
                value: FilterOptions.Favorites,
              ),
              PopupMenuItem(
                child: Text('Show All'),
                value: FilterOptions.All,
              ),
            ],
          ),
          Consumer<Cart>(
            builder: (_, cart, ch) => Badge(
              child: ch,
              value: cart.itemCount.toString(),
            ),
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
            ),
          ),
        ],
      ),
      drawer: AppDrawer(),
      body:
      // _checkInternetConnectivity
       _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ProductsGrid(_showOnlyFavorites),
    );
  }
}
