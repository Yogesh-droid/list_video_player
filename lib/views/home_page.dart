import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_list_player/controller/home_controller.dart';
import 'package:video_player/video_player.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final HomeController controller = Get.put(HomeController());
  final ScrollController _scrollController = ScrollController();
  int visibleIndex = -1;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(scrollListenerWithItemHeight);
  }

  void scrollListenerWithItemHeight() {
    int itemHeight = 420; // including padding above and below the list item
    double scrollOffset = _scrollController.offset + 300;
    int firstVisibleItemIndex = scrollOffset < itemHeight
        ? 0
        : ((scrollOffset - itemHeight) / itemHeight).ceil();
    //print(firstVisibleItemIndex + 1);
    getVideoPlayer(firstVisibleItemIndex);
  }

  // use this if total item count is known
  // void scrollListenerWithItemCount() {
  //   int itemCount = 100;
  //   double scrollOffset = scrollController.position.pixels;
  //   double viewportHeight = scrollController.position.viewportDimension;
  //   double scrollRange = scrollController.position.maxScrollExtent -
  //       scrollController.position.minScrollExtent;
  //   int firstVisibleItemIndex =
  //       (scrollOffset / (scrollRange + viewportHeight) * itemCount).floor();
  //   print(firstVisibleItemIndex);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Home'),
        ),
        body: Column(
          children: [
            Expanded(
              child: Obx(() {
                return controller.isLoading.value
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : NotificationListener(
                        onNotification: (t) {
                          if (t is ScrollEndNotification) {
                            //print(_scrollController.position.pixels);
                            if (_scrollController.position.pixels ==
                                _scrollController.position.maxScrollExtent) {
                              print('end of list');
                              controller.loadMore(visibleIndex);
                            }
                            if (_scrollController.position.pixels == 0) {
                              print('top');
                            }
                          }
                          return true;
                        },
                        child: Container(
                          height: 500,
                          child: Padding(
                            padding: const EdgeInsets.all(0.0),
                            child: ListView.builder(
                                shrinkWrap: true,
                                controller: _scrollController,
                                itemCount: controller.itemList.length,
                                itemBuilder: (context, index) {
                                  return getItemBuilder(
                                      context,
                                      index,
                                      controller.itemList[index],
                                      controller.itemList[index].coverImgUrl);
                                }),
                          ),
                        ),
                      );
              }),
            ),
            Obx(() => controller.isLoadingMore.value
                ? Container(
                    height: 50,
                    child: const Center(child: CircularProgressIndicator()),
                  )
                : Container())
          ],
        ));
  }

  Widget getLoader() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget getItemBuilder(BuildContext context, int index, item, coverImgUrl) {
    return Column(
      children: [
        const SizedBox(
          height: 0,
        ),
        Container(
          height: 400,
          child: ListTile(
            title: VideoPlayer(controller.videoControllers[index]),
            //Text(item.title),
            onTap: () {
              controller.videoControllers[index].pause();
            },
          ),
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }

  void getVideoPlayer(int i) {
    if (i != visibleIndex) {
      controller.changeColor(i);
    }
    visibleIndex = i;
  }
}

/* import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(
        'https://tech-assignments.yellowclass.com/1618/hls_class/class_video.m3u8')
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _controller.value.isInitialized
            ? AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              )
            : Container(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _controller.setVolume(100.0);
            _controller.value.isPlaying
                ? _controller.pause()
                : _controller.play();
          });
        },
        child: Icon(
          _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
} */
