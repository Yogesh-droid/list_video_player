import 'package:video_list_player/model/item.dart';
import 'package:video_list_player/model/repo.dart';

class BaseClient {
  Future<List<Item>> get getItemList async {
    List<Item> itemList = [];
    for (var element in data) {
      itemList.add(Item.fromJson(element));
    }

    return itemList;
  }
}
