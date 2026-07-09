import 'dart:io';

import 'package:example/look_presets_example.dart';
import 'package:example/other_widgets_example.dart';
import 'package:flutter/material.dart';
import 'package:xwidgets_pack/models/x_button_style.dart';
import 'package:xwidgets_pack/models/x_snackbar_config.dart';
import 'package:xwidgets_pack/utils/x_form_validators.dart';
import 'package:xwidgets_pack/utils/x_textfield_options.dart';
import 'package:xwidgets_pack/xwidgets.dart';

class ExampleXwidgets extends StatefulWidget {
  const ExampleXwidgets({super.key});

  @override
  State<ExampleXwidgets> createState() => _ExampleXwidgetsState();
}

class _ExampleXwidgetsState extends State<ExampleXwidgets> {
  var isLoadingButtonTitle = false;
  var isLoadingInsideButton = false;
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
                isLoading: isLoadingInsideButton,
                isLoadingInside: true,
                onPressed: () async {
                  setState(() => isLoadingInsideButton = true);
                  await Future.delayed(Duration(seconds: 2));
                  setState(() => isLoadingInsideButton = false);
                },
                style: XButtonStyle(
                  background: Colors.green,
                  foreground: Colors.white,
                  borderColor: Colors.greenAccent,
                  loadingColor: Colors.white,
                  textSize: 16,
                ),
                label: 'XButton Loading Inside',
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
              XSpacer(height: 16),
              XText(
                'XScrollView Pagination',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              XSpacer(height: 8),
              SizedBox(
                height: 360,
                child: XScrollView<String>(
                  pageSize: 10,
                  onInit: _fetchScrollItems,
                  onLoadMore: _fetchScrollItems,
                  paginationLoadingBuilder: (_) => Padding(
                    padding: EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox.square(
                          dimension: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                        XSpacer(width: 8),
                        Text('Loading more...'),
                      ],
                    ),
                  ),
                  refreshIndicatorBuilder: (_, progress, isRefreshing) {
                    return Padding(
                      padding: EdgeInsets.all(12),
                      child: Chip(
                        avatar: SizedBox.square(
                          dimension: 18,
                          child: CircularProgressIndicator(
                            value: isRefreshing ? null : progress,
                            strokeWidth: 2,
                          ),
                        ),
                        label: Text(
                          isRefreshing ? 'Refreshing...' : 'Pull to refresh',
                        ),
                      ),
                    );
                  },
                  onItemTap: (item, index) {
                    XSnackbar.success(
                      'Clicked $item at index $index',
                      position: .bottom,
                    );
                  },
                  separatorBuilder: (_, _) => Divider(height: 1),
                  itemBuilder: (context, item, index) {
                    return ListTile(
                      leading: CircleAvatar(child: Text('${index + 1}')),
                      title: Text(item),
                      subtitle: Text('Tap this item to trigger onItemTap'),
                    );
                  },
                ),
              ),
              XSpacer(height: 16),
              XText(
                'XScrollView Horizontal',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              XSpacer(height: 8),
              SizedBox(
                height: 150,
                child: XScrollView<String>(
                  scrollDirection: Axis.horizontal,
                  pageSize: 10,
                  onInit: _fetchScrollItems,
                  onLoadMore: _fetchScrollItems,
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  paginationLoadingBuilder: (_) => SizedBox(
                    width: 80,
                    child: Center(child: Text('Loading →')),
                  ),
                  refreshIndicatorBuilder: (_, progress, isRefreshing) {
                    return Padding(
                      padding: EdgeInsets.all(8),
                      child: CircleAvatar(
                        child: isRefreshing
                            ? SizedBox.square(
                                dimension: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : Text('${(progress * 100).round()}%'),
                      ),
                    );
                  },
                  separatorBuilder: (_, _) => VerticalDivider(width: 12),
                  onItemTap: (item, _) {
                    XSnackbar.success('Clicked $item', position: .bottom);
                  },
                  itemBuilder: (context, item, index) {
                    return SizedBox(
                      width: 140,
                      child: Card(
                        child: Center(
                          child: Text(item, textAlign: TextAlign.center),
                        ),
                      ),
                    );
                  },
                ),
              ),
              XSpacer(height: 16),
              XButton(
                widthInfinity: true,
                label: 'Open Look Presets Showcase',
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => const LookPresetsExample(),
                    ),
                  );
                },
              ),
              XSpacer(height: 8),
              XButton(
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

  Future<XScrollPage<String>> _fetchScrollItems(XScrollRequest request) async {
    await Future.delayed(Duration(milliseconds: 700));

    const totalItems = 45;
    final end = (request.offset + request.limit).clamp(0, totalItems);
    final items = List.generate(
      end - request.offset,
      (index) => 'Paginated item ${request.offset + index + 1}',
    );

    return XScrollPage(items: items, hasMore: end < totalItems);
  }
}
