import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:vaidraj/models/medical_history_model.dart';
import 'package:vaidraj/services/medical_history/medical_history_service.dart';

class MedicalHistoryProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  late final PagingController<int, Appointments> pagingController;
  MedicalHistoryProvider() {
    pagingController = PagingController(firstPageKey: 1);
  }
  static const _pageSize = 5;

  MedicalHistoryService service = MedicalHistoryService();
  MedicalHistoryListModel? _medicalHistoryModel;
  MedicalHistoryListModel? get medicalHistoryModel => _medicalHistoryModel;
  Future<void> fetchPage(
      {required int pageKey, required BuildContext context}) async {
    try {
      MedicalHistoryListModel? newItems = await getMedicalHistory(
        context: context,
        currentPage: pageKey,
      );
      final isLastPage = ((newItems?.data?.data?.length ?? 0) < _pageSize);
      if (isLastPage) {
        pagingController
            .appendLastPage(newItems?.data?.data?[0].appointments ?? []);
      } else {
        final nextPageKey = pageKey + 1;
        pagingController.appendPage(
            newItems?.data?.data?[0].appointments ?? [], nextPageKey);
      }
    } catch (error) {
      pagingController.error = error;
    }
  }

  Future<MedicalHistoryListModel?> getMedicalHistory(
      {required BuildContext context, required int currentPage}) async {
    _isLoading = true;
    _medicalHistoryModel = await service.getMedicalHistory(
        context: context, currentPage: currentPage);
    if (_medicalHistoryModel?.success == false) {
      return null;
    }
    _isLoading = false;
    notifyListeners();

    return _medicalHistoryModel;
  }
}
