// ignore_for_file: require_trailing_commas, invalid_use_of_protected_member

import 'dart:developer';
import 'dart:io';

import 'package:allin1/core/constants/app_config.dart';
import 'package:allin1/core/constants/dimensions.dart';
import 'package:allin1/core/languages/language_ar.dart';
import 'package:allin1/core/languages/languages.dart';
import 'package:allin1/data/models/area_model.dart';
import 'package:allin1/data/models/city_model.dart';
import 'package:allin1/data/models/location_model.dart';
import 'package:allin1/data/models/partner_model.dart';
import 'package:allin1/data/models/section_model.dart';
import 'package:allin1/presentation/routers/app_router.dart';
import 'package:allin1/presentation/routers/import_helper.dart';
import 'package:allin1/presentation/screens/createOrder/components/partner_view.dart';
import 'package:allin1/presentation/screens/homeLayout/home/home_tab_mobile.dart';
import 'package:allin1/presentation/widgets/components/components.dart';
import 'package:allin1/presentation/widgets/custom_divider.dart';
import 'package:allin1/presentation/widgets/defaultButton/default_button.dart';
import 'package:allin1/presentation/widgets/formBuilderField/form_builder_field.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:iconly/iconly.dart';
import 'package:image_picker/image_picker.dart';

class CreateOrderScreen extends StatefulWidget {
  final SectionModel section;
  final PartnerModel partner;
  const CreateOrderScreen({
    Key? key,
    this.section = const SectionModel.create(),
    this.partner = const PartnerModel.create(featured: false),
  }) : super(key: key);
  @override
  _CreateOrderScreenState createState() => _CreateOrderScreenState();
}

