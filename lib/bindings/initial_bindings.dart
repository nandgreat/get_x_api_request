import 'package:get/get.dart';

import '../data/network/api_client.dart';
import '../data/repositories/PostRepository.dart';

class InitialBindings extends Bindings {

  @override
  void dependencies() {
    Get.put<ApiClient>(ApiClient(), permanent: true);
    Get.lazyPut<PostRepository>(() => PostRepository(Get.find()), fenix: true);
  }
}