import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_wallpaper_app/widget/appBar.dart';
import 'package:wallpaper_manager/wallpaper_manager.dart';
import 'package:google_fonts/google_fonts.dart';


class FullScreen extends StatefulWidget {
  final String imageurl;
  const FullScreen({Key? key, required this.imageurl}) : super(key: key);

  @override
  _FullScreenState createState() => _FullScreenState();
}

class _FullScreenState extends State<FullScreen> {
  Future<void> setWallpaper() async {
    int location = WallpaperManager.HOME_SCREEN;
    var file = await DefaultCacheManager().getSingleFile(widget.imageurl);
    final String result =
        await WallpaperManager.setWallpaperFromFile(file.path, location);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppBarWidget(),
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              alignment: Alignment.topCenter,
              // height: MediaQuery.of(context).size.height*0.80,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(widget.imageurl,fit: BoxFit.cover,)),
              ),
            ),
            Container(

              child: InkWell(
                onTap: () {
                  setWallpaper();
                },
                child: const Center(child: Text('Set Wallpaper',style: TextStyle(fontSize: 25,color: Colors.pink),),
              ),
            )),
          ],
        ),
      ),
    );
  }
}