class _CreateOrderScreenState extends State<CreateOrderScreen> {
  late final CategoryCubit categoryCubit;
  final formBuilderKey = GlobalKey<FormBuilderState>();
  List<CityModel> allCities = [];
  List<AreaModel> allAreas = [];
  List<LocationModel> locations = [];
  File? _pickedFile;
  int? imageId;
  bool isUploadingImage = false;
  bool _isInit = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_isInit) {
      categoryCubit = CategoryCubit.get(context);
      categoryCubit.allAreas.clear();
      categoryCubit.getAllCities();
      if (FirebaseAuthBloc.currentUser != null) {
        locations = FirebaseAuthBloc.currentUser!.userData.locations;
      }
      // final Map<String,dynamic> selectedLocationData = jsonDecode(hydratedStorage.read("selectedLocation").toString()) as Map<String,dynamic>;
      // CustomerCubit.selectedLocation = LocationModel.fromMap(selectedLocationData);
      _isInit = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(CategoryCubit.appText!.orderDetails),
        titleSpacing: vMediumPadding,
      ),
      body: BlocBuilder<CategoryCubit, CategoryState>(
        builder: (context, state) {
          if (state is! GetAllCitiesLoading) {
            allCities = categoryCubit.allCities;
            allAreas = categoryCubit.allAreas;
            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        const CustomDivider(),
                        if (widget.partner.name != '')
                          PartnerView(partner: widget.partner),
                        if (widget.partner.name != '') const CustomDivider(),
                        buildForm(state),
                        const CustomDivider(),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: hMediumPadding,
                              vertical: vMediumPadding),
                          child: BlocConsumer<OrdersCubit, OrdersState>(
                            listener: (context, state) {
                              if (state is OrdersCreateSuccess) {
                                OrdersCubit.get(context).getOrders();
                                _pickedFile = null;
                                formBuilderKey.currentState!.reset();
                                AwesomeDialog(
                                  context: context,
                                  dismissOnBackKeyPress: false,
                                  dismissOnTouchOutside: false,
                                  autoDismiss: false,
                                  onDissmissCallback: (dismissType) {
                                    return false;
                                  },
                                  dialogType: DialogType.SUCCES,
                                  title:
                                      CategoryCubit.appText!.yourOrderReceived,
                                  desc: CategoryCubit.appText!.orderIsReviewing,
                                  btnOkText: CategoryCubit.appText!.ok,
                                  btnOkOnPress: () {
                                    OrdersCubit.get(context).refreshOrders();
                                    Navigator.popUntil(context,
                                        (route) => !route.hasActiveRouteBelow);
                                    tabController?.animateTo(0);
                                  },
                                  // btnOkColor: Theme.of(context).colorScheme.primary,
                                ).show();
                              } else if (state is OrdersCreateFailed) {
                                customSnackBar(
                                    context: context, message: state.error);
                              }
                            },
                            builder: (context, state) {
                              return DefaultButton(
                                width: double.infinity,
                                isLoading: state is OrdersCreateLoading ||
                                    isUploadingImage,
                                text: CategoryCubit.appText!.placeOrder,
                                onPressed: () {
                                  if (FirebaseAuthBloc.currentUser != null) {
                                    final customer =
                                        FirebaseAuthBloc.currentUser!;
                                    if (customer.userData.area != null) {
                                      if (CustomerCubit.selectedLocation !=
                                          null) {
                                        _placeOrder();
                                      } else {
                                        buildAddressSheet(context);
                                      }
                                    } else {
                                      buildCityAreaSheet(context);
                                    }
                                  } else {
                                    customSnackBar(
                                      context: context,
                                      message: CategoryCubit
                                          .appText!.needToLoginFirst,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    );
                                    Navigator.pushNamedAndRemoveUntil(context,
                                        AppRouter.authScreen, (route) => false);
                                    tabController = null;
                                  }
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  final outlineInputBorder = OutlineInputBorder(
    borderSide: BorderSide(
      width: 0.2,
      color: Colors.grey.shade900.withOpacity(0.6),
    ),
  );

  Widget buildForm(CategoryState state) {
    return FormBuilder(
      key: formBuilderKey,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: vMediumPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Padding(
            //   padding: EdgeInsets.symmetric(horizontal: hMediumPadding),
            //   child: Row(
            //     children: [
            //       Icon(
            //         IconlyBold.ticket_star,
            //         color: Theme.of(context).colorScheme.primary,
            //         size: 22.w,
            //       ),
            //       SizedBox(width: hSmallPadding),
            //       Text(
            //         CategoryCubit.appText!.branch,
            //         style: Theme.of(context)
            //             .textTheme
            //             .subtitle1!
            //             .copyWith(fontWeight: FontWeight.w500),
            //       ),
            //     ],
            //   ),
            // ),
            // SizedBox(height: vSmallPadding),
            // Padding(
            //   padding: EdgeInsets.symmetric(horizontal: hLargePadding),
            //   child: FormBuilderDropdown<CityModel>(
            //     name: 'city',
            //     hint: Text(CategoryCubit.appText!.selectedYourState),
            //     decoration: FilledTextFieldWithLabel.customInputDecoration(
            //             context: context)
            //         .copyWith(
            //       fillColor: Theme.of(context).scaffoldBackgroundColor,
            //       border: outlineInputBorder,
            //       focusedBorder: outlineInputBorder,
            //       enabledBorder: outlineInputBorder,
            //     ),
            //     items: List.generate(allCities.length, (index) {
            //       final city = allCities[index];
            //       return DropdownMenuItem(
            //         value: city,
            //         child: Text(
            //           city.name,
            //           style: Theme.of(context).textTheme.bodyText1,
            //         ),
            //       );
            //     }),
            //     onChanged: (city) async {
            //       if (city != null) {
            //         setState(() {
            //           allAreas.clear();
            //           categoryCubit.allAreas.clear();
            //         });
            //         formBuilderKey.currentState!
            //             .removeInternalFieldValue('area', isSetState: true);
            //         await categoryCubit.getAreasByCity(city.id);
            //         setState(() => allAreas = categoryCubit.allAreas);
            //       }
            //     },
            //     validator: (value) {
            //       if (value == null) {
            //         return CategoryCubit.appText!.filedIsRequired;
            //       }
            //       return null;
            //     },
            //   ),
            // ),
            // if (state is GetAllAreasLoading) SizedBox(height: vLargePadding),
            // if (state is GetAllAreasLoading)
            //   Center(
            //     child: SizedBox(
            //       width: 25.w,
            //       height: 25.w,
            //       child: const CircularProgressIndicator(),
            //     ),
            //   ),
            // SizedBox(height: vMediumPadding),
            // if (allAreas.isNotEmpty)
            //   Padding(
            //     padding: EdgeInsets.symmetric(horizontal: hLargePadding),
            //     child: FormBuilderDropdown<AreaModel>(
            //       name: 'area',
            //       hint: Text(CategoryCubit.appText!.townCity),
            //       decoration: FilledTextFieldWithLabel.customInputDecoration(
            //               context: context)
            //           .copyWith(
            //         fillColor: Theme.of(context).scaffoldBackgroundColor,
            //         border: outlineInputBorder,
            //         focusedBorder: outlineInputBorder,
            //         enabledBorder: outlineInputBorder,
            //       ),
            //       enabled: allAreas.isNotEmpty,
            //       items: List.generate(allAreas.length, (index) {
            //         final area = allAreas[index];
            //         return DropdownMenuItem(
            //           key: Key(area.id.toString()),
            //           value: area,
            //           child: Text(
            //             area.name,
            //             style: Theme.of(context).textTheme.bodyText1,
            //           ),
            //         );
            //       }),
            //       validator: (value) {
            //         if (value == null) {
            //           return CategoryCubit.appText!.filedIsRequired;
            //         }
            //         return null;
            //       },
            //     ),
            //   ),
            // SizedBox(height: vMediumPadding),
            // const CustomDivider(),
            SizedBox(height: vMediumPadding),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: hMediumPadding),
              child: MyFormBuilderFiled(
                id: 'content',
                maxLines: 5,
                title: CategoryCubit.appText!.orderDetails,
                initialValue: '',
                keyboardType: TextInputType.multiline,
                titlePrefix: Icon(
                  IconlyBold.document,
                  color: Theme.of(context).colorScheme.primary,
                  size: 22.w,
                ),
                fillColor: Theme.of(context).scaffoldBackgroundColor,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return CategoryCubit.appText!.filedIsRequired;
                  }
                  return null;
                },
              ),
            ),
            SizedBox(height: vSmallPadding),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: hMediumPadding, vertical: vSmallPadding),
              child: pickImageContainer(),
            ),
            SizedBox(height: vMediumPadding),
            // Padding(
            //   padding: EdgeInsets.symmetric(
            //       horizontal: hMediumPadding, vertical: vSmallPadding),
            //   child: Row(
            //     children: [
            //       TextButton.icon(
            //         onPressed: chooseImage,
            //         icon: Icon(IconlyBold.image,
            //             size: 22.w,
            //             color: Theme.of(context).colorScheme.primary),
            //         label: Text(CategoryCubit.appText!.attachImage),
            //       ),
            //       const Spacer(),
            //       if (_pickedFile != null)
            //         ClipRRect(
            //           borderRadius: BorderRadius.circular(verySmallRadius),
            //           child: Image.file(
            //             _pickedFile!,
            //             width: 50.w,
            //             height: 50.w,
            //             fit: BoxFit.contain,
            //           ),
            //         ),
            //     ],
            //   ),
            // ),
            const CustomDivider(),
            SizedBox(height: vMediumPadding),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: hMediumPadding),
              child: Row(
                children: [
                  Icon(
                    IconlyBold.location,
                    color: Theme.of(context).colorScheme.primary,
                    size: 22.w,
                  ),
                  SizedBox(width: hSmallPadding),
                  Text(
                    CategoryCubit.appText!.deliveryAddress,
                    style: Theme.of(context)
                        .textTheme
                        .subtitle1!
                        .copyWith(fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
            SizedBox(height: vSmallPadding),
            BlocBuilder<CustomerCubit, CustomerState>(
              builder: (context, state) {
                return Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: hMediumPadding, vertical: vMediumPadding),
                  child: InkWell(
                    onTap: () => buildAddressSheet(context),
                    child: Container(
                      margin: EdgeInsets.symmetric(
                          horizontal: hVerySmallPadding * 0.5),
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(verySmallRadius),
                        color: Theme.of(context).scaffoldBackgroundColor,
                        boxShadow: [
                          BoxShadow(
                            color: primarySwatch.withOpacity(0.5),
                            blurRadius: 2,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: hVerySmallPadding,
                          vertical: vVerySmallPadding,
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                // Radio(
                                //   value: true,
                                //   groupValue: true,
                                //   fillColor: MaterialStateProperty.all(
                                //     Theme.of(context).colorScheme.primary,
                                //   ),
                                //   onChanged: (value) {},
                                // ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: hSmallPadding,
                                      vertical: vMediumPadding),
                                  child: Icon(
                                    Icons.my_location_sharp,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    size: 22.w,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    CustomerCubit.selectedLocation?.address ??
                                        CategoryCubit.appText!.selectLocation,
                                    maxLines: 2,
                                    softWrap: true,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            if (FirebaseAuthBloc.currentUser!.userData.area !=
                                    null &&
                                FirebaseAuthBloc.currentUser!.userData.area!
                                        .deliveryPrice !=
                                    '0') ...[
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: hSmallPadding,
                                  vertical: vSmallPadding,
                                ).copyWith(top: 0),
                                child: Align(
                                  alignment: AlignmentDirectional.centerEnd,
                                  child: RichText(
                                    text: TextSpan(
                                      text:
                                          '${CategoryCubit.appText!.shippingFees}: ',
                                      style:
                                          Theme.of(context).textTheme.bodyText2,
                                      children: [
                                        TextSpan(
                                          text: FirebaseAuthBloc.currentUser!
                                              .userData.area!.deliveryPrice,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1,
                                        ),
                                        TextSpan(
                                          text: ' ${CategoryCubit.currency}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText2,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            // BlocBuilder<CustomerCubit, CustomerState>(
            //   builder: (context, state) {
            //     locations = FirebaseAuthBloc.currentUser!.userData.locations;
            //     return Padding(
            //       padding: EdgeInsets.symmetric(horizontal: hLargePadding),
            //       child: FormBuilderDropdown<LocationModel?>(
            //         name: 'location',
            //         hint: Text(CategoryCubit.appText!.address),
            //         decoration: FilledTextFieldWithLabel.customInputDecoration(
            //           context: context,
            //           maxLines: 4,
            //         ).copyWith(
            //           fillColor: Theme.of(context).scaffoldBackgroundColor,
            //           border: outlineInputBorder,
            //           focusedBorder: outlineInputBorder,
            //           enabledBorder: outlineInputBorder,
            //         ),
            //         enabled: locations.isNotEmpty,
            //
            //         items: List.generate(locations.length, (index) {
            //           final location = locations[index];
            //           return DropdownMenuItem(
            //             key: Key(location.address),
            //             value: location,
            //             child: Text(
            //               location.address,
            //               style: Theme.of(context).textTheme.bodyText1,
            //             ),
            //           );
            //         }),
            //         validator: (value) {
            //           if (value == null) {
            //             return CategoryCubit.appText!.filedIsRequired;
            //           }
            //           return null;
            //         },
            //       ),
            //     );
            //   },
            // ),
          ],
        ),
      ),
    );
  }

  Future<void> _placeOrder() async {
    if (formBuilderKey.currentState != null &&
        formBuilderKey.currentState!.saveAndValidate()) {
      FocusScope.of(context).unfocus();
      final formMap = formBuilderKey.currentState!.value;
      final content = formMap['content'] as String;
      final customer = FirebaseAuthBloc.currentUser!;
      final area = customer.userData.area!;
      final location = CustomerCubit.selectedLocation;
      final partner = widget.partner;
      final section = widget.section;
      log('Section Model is: $section');
      final fullName = '${customer.firstName} ${customer.lastName}';
      final order = OrderModel.create(
        orderContent: content,
        area: area,
        section: section,
        customerMobile: FirebaseAuthBloc.currentUser!.userData.mobile != ''
            ? FirebaseAuthBloc.currentUser!.userData.mobile
            : FirebaseAuthBloc.currentUser!.username,
        partner: OrderUserModel(
            id: partner.id, name: partner.name, username: partner.name),
        customer: OrderUserModel(
          id: customer.id,
          name: fullName.isNotEmpty ? fullName : customer.username,
          username: customer.username,
        ),
        customerLocation: location,
      );

      if (_pickedFile != null) {
        setState(() => isUploadingImage = true);
        showLoadingDialog(
          context,
          title: CategoryCubit.appText!.uploadingImage,
        );
        final customerCubit = CustomerCubit.get(context);
        log('Uploading image...');
        final imageData = await customerCubit.uploadImageFile(_pickedFile!);
        if (imageData != null) {
          setState(() => imageId = imageData['id'] as int);
        }
        setState(() => isUploadingImage = false);
        Navigator.pop(context);
      }
      final orderMap = order.toMap(imageId);
      log('Order: $orderMap');
      await OrdersCubit.get(context).createOrder(orderMap);
    }
  }

  Future<void> chooseImage() async {
    final isGallery = await showWarningDialog(
      context,
      title: CategoryCubit.appText!.pickImage,
      content: CategoryCubit.appText!.chooseImageSentence,
      lfButtonTxt: CategoryCubit.appText!.camera,
      rtButtonTxt: CategoryCubit.appText!.gallery,
    );
    if (isGallery != null) {
      final xFile = await ImagePicker().pickImage(
          source: isGallery ? ImageSource.gallery : ImageSource.camera);
      if (xFile != null) {
        setState(() => _pickedFile = File(xFile.path));
      }
    }
  }

  // Future _showPickImageSheet() async {
  //   showCupertinoModalPopup(
  //     context: context,
  //     builder: (context) {
  //       return CupertinoActionSheet(
  //         actions: [
  //           CupertinoActionSheetAction(
  //             onPressed: () async {
  //               Navigator.pop(context);
  //               final xFile =
  //               await ImagePicker().pickImage(source: ImageSource.gallery
  //                 // , maxHeight: 480, maxWidth: 640
  //               );
  //               if (xFile != null) {
  //                 setState(() => _pickedFile = File(xFile.path));
  //               }
  //             },
  //             child: Row(
  //               mainAxisAlignment: MainAxisAlignment.center,
  //               children: [
  //                 Text(
  //                   'Gallery',
  //                   style: Theme.of(context).textTheme.headline6!.copyWith(
  //                       fontWeight: FontWeight.w500, color:  Colors.black),
  //                 ),
  //                 SizedBox(
  //                   width: hSmallPadding,
  //                 ),
  //                 const Icon(
  //                   CupertinoIcons.photo_fill,
  //                   color: Colors.black,
  //                 )
  //               ],
  //             ),
  //           ),
  //           CupertinoActionSheetAction(
  //             onPressed: () async {
  //               Navigator.pop(context);
  //               final xFile = await ImagePicker().pickImage(
  //                 source: ImageSource.camera,
  //               );
  //               if (xFile != null) {
  //                 setState(() => _pickedFile = File(xFile.path));
  //               }
  //             },
  //             child: Row(
  //               mainAxisAlignment: MainAxisAlignment.center,
  //               children: [
  //                 Text(
  //                   'Camera',
  //                   style: Theme.of(context).textTheme.headline6!.copyWith(
  //                       fontWeight: FontWeight.w500, color: Colors.black),
  //                 ),
  //                 SizedBox(
  //                   width: hSmallPadding,
  //                 ),
  //                 const Icon(
  //                   CupertinoIcons.camera_fill,
  //                   color: Colors.black,
  //                 )
  //               ],
  //             ),
  //           ),
  //         ],
  //         cancelButton: DefaultButton(
  //           text: CategoryCubit.appText!.cancel,
  //           buttonColor: Colors.black,
  //           onPressed: () => Navigator.pop(context),
  //           width: double.infinity,
  //         ),
  //       );
  //     },
  //   );
  // }

  Stack pickImageContainer() {
    final isArabic = Languages.of(context) is LanguageAr;
    return Stack(
      clipBehavior: Clip.none,
      alignment: AlignmentDirectional.bottomStart,
      children: [
        if (_pickedFile != null)
          Container(
            // width: 180.w,
            height: 150.h,
            padding: EdgeInsets.symmetric(vertical: vMediumPadding),
            decoration: BoxDecoration(
              color: Theme.of(context).backgroundColor,
              borderRadius: BorderRadius.circular(smallRadius),
              border: Border.all(
                color: primarySwatch,
              ),
              image: DecorationImage(
                fit: BoxFit.contain,
                image: FileImage(_pickedFile!),
                onError: (exception, stackTrace) {},
              ),
            ),
            clipBehavior: Clip.antiAlias,
          )
        // else if (_imageUrl != null)
        //   Container(
        //     width: 180.w,
        //     height: 250.w,
        //     decoration: BoxDecoration(
        //       color: Theme.of(context).backgroundColor,
        //       borderRadius: BorderRadius.circular(verySmallRadius),
        //       image: DecorationImage(
        //         fit: BoxFit.cover,
        //         image: NetworkImage(_imageUrl!),
        //         onError: (exception, stackTrace) {},
        //       ),
        //     ),
        //     clipBehavior: Clip.antiAlias,
        //   )
        else
          GestureDetector(
            onTap: () {
              chooseImage();
            },
            child: Container(
              height: 150.h,
              width: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(smallRadius),
                  border: Border.all(
                    color: primarySwatch,
                  )),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Icon(
                    CupertinoIcons.doc_plaintext,
                    size: 80.w,
                    color: primarySwatch,
                  ),
                  Text(
                    CategoryCubit.appText!.attachImage,
                    style: Theme.of(context).textTheme.subtitle2,
                  )
                ],
              ),
            ),
          ),
        if (_pickedFile != null)
          Positioned.directional(
            bottom: -vVerySmallMargin,
            start: -hSmallPadding,
            textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
            child: InkWell(
              onTap: () async {
                chooseImage();
              },
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CircleAvatar(
                    radius: 22,
                    backgroundColor: Theme.of(context).backgroundColor,
                  ),
                  const CircleAvatar(
                    radius: 20,
                    backgroundColor: primarySwatch,
                    child: Icon(
                      IconlyBold.image,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          const SizedBox(),
      ],
    );
  }
}
