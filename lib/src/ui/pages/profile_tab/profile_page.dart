import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:image_picker/image_picker.dart';
import 'package:movie_app/src/data/api/bloc/api_bloc.dart';
import 'package:movie_app/src/data/models/account/account_model.dart';
import 'package:movie_app/src/storage/data_storage.dart';
import 'package:movie_app/src/utils/utils.dart';
import 'package:sizer/sizer.dart';

class ProfilePage extends StatefulWidget {
  static const String route = '/profile';
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  AccountModel? account;
  final ImagePicker _picker = ImagePicker();
  List<String> files = <String>[];

  @override
  void initState() {
    loadAccount();

    super.initState();

    context.read<ApiBloc>().add(GetAllFilesEvent());
  }

  void loadAccount() {
    final Storage storage = Storage();

    account = storage.getAccount();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF060c2b),
      body: SizedBox.expand(
        child: Column(children: <Widget>[
          SizedBox(
            height: 15.h,
          ),
          Center(
            child: ClipOval(
              child: Container(
                height: 15.h,
                width: 15.h,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 1.w),
                    borderRadius: BorderRadius.circular(50)),
                child: CachedNetworkImage(
                    fit: BoxFit.contain,
                    imageUrl:
                        "${environment.baseUrlImages}${account?.avatar_path}",
                    placeholder: (_, __) =>
                        const SpinKitRipple(color: Colors.white),
                    errorListener: (e) {},
                    imageBuilder: (BuildContext context, ImageProvider image) {
                      return Image(
                        image: image,
                        fit: BoxFit.fitWidth,
                      );
                    }),
              ),
            ),
          ),
          SizedBox(
            height: 5.h,
          ),
          Center(
            child: Text(
              account?.name ?? '',
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.w900),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 25.w),
            child: const Divider(),
          ),
          Center(
            child: Text(
              account?.username ?? '',
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w900),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 25.w),
            child: const Divider(),
          ),
          SizedBox(
            height: 5.h,
          ),
          ElevatedButton(
              onPressed: () {
                _showChangePictureSheet();
              },
              child: const Text("Seleccionar imagen")),
          SizedBox(
            height: 4.h,
          ),
          const Center(
              child: Text(
            "Archivos en Firebase",
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.w800, fontSize: 18),
          )),
          SizedBox(
            height: 2.h,
          ),
          Expanded(
            child: BlocConsumer<ApiBloc, ApiState>(listener: (context, state) {
              if (state is ErrorAppState) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(state.error.message)));
              }

              if (state is SuccessInfoState) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(state.message ?? '')));
              }

              if (state is SuccessFilesState) {
                files = state.files;

                setState(() {});
              }
            }, builder: (context, state) {
              if (state is SuccessFilesState) {
                return ListView(
                  children: state.files
                      .map((String e) => Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 5.w, vertical: 1.h),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  e,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600),
                                ),
                                const Divider()
                              ],
                            ),
                          ))
                      .toList(),
                );
              } else if (state is MovieLoaderFilesState) {
                return const Center(
                  child: SpinKitPulsingGrid(color: Colors.white),
                );
              } else {
                return Container();
              }
            }),
          )
        ]),
      ),
    );
  }

  Future<void> _showChangePictureSheet() async {
    showModalBottomSheet(
      backgroundColor: Colors.black.withOpacity(0.4),
      context: context,
      useRootNavigator: true,
      builder: (BuildContext contextModal) {
        return Builder(
          builder: (BuildContext contextState) {
            return Container(
              decoration: const BoxDecoration(
                  color: Color(0xFF060c2b),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8),
                      topRight: Radius.circular(8))),
              margin: EdgeInsets.symmetric(horizontal: 3.w),
              padding: EdgeInsets.symmetric(horizontal: 3.w),
              child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                SizedBox(
                  height: 5.h,
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        "Selecciona de donde se obtendra la imagen",
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(color: Colors.white),
                      ),
                    ),
                    InkWell(
                        onTap: () {
                          context.pop();
                        },
                        child: const Icon(
                          Icons.close,
                          color: Colors.white,
                        ))
                  ],
                ),
                SizedBox(
                  height: 5.h,
                ),
                _buildOption(
                    icon: Bootstrap.camera2,
                    onTap: () {
                      context.pop();
                      _getPicture(context, ImageSource.camera);
                    },
                    title: "Tomar foto"),
                const Divider(
                  color: Colors.grey,
                ),
                _buildOption(
                    icon: Bootstrap.file_image_fill,
                    onTap: () {
                      context.pop();
                      _getPicture(context, ImageSource.gallery);
                    },
                    title: "Seleccionar de galeria"),
                const Divider(
                  color: Colors.grey,
                ),
                SizedBox(
                  height: 3.h,
                ),
              ]),
            );
          },
        );
      },
    );
  }

  Widget _buildOption({Function()? onTap, String? title = '', dynamic icon}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        color: Colors.transparent,
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Text(
                title!,
                style: const TextStyle(color: Colors.white),
              ),
            ),
            Icon(
              icon,
              color: Colors.white,
            )
          ],
        ),
      ),
    );
  }

  Future<void> _getPicture(BuildContext context, ImageSource source) async {
    try {
      final XFile? file = await _picker.pickImage(
        requestFullMetadata: false,
        source: source,
      );

      if (file != null) {
        if (context.mounted) {
          context.read<ApiBloc>().add(UploadFileEvent(File(file.path)));
        }
      }
    } catch (_) {}
  }
}
