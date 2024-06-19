import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:wave/controllers/Authentication/user_controller.dart';
import 'package:wave/controllers/PostController/create_post_controller.dart';
import 'package:wave/models/response_model.dart';
import 'package:wave/models/user_model.dart';
import 'package:wave/utils/constants/custom_colors.dart';
import 'package:wave/utils/constants/custom_fonts.dart';
import 'package:wave/utils/constants/custom_icons.dart';
import 'package:wave/utils/device_size.dart';
import 'package:wave/utils/enums.dart';
import 'package:wave/utils/routing.dart';

class CreatePostScreen extends StatefulWidget {
  CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  TextEditingController captionController = TextEditingController();

  final FocusNode focusNode = FocusNode();

  List<User> mentionedUsers = [];

  String searchQuery = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Create Post",
            style: TextStyle(
              fontFamily: CustomFont.poppins,
              fontSize: 16.5,
              letterSpacing: -0.1,
            ),
          ),
          centerTitle: true,
          elevation: 0,
          backgroundColor: CustomColor.primaryBackGround,
        ),
        backgroundColor: CustomColor.primaryBackGround,
        body: SafeArea(
          child: Consumer2<CreatePostController, UserDataController>(
            builder: (context, postController, userDataController, child) {
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12.0, vertical: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Placeholder for selected media files
                      // AddImageForPostBox(postController: postController),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 4),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                              color: CustomColor.authTextBoxBorderColor),
                          color: CustomColor.primaryBackGround,
                        ),
                        child: TextFormField(
                          maxLines: 6,
                          minLines: 3,
                          controller: captionController,
                          decoration: InputDecoration(
                              hintStyle: TextStyle(
                                  fontFamily: CustomFont.poppins,
                                  color: Colors.grey,
                                  fontSize: 14),
                              border: InputBorder.none,
                              errorText: captionController.text.isEmpty ? 'Caption cannot be empty' : null,
                              hintText: "What's happening?"),
                          onChanged: (text) {

                            setState(() {});
                          },
                        ),

                      ),
                      const SizedBox(
                        height: 15,
                      ),

                      Center(
                        child: SizedBox(
                          width: displayWidth(context) * 0.8,
                          child: MaterialButton(
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)),
                            height: displayHeight(context) * 0.06,
                            onPressed: captionController.text.isNotEmpty ? () async {
                              final res = await postController.createNewPost(
                                  userId:
                                      fb.FirebaseAuth.instance.currentUser!.uid,
                                  caption: captionController.text);
                              if (res.responseStatus) {
                                postController.resetController();
                                 Get.showSnackbar(const GetSnackBar(
                                  duration: Duration(seconds: 2),
                                  backgroundColor: Colors.green,
                                  borderRadius: 5,
                                  title: "Post Successfull!",
                                  message:
                                      "Post will be visible in a few minutes",
                                ));
                                StreamSubscription<CustomResponse>? sub;
                                sub = userDataController
                                    .updateProfile(
                                        newPostId: res.response.toString())
                                    .listen(
                                  (customRes) {
                                    if (customRes.responseStatus) {
                                      "Modified post list".printInfo();
                                    }
                                  },
                                  onDone: () {
                                    sub!.cancel();
                                  },
                                );

                              } else {
                                Get.showSnackbar(GetSnackBar(
                                  backgroundColor: CustomColor.errorColor,
                                  borderRadius: 5,
                                  duration: const Duration(seconds: 2),
                                  message: res.response.message.toString(),
                                ));
                              }
                            } :null,
                            color: CustomColor.primaryColor,
                            child: (postController.create_post ==
                                    CREATE_POST.CREATING)
                                ? const Center(
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                    ),
                                  )
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        CustomIcon.addPostIcon,
                                        height: 15,
                                        color: Colors.blueAccent,
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        "Create Post",
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontFamily: CustomFont.poppins,
                                            color: Colors.blue),
                                      ),
                                    ],
                                  ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ));
  }
}
