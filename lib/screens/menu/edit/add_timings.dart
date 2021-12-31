import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:onehubrestro/controllers/menu/menu-controller.dart';
import 'package:onehubrestro/controllers/navigation/navigation-controller.dart';
import 'package:onehubrestro/models/menu/menu.dart';
import 'package:onehubrestro/shared/components/app_scaffold.dart';
import 'package:onehubrestro/shared/components/snackbar.dart';
import 'package:onehubrestro/utilities/colors.dart';
import 'package:onehubrestro/utilities/test_styles.dart';

class AddTimingScreen extends StatefulWidget {
  AddTimingScreen({this.product});

  final Product product;

  @override
  _AddTimingScreenState createState() => _AddTimingScreenState();
}

class _AddTimingScreenState extends State<AddTimingScreen> {
  int _selectedOption;
  bool _maunualTurnOn = false;
  DateTime date;
  TimeOfDay time;
  DateTime stockTime;

  MenuController menuController = Get.find<MenuController>();

  _AddTimingScreenState() {
    date = DateTime.now();
    int hour = date.hour;
    int minute;
    if (date.minute > 30) {
      hour++;
      minute = 0;
    } else {
      minute = 30;
    }
    date = DateTime(date.year, date.month, date.day, hour, minute);
    time = TimeOfDay(hour: hour, minute: minute);
    _selectedOption = 1;
    stockTime = DateTime.now().add(Duration(hours: 2));
    NavigationController navigationController = Get.find<NavigationController>();
    navigationController.setRoute('/menu');
  }

  final DateFormat dateFormatter = DateFormat('dd MMM, yyyy');

  final DateFormat timeFormatter = DateFormat('hh:mm a');

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return AppContainer(
      route: '/menu',
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
              icon: SvgPicture.asset('lib/assets/icons/arrow_back.svg'),
              onPressed: () {
                Navigator.pop(context);
              }),
          title: Text(
            'Set time to mark out of stock',
            style: AppTextStyle.getPoppinsSemibold().copyWith(fontSize: 18),
          ),
        ),
        backgroundColor: lightGrey,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: Colors.white,
              padding: EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Auto turn-on after',
                      style: AppTextStyle.getPoppinsSemibold()
                          .copyWith(fontSize: 18)),
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: const Text('2 Hours'),
                          leading: Radio(
                            value: 1,
                            groupValue: _selectedOption,
                            onChanged: (int value) {
                              setState(() {
                                _selectedOption = value;
                                stockTime =
                                    DateTime.now().add(Duration(hours: 2));
                              });
                            },
                          ),
                        ),
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: const Text('4 Hours'),
                          leading: Radio(
                            value: 2,
                            groupValue: _selectedOption,
                            onChanged: (int value) {
                              setState(() {
                                _selectedOption = value;
                                stockTime =
                                    DateTime.now().add(Duration(hours: 4));
                              });
                            },
                          ),
                        ),
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: const Text('Next Business Day'),
                          leading: Radio(
                            value: 3,
                            groupValue: _selectedOption,
                            onChanged: (int value) {
                              setState(() {
                                _selectedOption = value;
                                stockTime = DateTime.now().add(Duration(days: 1));
                                stockTime =  DateTime(stockTime.year, stockTime.month, stockTime.day);
                              });
                            },
                          ),
                        ),
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: const Text('Custom Date & Time (upto 7 days)'),
                          leading: Radio(
                            value: 4,
                            groupValue: _selectedOption,
                            onChanged: (int value) {
                              setState(() {
                                _selectedOption = value;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(15),
                    child: Wrap(
                      children: [
                        Container(
                          width: size.width * 0.45,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Date',
                                  style: AppTextStyle.getPoppinsMedium()
                                      .copyWith(color: textGrey)),
                              GestureDetector(
                                onTap: () {
                                  _selectDate(context);
                                },
                                child: Container(
                                  padding: EdgeInsets.all(12),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(dateFormatter.format(date),
                                          style: AppTextStyle.getPoppinsSemibold()
                                              .copyWith(
                                                  color: kSecondaryColor,
                                                  fontSize: 18)),
                                      Icon(
                                        Icons.arrow_drop_down,
                                        color: kSecondaryColor,
                                        size: 30,
                                      )
                                    ],
                                  ),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      border:
                                          Border.all(width: 2, color: textGrey)),
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(width: 10),
                        Container(
                          width: size.width * 0.35,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Time',
                                  style: AppTextStyle.getPoppinsMedium()
                                      .copyWith(color: textGrey)),
                              GestureDetector(
                                onTap: () {
                                  _selectTime(context);
                                },
                                child: Container(
                                  padding: EdgeInsets.all(12),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(timeFormatter.format(date),
                                          style: AppTextStyle.getPoppinsSemibold()
                                              .copyWith(
                                                  color: kSecondaryColor,
                                                  fontSize: 18)),
                                      Icon(
                                        Icons.arrow_drop_down,
                                        color: kSecondaryColor,
                                        size: 30,
                                      )
                                    ],
                                  ),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      border:
                                          Border.all(width: 2, color: textGrey)),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            Container(height: 10),
            Container(
              color: Colors.white,
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Manually Turn On',
                      style: AppTextStyle.getPoppinsSemibold()
                          .copyWith(fontSize: 18)),
                  SizedBox(height: 10),
                  // Row(
                  //   children: [
                  //      Checkbox(
                  //     value: _maunualTurnOn,
                  //     activeColor: kSecondaryColor,
                  //     onChanged: (status) {
                  //     setState(() {
                  //       _maunualTurnOn = status;
                  //     });
                  //   },
                  //   ),
                  //   Text('I will turn it on myself',
                  //       style: AppTextStyle.getLatoRegular()
                  //           .copyWith(color: textGrey))
                  //   ],
                  // )
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('I will turn it on myself'),
                    leading: Radio(
                      value: 5,
                      groupValue: _selectedOption,
                      onChanged: (int value) {
                        setState(() {
                          _selectedOption = value;
                        });
                      },
                    ),
                  ),
                  Text(
                    'This item will not be visible to customers on the 3km app till you switch it on.',
                    style: AppTextStyle.getLatoMedium(),
                  )
                ],
              ),
            ),
            Container(
                width: double.infinity,
                child: ElevatedButton(
                    child: Text('Save',
                        style: AppTextStyle.getPoppinsSemibold()
                            .copyWith(letterSpacing: 1, color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      primary: kSecondaryColor,
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                      shape: StadiumBorder(),
                    ),
                    onPressed: () async {
                      Product request = Product(
                        menuId: widget.product.menuId,
                        isInStock: false
                      );

                      DateFormat dateFormat =
                          DateFormat('EEE MMM dd yyyy hh:mm a');

                      if (_selectedOption < 4) {
                        request.instockTime = dateFormat.format(stockTime);
                      }
                      if (_selectedOption == 4) {
                        request.instockTime = dateFormat.format(date);
                      }

                      if (await menuController.updateProduct(request)) {
                        menuController.listCategories();
                        Navigator.pop(context);
                      } else {
                        String message = menuController.errorMessage.value;

                        AppSnackBar.showErrorSnackBar(
                            message: message, width: size.width);
                      }
                    })),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(Duration(days: 7)));
    if (pickedDate != null)
      setState(() {
        date = pickedDate;
      });
  }

  Future<Null> _selectTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: time,
    );
    if (picked != null)
      setState(() {
        date = DateTime(
            date.year, date.month, date.day, picked.hour, picked.minute);
      });
  }
}
