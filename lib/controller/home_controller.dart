import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_list_player/model/base_client.dart';
import 'package:video_list_player/model/item.dart';
import 'package:video_player/video_player.dart';

class HomeController extends GetxController {
  List<Item> items = [];
  var itemList = [].obs;
  List<VideoPlayerController> videoControllers = [];
  var isLoading = false.obs;
  var cardColors = Colors.green[300].obs;
  int videoIndex = 0;
  var isLoadingMore = false.obs;

  @override
  void onInit() {
    super.onInit();
    getItemList();
  }

  Future<void> getItemList() async {
    isLoading.value = true;

    Future.delayed(const Duration(seconds: 2), () async {
      items = await BaseClient().getItemList;
      itemList.value = items.sublist(0, 2);
      itemList.value.forEach((element) {
        videoControllers
            .add(VideoPlayerController.network(element.videoUrl)..initialize());
      });
    }).then((value) {
      isLoading.value = false;
      playFirstVideo();
    });
  }

  void changeColor(int index) {
    print(index);
    if (videoIndex != index) {
      print('paused $videoIndex');
      videoControllers[videoIndex].pause();
    }
    print('playing $index');
    videoControllers[index].play();
    videoIndex = index;
  }

  Future<void> loadMore(int lastIndex) async {
    isLoadingMore.value = true;
    Future.delayed(const Duration(seconds: 2), () async {
      if (items.length > lastIndex + 2) {
        items.sublist(lastIndex, lastIndex + 2).forEach((element) {
          videoControllers.add(
              VideoPlayerController.network(element.videoUrl)..initialize());
        });
        itemList.value.addAll(items.sublist(lastIndex, lastIndex + 2));
      } else {
        items.sublist(lastIndex, items.length).forEach((element) {
          videoControllers.add(
              VideoPlayerController.network(element.videoUrl)..initialize());
        });
        itemList.value.addAll(items.sublist(lastIndex, items.length));
      }
      itemList.refresh();
    }).then((value) => isLoadingMore.value = false);
  }

  Future<void> playFirstVideo() async {
    videoControllers[0].play();
  }
}
