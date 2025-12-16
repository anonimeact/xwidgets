import 'dart:io';

import 'package:flutter/material.dart';
import 'package:xwidgets_pack/models/x_snackbar_config.dart';
import 'package:xwidgets_pack/utils/x_form_validators.dart';
import 'package:xwidgets_pack/utils/x_textfield_options.dart';
import 'package:xwidgets_pack/widgets/shimmer/x_shimmer.dart';
import 'package:xwidgets_pack/widgets/shimmer/x_shimmer_child.dart';
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

  final _formKey = GlobalKey<FormState>();

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
          child: Column(
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
              XShimmer(
                isLoading: isLoadingShimmerCustom,
                shimmerChild: Column(
                  children: [
                    XShimmerChild(width: 100, height: 45),
                    XSpacer(height: 10),
                    XShimmerChild(width: 100, height: 45),
                  ],
                ),
                child: Container(
                  width: 100,
                  height: 100,
                  alignment: .center,
                  child: Text('HelloWord'),
                ),
              ),
              XSpacer(height: 16),
              XButton(
                height: 56,
                widthInfinity: true,
                isLoading: isLoadingShimmerCustom,
                onPressed: () async {
                  setState(() => isLoadingShimmerCustom = true);
                  await Future.delayed(Duration(seconds: 2));
                  setState(() => isLoadingShimmerCustom = false);
                },
                child: Text('XShimmer Loading View'),
              ),
              XSpacer(height: 16),
              Form(
                key: _formKey,
                child: XTextField(
                  contentPadding: EdgeInsets.symmetric(horizontal: 2),
                  labelOnLine: 'Nama',
                  hintText: 'Siapa namamu?',
                  textAlign: .center,
                  validator: XFormValidator.combine([
                    XFormValidator.required(
                      message: 'Field tidak boleh kosong',
                    ),
                    XFormValidator.minLength(
                      3,
                      message: 'Minimum nama cabang 3 karakter',
                    ),
                    XFormValidator.maxLength(
                      50,
                      message: 'Maksimal nama cabang 50 karakter',
                    ),
                  ]),
                ),
              ),

              XButton(
                onPressed: () => _formKey.currentState?.validate(),
                label: 'Validasi Form',
              ),

              XHeight(8),
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
                onTimeSelected: (time) =>
                    XSnackbar.success('DateTime ${time?.hour}', position: .top),
              ),
              XSpacer(height: 8),
              XTextField(
                label: 'File Picker',
                isRequired: true,
                fieldType: .file,
                onFileSelected: (file) =>
                    XSnackbar.success('DateTime ${file?.path}', position: .top),
              ),
              XSpacer(height: 8),
              XTextField(
                label: 'Dropdown labelOnLine',
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
    XSnackbar.warning(
      'XButton Pressed',
      position: .top,
      title: 'Title',
      config: XSnackbarConfig(
        radius: 0,
        leadingIcon: Icon(Icons.ac_unit_sharp, color: Colors.white),
        actionLabel: 'Tutup',
        margin: EdgeInsets.zero,
      ),
      onAction: () => debugPrint('Action Tapped'),
    );
  }

  Future<void> showXButtonActionCustom() async {
    await Future.delayed(Duration(seconds: 2));
    XSnackbar.success('XButton Pressed', position: .bottom);
  }
}
