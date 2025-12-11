import 'dart:io';

import 'package:flutter/material.dart';
import 'package:xwidgets_pack/utils/x_textfield_options.dart';
import 'package:xwidgets_pack/xwidgets.dart';

class ExampleXwidgets extends StatefulWidget {
  const ExampleXwidgets({super.key});

  @override
  State<ExampleXwidgets> createState() => _ExampleXwidgetsState();
}

class _ExampleXwidgetsState extends State<ExampleXwidgets> {
  var isLoadingButtonTitle = false;
  var isLoadingButtonCustom = false;
  var isLoadingShimmerCustom = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: XAppBar(
        title: 'XWidgets',
        backButton: Icon(Icons.logout),
        onTapBack: () => exit(0),
      ),
      body: XCard(
        margin: EdgeInsets.all(16),
        padding: EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: isLoadingShimmerCustom
              ? exampleShimmerList()
              : Column(
            children: [
              XText(
                'X Text Example',
                icon: Icon(Icons.android),
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              XText(
                'Long Text Example Long Text Example Long Text Example Long Text Example Long Text Example Long Text Example',
                iconVerticalAlignment: .start,
                isExpand: true,
                icon: Icon(Icons.android),
                style: TextStyle(fontWeight: FontWeight.normal, fontSize: 18),
              ),
              XSpacer(height: 8),
              XSingleDashedLine(),
              XDiagonalStrikethroughText(
                'DICORET',
                diagonalType: .bottomTop,
                lineColor: Colors.red,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              XDoubleDashedLine(),
              XSpacer(height: 16),
              XButton(
                isLoading: isLoadingButtonTitle,
                onPressed: () async {
                  setState(() => isLoadingButtonTitle = true);
                  await showXButtonActionTitle();
                  setState(() => isLoadingButtonTitle = false);
                },
                label: 'XButton with Title',
              ),
              XSpacer(height: 8),
              XButton(
                height: 56,
                isLoading: isLoadingButtonCustom,
                onPressed: () async {
                  setState(() => isLoadingButtonCustom = true);
                  await showXButtonActionCustom();
                  setState(() => isLoadingButtonCustom = false);
                },
                child: Column(
                  mainAxisAlignment: .center,
                  children: [
                    XText(
                      'On Press',
                      style: TextStyle(fontSize: 11),
                      icon: Icon(Icons.ads_click_rounded),
                    ),
                    Text('XButton Custom View'),
                  ],
                ),
              ),
              XSpacer(height: 8),
              XButton(
                height: 56,
                isLoading: isLoadingShimmerCustom,
                onPressed: () async {
                  setState(() => isLoadingShimmerCustom = true);
                  await Future.delayed(Duration(seconds: 2));
                  setState(() => isLoadingShimmerCustom = false);
                },
                child: Text('XShimmer Loading View'),
              ),
              XSpacer(height: 16),
              XTextField(labelOnLine: 'Nama', hintText: 'Siapa namamu?'),
              XSpacer(height: 8),
              XTextField(
                label: 'Date Picker',
                fieldType: .datepicker,
                suffixIcon: Icon(Icons.calendar_month_outlined),
              ),
              XSpacer(height: 8),
              XTextField(
                labelOnLine: 'Date Time labelOnLine',
                fieldType: .timepicker,
                suffixIcon: Icon(Icons.timelapse_outlined),
              ),
              XSpacer(height: 8),
              XTextField(
                label: 'File Picker',
                isRequired: true,
                fieldType: .file,
              ),
              XSpacer(height: 8),
              XTextField(
                label: 'Date Time labelOnLine',
                dropdownOptions: XTextFieldDropdownOptions(
                  items: ["Sumatera", 'Jawa', 'Kalimantan'],
                  itemAsString: (item) => item,
                ),
                fieldType: .dropdown,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> showXButtonActionTitle() async {
    await Future.delayed(Duration(seconds: 2));
    XSnackbar.info('XButton Pressed', position: .top);
  }

  Future<void> showXButtonActionCustom() async {
    await Future.delayed(Duration(seconds: 2));
    XSnackbar.success('XButton Pressed', position: .bottom);
  }
}

Widget exampleShimmerList() {
  int itemCount = 5;

  return ListView.separated(
    shrinkWrap: true,
    physics: NeverScrollableScrollPhysics(),
    itemCount: itemCount,
    itemBuilder: (context, index) {
      var screenWidth = MediaQuery.of(context).size.width;
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          XSkeleton(width: 80, height: 80),
          XSpacer(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                XSkeleton(height: 16, width: double.infinity),
                XSpacer(height: 8),
                XSkeleton(
                  height: 16,
                  width: screenWidth * 0.5,
                ),
                XSpacer(height: 8),
                XSkeleton(
                  height: 16,
                  width: screenWidth * 0.3,
                ),
              ],
            ),
          ),
        ],
      );
    },
    separatorBuilder: (context, index) => XSpacer(height: 16),
  );
}