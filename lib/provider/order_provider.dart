import 'package:flutter/material.dart';
import 'package:flutter_grocery/data/model/body/place_order_body.dart';
import 'package:flutter_grocery/data/model/body/review_body.dart';
import 'package:flutter_grocery/data/model/response/base/api_response.dart';
import 'package:flutter_grocery/data/model/response/base/error_response.dart';
import 'package:flutter_grocery/data/model/response/order_details_model.dart';
import 'package:flutter_grocery/data/model/response/order_model.dart';
import 'package:flutter_grocery/data/model/response/response_model.dart';
import 'package:flutter_grocery/data/model/response/timeslote_model.dart';
import 'package:flutter_grocery/data/repository/order_repo.dart';
import 'package:flutter_grocery/helper/api_checker.dart';
import 'package:flutter_grocery/data/model/response/delivery_man_model.dart';
import 'package:flutter_grocery/helper/date_converter.dart';

class
OrderProvider extends ChangeNotifier {
  final OrderRepo orderRepo;
  OrderProvider({@required this.orderRepo});

  List<OrderModel> _runningOrderList;
  List<OrderModel> _historyOrderList;
  List<OrderDetailsModel> _orderDetails;
  int _paymentMethodIndex = 0;
  OrderModel _trackModel;
  int _addressIndex = -1;
  bool _isLoading = false;
  bool _showCancelled = false;
  List<TimeSlotModel> _timeSlots;
  List<TimeSlotModel> _allTimeSlots;
  bool _isActiveOrder = true;
  int _branchIndex = 0;
  String _orderType = 'delivery';
  ResponseModel _responseModel;
  DeliveryManModel _deliveryManModel;

  List<TimeSlotModel> get timeSlots => _timeSlots;
  List<TimeSlotModel> get allTimeSlots => _allTimeSlots;
  List<OrderModel> get runningOrderList => _runningOrderList;
  List<OrderModel> get historyOrderList => _historyOrderList;
  List<OrderDetailsModel> get orderDetails => _orderDetails;
  int get paymentMethodIndex => _paymentMethodIndex;
  OrderModel get trackModel => _trackModel;
  int get addressIndex => _addressIndex;
  bool get isLoading => _isLoading;
  bool get showCancelled => _showCancelled;
  bool get isActiveOrder => _isActiveOrder;
  int get branchIndex => _branchIndex;
  String get orderType => _orderType;
  ResponseModel get responseModel => _responseModel;
  DeliveryManModel get deliveryManModel => _deliveryManModel;

  Future<void> getOrderList(BuildContext context) async {
    ApiResponse apiResponse = await orderRepo.getOrderList();
    if (apiResponse.response != null && apiResponse.response.statusCode == 200) {
      _runningOrderList = [];
      _historyOrderList = [];
      apiResponse.response.data.forEach((order) {
        OrderModel orderModel = OrderModel.fromJson(order);
        if (orderModel.orderStatus == 'pending' ||
            orderModel.orderStatus == 'processing' ||
            orderModel.orderStatus == 'out_for_delivery' ||
            orderModel.orderStatus == 'confirmed') {
          _runningOrderList.add(orderModel);
        } else if (orderModel.orderStatus == 'delivered') {
          _historyOrderList.add(orderModel);
        }
      });
    } else {
      ApiChecker.checkApi(context, apiResponse);
    }
    notifyListeners();
  }

  Future<void> initializeTimeSlot(BuildContext context) async {
    ApiResponse apiResponse = await orderRepo.getTimeSlot();
    if (apiResponse.response != null && apiResponse.response.statusCode == 200) {
      _timeSlots = [];
      _allTimeSlots = [];
      apiResponse.response.data.forEach((timeSlot) {

        _timeSlots.add(TimeSlotModel.fromJson(timeSlot));
        _allTimeSlots.add(TimeSlotModel.fromJson(timeSlot));
      });
      validateSlot(_allTimeSlots, 0);
    } else {
      ApiChecker.checkApi(context, apiResponse);
    }
    notifyListeners();
  }

  List<String> getDates(BuildContext context) {
    return orderRepo.getDates(context);
  }

  int _selectDateSlot = 0;
  int _selectTimeSlot = 0;

  int get selectDateSlot => _selectDateSlot;
  int get selectTimeSlot => _selectTimeSlot;

  void updateTimeSlot(int index) {
    _selectTimeSlot = index;
    notifyListeners();
  }

  void updateDateSlot(int index) {
    _selectDateSlot = index;
    if(_allTimeSlots != null) {
      validateSlot(_allTimeSlots, index);
    }
    _selectTimeSlot = index;
    notifyListeners();
  }

  void validateSlot(List<TimeSlotModel> slots, int dateIndex) {
    _timeSlots = [];
    if(dateIndex == 0) {
      DateTime _date = DateTime.now();
      slots.forEach((slot) {
        DateTime _time = DateConverter.stringTimeToDateTime(slot.endTime).subtract(Duration(hours: 1));
        DateTime _dateTime = DateTime(_date.year, _date.month, _date.day, _time.hour, _time.minute, _time.second);
        if (_dateTime.isAfter(DateTime.now())) {
          _timeSlots.add(slot);
        }
      });
    }else {
      _timeSlots.addAll(_allTimeSlots);
    }
  }

  double subTotal = 0;
  double discount = 0;
  double totalPrice=0;

  Future<List<OrderDetailsModel>> getOrderDetails(String orderID, BuildContext context) async {
    _orderDetails = null;
    _isLoading = true;
    _showCancelled = false;
    subTotal = 0;
    discount = 0;
    totalPrice=0;
    notifyListeners();
    ApiResponse apiResponse = await orderRepo.getOrderDetails(orderID);
    _isLoading = false;
    if (apiResponse.response != null && apiResponse.response.statusCode == 200) {
      _orderDetails = [];
      apiResponse.response.data.forEach((orderDetail) => _orderDetails.add(OrderDetailsModel.fromJson(orderDetail)));
      _orderDetails.forEach((element) {
        subTotal += double.parse(element.productDetails.price.toString());
        discount += double.parse(element.productDetails.discount.toString());
        totalPrice += double.parse(element.price.toString());
      });

    } else {
      ApiChecker.checkApi(context, apiResponse);
    }
    notifyListeners();
    return _orderDetails;
  }

  void setPaymentMethod(int index) {
    _paymentMethodIndex = index;
    notifyListeners();
  }

  void changeActiveOrderStatus(bool status) {
    _isActiveOrder = status;
    notifyListeners();
  }

  Future<void> getDeliveryManData(String orderID, BuildContext context) async {
    ApiResponse apiResponse = await orderRepo.getDeliveryManData(orderID);
    if (apiResponse.response != null && apiResponse.response.statusCode == 200) {
      _deliveryManModel = DeliveryManModel.fromJson(apiResponse.response.data);
    } else {
      ApiChecker.checkApi(context, apiResponse);
    }
    notifyListeners();
  }

  Future<ResponseModel> trackOrder(String orderID, OrderModel orderModel, BuildContext context, bool fromTracking) async {
    _trackModel = null;
    ResponseModel _responseModel;
    if(!fromTracking) {
      _orderDetails = null;
    }
    _showCancelled = false;
    if(orderModel == null) {
      _isLoading = true;
      ApiResponse apiResponse = await orderRepo.trackOrder(orderID);
      if (apiResponse.response != null && apiResponse.response.statusCode == 200) {
        _trackModel = OrderModel.fromJson(apiResponse.response.data);
        _responseModel = ResponseModel(true, apiResponse.response.data.toString());
      } else {
        _responseModel = ResponseModel(false, apiResponse.error.errors[0].message);
        ApiChecker.checkApi(context, apiResponse);
      }
      _isLoading = false;
      notifyListeners();
    }else {
      _trackModel = orderModel;
      _responseModel = ResponseModel(true, 'Successful');
    }
    return _responseModel;
  }

  Future<void> placeOrder(PlaceOrderBody placeOrderBody, Function callback) async {
    _isLoading = true;
    notifyListeners();
    print(placeOrderBody.toJson());
    ApiResponse apiResponse = await orderRepo.placeOrder(placeOrderBody);
    _isLoading = false;
    if (apiResponse.response != null && apiResponse.response.statusCode == 200) {
      String message = apiResponse.response.data['message'];
      String orderID = apiResponse.response.data['order_id'].toString();
      callback(true, message, orderID);
      print('-------- Order placed successfully $orderID ----------');
    } else {
      String errorMessage;
      if (apiResponse.error is String) {
        print(apiResponse.error.toString());
        errorMessage = apiResponse.error.toString();
      } else {
        ErrorResponse errorResponse = apiResponse.error;
        print(errorResponse.errors[0].message);
        errorMessage = errorResponse.errors[0].message;
      }
      callback(false, errorMessage, '-1');
    }
    notifyListeners();
  }

  void stopLoader() {
    _isLoading = false;
    notifyListeners();
  }

  void setAddressIndex(int index, {bool notify = true}) {
    _addressIndex = index;
    if (notify) {
      notifyListeners();
    }
  }

  void cancelOrder(String orderID, bool fromOrder, Function callback, ) async {
    _isLoading = true;
    notifyListeners();
    ApiResponse apiResponse = await orderRepo.cancelOrder(orderID);
    _isLoading = false;
    if (apiResponse.response != null && apiResponse.response.statusCode == 200) {
     if(fromOrder){
       OrderModel orderModel;
       _runningOrderList.forEach((order) {
         if (order.id.toString() == orderID) {
           orderModel = order;
         }
       });
       _runningOrderList.remove(orderModel);
     }
      _showCancelled = true;
      callback(apiResponse.response.data['message'], true, orderID);
    } else {
      print(apiResponse.error.errors[0].message);
      callback(apiResponse.error.errors[0].message, false, '-1');
    }
    notifyListeners();
  }

  void setBranchIndex(int index) {
    _branchIndex = index;
    _addressIndex = -1;
    notifyListeners();
  }

  void setOrderType(String type, {bool notify = true}) {
    _orderType = type;
    if(notify) {
      notifyListeners();
    }
  }

  Future<void> updatePaymentMethod(String orderID, bool fromOrder, Function callback, ) async {
    _isLoading = true;
    notifyListeners();
    ApiResponse apiResponse = await orderRepo.updatePaymentMethod(orderID);
    _isLoading = false;
    if (apiResponse.response != null && apiResponse.response.statusCode == 200) {
      if(fromOrder){
        int orderIndex;
        for(int index=0; index<_runningOrderList.length; index++) {
          if(_runningOrderList[index].id.toString() == orderID) {
            orderIndex = index;
            break;
          }
        }
        if(orderIndex != null) {
          _runningOrderList[orderIndex].paymentMethod = 'cash_on_delivery';
        }
      }
      _trackModel.paymentMethod = 'cash_on_delivery';
      callback(apiResponse.response.data['message'], true);
    } else {
      print(apiResponse.error.errors[0].message);
      callback(apiResponse.error.errors[0].message, false);
    }
    notifyListeners();
  }

  List<int> _ratingList = [];
  List<String> _reviewList = [];
  List<bool> _loadingList = [];
  List<bool> _submitList = [];
  int _deliveryManRating = 0;

  List<int> get ratingList => _ratingList;
  List<String> get reviewList => _reviewList;
  List<bool> get loadingList => _loadingList;
  List<bool> get submitList => _submitList;
  int get deliveryManRating => _deliveryManRating;

  void initRatingData(List<OrderDetailsModel> orderDetailsList) {
    _ratingList = [];
    _reviewList = [];
    _loadingList = [];
    _submitList = [];
    _deliveryManRating = 0;
    orderDetailsList.forEach((orderDetails) {
      _ratingList.add(0);
      _reviewList.add('');
      _loadingList.add(false);
      _submitList.add(false);
    });
  }

  void setRating(int index, int rate) {
    _ratingList[index] = rate;
    notifyListeners();
  }

  void setReview(int index, String review) {
    _reviewList[index] = review;
  }

  void setDeliveryManRating(int rate) {
    _deliveryManRating = rate;
    notifyListeners();
  }

  Future<ResponseModel> submitReview(int index, ReviewBody reviewBody) async {
    _loadingList[index] = true;
    notifyListeners();

    ApiResponse response = await orderRepo.submitReview(reviewBody);
    ResponseModel responseModel;
    if (response.response != null && response.response.statusCode == 200) {
      _submitList[index] = true;
      responseModel = ResponseModel(true, 'Review submitted successfully');
      notifyListeners();
    } else {
      String errorMessage;
      if(response.error is String) {
        errorMessage = response.error.toString();
      }else {
        errorMessage = response.error.errors[0].message;
      }
      responseModel = ResponseModel(false, errorMessage);
    }
    _loadingList[index] = false;
    notifyListeners();
    return responseModel;
  }

  Future<ResponseModel> submitDeliveryManReview(ReviewBody reviewBody) async {
    _isLoading = true;
    notifyListeners();
    ApiResponse response = await orderRepo.submitDeliveryManReview(reviewBody);
    ResponseModel responseModel;
    if (response.response != null && response.response.statusCode == 200) {
      _deliveryManRating = 0;
      responseModel = ResponseModel(true, 'Review submitted successfully');
      notifyListeners();
    } else {
      String errorMessage;
      if(response.error is String) {
        errorMessage = response.error.toString();
      }else {
        errorMessage = response.error.errors[0].message;
      }
      responseModel = ResponseModel(false, errorMessage);
    }
    _isLoading = false;
    notifyListeners();
    return responseModel;
  }

}
