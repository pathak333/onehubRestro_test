import 'package:get/state_manager.dart';
import 'package:get/get.dart';
import 'package:onehubrestro/controllers/orders/orders_realtime_controller.dart';
import 'package:onehubrestro/models/api_response.dart';
import 'package:onehubrestro/models/error.dart';
import 'package:onehubrestro/models/profile_response.dart';
import 'package:onehubrestro/models/settlements_response.dart';
import 'package:onehubrestro/models/support_details.dart';
import 'package:onehubrestro/repository/profile.dart';
import 'package:onehubrestro/utilities/dialog_helper.dart';

class ProfileController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isLoaded = false.obs;

  Rx<Profile> profile = Profile().obs;

  Rx<SupportResult> supportDetail = SupportResult().obs;

  RxList<Settlement> settlements = <Settlement>[].obs;


  var errorMessage = ''.obs;

  ProfileRepository profileRepository = Get.put(ProfileRepository());

  @override
  void onInit() async {
    await getProfileData();
    await getSupportDetail();
    super.onInit();
  }

  Profile getProfile() {
    return profile.value;
  }

  void updateProfile(Profile value) {
    profile.value = value;
  }

  void updateSettlements(List<Settlement> value) {
    settlements.value = value;
  }

  Future<bool> getProfileData() async {
    isLoading(true);
    isLoaded(false);

    ProfileResponse profileResponse = await profileRepository.getProfile();
    if (profileResponse.status ==
        APIResponseStatus.success.toString().split('.').last) {
      ProfileData data = profileResponse.data;
      if (data.result.profile != null) {
        updateProfile(data.result.profile);
        isLoading(false);
        isLoaded(true);
        return true;
      }
    } else {
      handleError(profileResponse.data);
    }
    isLoading(false);
    isLoaded(false);
    return false;
  }

  Future<bool> updateProfileData(Profile profile) async {
    DialogHelper.showLoader();
    ProfileResponse profileResponse =
        await profileRepository.updateProfile(profile);
    if(profileResponse == null){
      DialogHelper.hideLoader();
    }
    if (profileResponse.status ==
        APIResponseStatus.success.toString().split('.').last) {
      ProfileData data = profileResponse.data;
      if (data.result != null) {
        updateProfile(data.result.profile);
        DialogHelper.hideLoader();
        return true;
      }
    } else {
      handleError(profileResponse.data);
    }
    DialogHelper.hideLoader();
    return false;
  }

  Future<bool> getSupportDetail() async {
    isLoading(true);
    isLoaded(false);

    SupportDetailsResponse supportDetailsResponse = await profileRepository.getHelpNumbers();
    if (supportDetailsResponse.status ==
        APIResponseStatus.success.toString().split('.').last) {
      SupportData data = supportDetailsResponse.data;
      if (data.result.numbers != null) {
        supportDetail.value = data.result;
        isLoading(false);
        isLoaded(true);
        return true;
      }
    } else {
      handleError(supportDetailsResponse.data);
    }
    isLoading(false);
    isLoaded(false);
    return false;
  }

  Future<bool> getSettlementsList() async {
    isLoading(true);
    isLoaded(false);

    SettlementResponse settlementResponse = await profileRepository.getSettlementsList();
    if (settlementResponse.status ==
        APIResponseStatus.success.toString().split('.').last) {
      SettlementData data = settlementResponse.data;
      if (data.result.settlements != null) {
        updateSettlements(data.result.settlements);
        isLoading(false);
        isLoaded(true);
        return true;
      }
    } else {
      handleError(settlementResponse.data);
    }
    isLoading(false);
    isLoaded(false);
    return false;
  }

  void handleError(ErrorData data) {
    errorMessage.value = data.result.error;
  }
}
