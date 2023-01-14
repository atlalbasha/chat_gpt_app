import 'package:chat_gpt_app/controller/api_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../model/chat_message.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';

class Home extends StatelessWidget {
  Home({super.key});
  ApiController apiController = Get.put(ApiController());
  @override
  Widget build(BuildContext context) {
    // apiController.fetchData('Hello World');
    return Scaffold(
      // backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        title: const Text('Chat GPT App'),
        leading: IconButton(
            icon: FaIcon(FontAwesomeIcons.eraser),
            onPressed: () {
              apiController.chatMessages.clear();
            }),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: LiteRollingSwitch(
              //initial value
              value: true,
              width: 90,
              textOff: 'Dark',
              textOn: 'Light',
              colorOn: Colors.deepOrange,
              colorOff: Colors.grey,
              textOnColor: Colors.white,
              iconOn: FontAwesomeIcons.lightbulb,
              iconOff: FontAwesomeIcons.moon,

              onChanged: (bool state) {
                state
                    ? Get.changeTheme(ThemeData.light())
                    : Get.changeTheme(ThemeData.dark());
              },
              onDoubleTap: () {},
              onSwipe: () {},
              onTap: () {},
            ),
          ),
        ],
      ),
      body: Obx(
        () => SafeArea(
          child: GestureDetector(
            onTap: (() => FocusScope.of(context).requestFocus(FocusNode())),
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    controller: apiController.scrollController,
                    itemCount: apiController.chatMessages.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 6),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            apiController.chatMessages[index].chatMessageType ==
                                    ChatMessageType.sender
                                ? Container(
                                    margin: const EdgeInsets.only(right: 8),
                                    child: const CircleAvatar(
                                      backgroundColor: Colors.blueAccent,
                                      child: FaIcon(FontAwesomeIcons.user,
                                          color: Colors.white),
                                    ),
                                  )
                                : Container(
                                    margin: const EdgeInsets.only(right: 8),
                                    child: const CircleAvatar(
                                      backgroundColor: Colors.green,
                                      child: FaIcon(FontAwesomeIcons.robot,
                                          color: Colors.white),
                                    ),
                                  ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.83,
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: apiController.chatMessages[index]
                                            .chatMessageType ==
                                        ChatMessageType.sender
                                    ? Colors.blueAccent
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                apiController.chatMessages[index].message,
                                style: TextStyle(
                                  color: apiController.chatMessages[index]
                                              .chatMessageType ==
                                          ChatMessageType.sender
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                  height: apiController.isLoading ? 80 : 64,
                  child: Column(
                    children: [
                      apiController.isLoading
                          ? Padding(
                              padding: EdgeInsets.all(8.0),
                              child: SpinKitThreeInOut(
                                itemBuilder: (context, index) => DecoratedBox(
                                  decoration: BoxDecoration(
                                    color: index.isEven
                                        ? Colors.blueGrey
                                        : Colors.deepOrange,
                                  ),
                                ),
                                size: 14,
                              ),
                            )
                          : const SizedBox(),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.blueGrey, // darker color
                                  ),
                                  BoxShadow(
                                    color: Colors.white70, // background color
                                    spreadRadius: 1,
                                    blurRadius: 1,
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  const SizedBox(width: 20),
                                  Expanded(
                                    child: TextField(
                                      minLines: 1,
                                      maxLines: 2,
                                      style: const TextStyle(
                                          color: Colors.blueAccent),
                                      keyboardType: TextInputType.multiline,
                                      textCapitalization:
                                          TextCapitalization.sentences,
                                      autocorrect: true,
                                      controller: apiController.textController,
                                      onSubmitted: (value) => apiController
                                          .fetchData(value.toString()),
                                      onChanged: (value) => apiController
                                          .message = value.toString(),
                                      decoration: const InputDecoration(
                                          hintText: "Type Something...",
                                          hintStyle: TextStyle(
                                              color: Colors.blueAccent),
                                          border: InputBorder.none),
                                    ),
                                  ),
                                  IconButton(
                                      icon: const Icon(Icons.send,
                                          color: Colors.blueAccent),
                                      onPressed: () {
                                        apiController.fetchData(
                                            apiController.message.toString());
                                      })
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
