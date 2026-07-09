import 'dart:io';

import 'package:example/look_scrollview_demo.dart';
import 'package:example/other_widgets_example.dart';
import 'package:flutter/material.dart';
import 'package:xwidgets_pack/models/x_button_style.dart';
import 'package:xwidgets_pack/models/x_snackbar_config.dart';
import 'package:xwidgets_pack/utils/x_form_validators.dart';
import 'package:xwidgets_pack/utils/x_textfield_options.dart';
import 'package:xwidgets_pack/xwidgets.dart';

/// Full widget showcase used for [XLook.standard] and [XLook.material].
class ExampleXwidgets extends StatefulWidget {
  const ExampleXwidgets({super.key, this.look = XLook.standard});

  final XLook look;

  @override
  State<ExampleXwidgets> createState() => _ExampleXwidgetsState();
}

class _ExampleXwidgetsState extends State<ExampleXwidgets> {
  var isLoadingButtonTitle = false;
  var isLoadingInsideButton = false;
  var isLoadingButtonCustom = false;
  var isLoadingShimmerCustom = false;

  final _formKey = GlobalKey<FormState>();

  XLook get look => widget.look;

  String get _title => look == XLook.material
      ? 'XWidgets (Material)'
      : 'XWidgets';

  void _handleBack() {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    } else {
      exit(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: XAppBar(
        look: look,
        title: _title,
        backButton: const Icon(Icons.arrow_back_outlined),
        onTapBack: _handleBack,
      ),
      body: XCard(
        look: look,
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              XText(
                'X Text Example',
                look: look,
                icon: const Icon(Icons.android),
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              XText(
                'Long Text Example Long Text Example Long Text Example Long Text Example Long Text Example Long Text Example',
                look: look,
                iconVerticalAlignment: .start,
                isExpand: true,
                icon: const Icon(Icons.android),
                style: const TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 18,
                ),
              ),
              const XSpacer(height: 8),
              XSingleDashedLine(look: look),
              const XDiagonalStrikethroughText(
                'DICORET',
                diagonalType: .bottomTop,
                lineColor: Colors.red,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              XDoubleDashedLine(look: look),
              const XSpacer(height: 16),
              XButton(
                look: look,
                isLoading: isLoadingButtonTitle,
                onPressed: () async {
                  setState(() => isLoadingButtonTitle = true);
                  await showXButtonActionTitle();
                  setState(() => isLoadingButtonTitle = false);
                },
                label: 'XButton with Title',
              ),
              const XSpacer(height: 8),
              XButton(
                isLoading: isLoadingInsideButton,
                isLoadingInside: true,
                onPressed: () async {
                  setState(() => isLoadingInsideButton = true);
                  await Future.delayed(const Duration(seconds: 2));
                  setState(() => isLoadingInsideButton = false);
                },
                style: const XButtonStyle(
                  background: Colors.green,
                  foreground: Colors.white,
                  borderColor: Colors.greenAccent,
                  loadingColor: Colors.white,
                  textSize: 16,
                ),
                label: 'XButton Loading Inside',
              ),
              const XSpacer(height: 8),
              XButton(
                look: look,
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
                      look: look,
                      style: const TextStyle(fontSize: 11),
                      icon: const Icon(Icons.ads_click_rounded),
                    ),
                    const Text('XButton Custom View'),
                  ],
                ),
              ),
              const XSpacer(height: 8),
              XShimmer(
                isLoading: isLoadingShimmerCustom,
                shimmerChild: Column(
                  children: [
                    XShimmerChild(look: look, width: 100, height: 45),
                    const XSpacer(height: 10),
                    XShimmerChild(look: look, width: 100, height: 45),
                  ],
                ),
                child: Container(
                  width: 100,
                  height: 100,
                  alignment: .center,
                  child: const Text('HelloWord'),
                ),
              ),
              const XSpacer(height: 16),
              XButton(
                look: look,
                height: 56,
                widthInfinity: true,
                isLoading: isLoadingShimmerCustom,
                onPressed: () async {
                  setState(() => isLoadingShimmerCustom = true);
                  await Future.delayed(const Duration(seconds: 2));
                  setState(() => isLoadingShimmerCustom = false);
                },
                child: const Text('XShimmer Loading View'),
              ),
              const XSpacer(height: 16),
              Form(
                key: _formKey,
                child: XTextField(
                  look: look,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 2),
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
                look: look,
                onPressed: () => _formKey.currentState?.validate(),
                label: 'Validasi Form',
              ),
              const XHeight(8),
              XTextField(
                look: look,
                label: 'Date Picker',
                fieldType: .datepicker,
                suffixIcon: const Icon(Icons.calendar_month_outlined),
              ),
              const XSpacer(height: 8),
              XTextField(
                look: look,
                labelOnLine: 'Date Time labelOnLine',
                fieldType: .timepicker,
                suffixIcon: const Icon(Icons.timelapse_outlined),
                onTimeSelected: (time) => XSnackbar.success(
                  'DateTime ${time?.hour}',
                  position: .top,
                  look: look,
                ),
              ),
              const XSpacer(height: 8),
              XTextField(
                look: look,
                label: 'File Picker',
                isRequired: true,
                fieldType: .file,
                onFileSelected: (file) => XSnackbar.success(
                  'DateTime ${file?.path}',
                  position: .top,
                  look: look,
                ),
              ),
              const XSpacer(height: 8),
              XTextField(
                look: look,
                label: 'Dropdown labelOnLine',
                dropdownOptions: XTextFieldDropdownOptions(
                  items: const ['Sumatera', 'Jawa', 'Kalimantan'],
                  itemAsString: (item) => item as String,
                ),
                fieldType: .dropdown,
              ),
              const XSpacer(height: 16),
              LookScrollViewDemo(look: look),
              const XSpacer(height: 16),
              XButton(
                look: look,
                widthInfinity: true,
                label: 'Open Other Widgets Examples',
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => const OtherWidgetsExample(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> showXButtonActionTitle() async {
    await Future.delayed(const Duration(seconds: 2));
    XSnackbar.warning(
      'XButton Pressed',
      position: .top,
      title: 'Title',
      look: look,
      config: XSnackbarConfig(
        radius: 0,
        leadingIcon: const Icon(Icons.ac_unit_sharp, color: Colors.white),
        actionLabel: 'Tutup',
        margin: EdgeInsets.zero,
      ),
      onAction: () => debugPrint('Action Tapped'),
    );
  }

  Future<void> showXButtonActionCustom() async {
    await Future.delayed(const Duration(seconds: 2));
    XSnackbar.success('XButton Pressed', position: .bottom, look: look);
  }
}
