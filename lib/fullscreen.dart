import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:wallpaper_manager/wallpaper_manager.dart';



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
      body: Container(
        child: Column(
          children: [
            Expanded(
                child: Container(
              child: Image.network(widget.imageurl),
            )),
            Container(
              child: InkWell(
                onTap: () {
                  // loadMore();
                },
                child: InkWell(
                  onTap: () {
                    setWallpaper();
                  },
                  child: Container(
                    height: 30,
                    width: double.infinity,
                    child: const Center(child: Text('Set Wallpaper')),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
