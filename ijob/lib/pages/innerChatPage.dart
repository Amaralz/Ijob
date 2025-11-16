import 'package:flutter/material.dart';
import 'package:ijob/Components/messageStream.dart';
import 'package:ijob/Components/newMessage.dart';
import 'package:ijob/Components/receiveRequestBubble.dart';
import 'package:ijob/Components/requestBubble.dart';
import 'package:ijob/Core/Entities/chat.dart';
import 'package:ijob/Core/Entities/profileUserList.dart';
import 'package:ijob/Core/Entities/requestMessage.dart';
import 'package:ijob/Core/Entities/servicer.dart';
import 'package:ijob/Core/Entities/servicerList.dart';
import 'package:ijob/Core/Entities/userRole.dart';
import 'package:ijob/Core/services/chat/requestMessageServices.dart';
import 'package:provider/provider.dart';

class Innerchatpage extends StatefulWidget {
  @override
  State<Innerchatpage> createState() => _InnerchatpageState();
}

class _InnerchatpageState extends State<Innerchatpage> {
  late Chat _chatInfo;
  bool _initizalized = false;
  late Future<Servicer?> _servicer;
  late Widget _stream;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_initizalized) {
      _chatInfo = ModalRoute.of(context)?.settings.arguments as Chat;

      Provider.of<Requestmessageservices>(
        context,
        listen: false,
      ).loadRequests(_chatInfo.id);

      _servicer = Provider.of<Servicerlist>(
        context,
        listen: false,
      ).getServicer(_chatInfo.servicerId);

      _stream = Messagestream(chat: _chatInfo);

      _initizalized = true;
    }
  }

  _showButton(bool checker, Requestmessage request) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton.icon(
        onPressed: checker
            ? null
            : () async {
                await _openResponseModal(context, request);
                if (mounted) FocusScope.of(context).unfocus();
              },
        label: Text("Solicitações", style: TextStyle(color: Colors.black)),
        icon: Icon(Icons.visibility, color: Colors.black),
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusGeometry.circular(10),
          ),
          backgroundColor: Theme.of(context).secondaryHeaderColor,
        ),
      ),
    );
  }

  _openRequestModal(
    BuildContext context,
    Chat chat,
    Userrole role,
    Servicer servicer,
  ) {
    final profiler = Provider.of<Profileuserlist>(
      context,
      listen: false,
    ).profile;

    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (_) {
        return Requestbubble(
          categor: servicer.category!,
          isServicer: role.isServicer,
          owner: profiler.nome! == chat.userName,
          servicerId: servicer.id!,
          chatId: chat.id,
        );
      },
    );
  }

  _openResponseModal(BuildContext context, Requestmessage request) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return Receiverequestbubble(request: request, chatId: _chatInfo.id);
      },
    );
  }

  @override
  void dispose() {
    Provider.of<Requestmessageservices>(context, listen: false).dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final role = Provider.of<Userrole>(context, listen: false);
    // TODO: implement build
    return FutureBuilder(
      future: _servicer,
      builder: (context, servicer) {
        if (servicer.connectionState == ConnectionState.waiting) {
          return Scaffold(body: Center(child: CircularProgressIndicator()));
        } else {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                role.isUsu ? servicer.data!.nome! : _chatInfo.userName,
                style: TextStyle(color: Theme.of(context).secondaryHeaderColor),
              ),
              actions: [
                Consumer<Requestmessageservices>(
                  builder: (context, requestService, child) {
                    final requests = requestService.requests;

                    return role.isUsu
                        ? requests.isEmpty
                              ? Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ElevatedButton.icon(
                                    onPressed: () async {
                                      await _openRequestModal(
                                        context,
                                        _chatInfo,
                                        role,
                                        servicer.data!,
                                      );
                                      if (mounted) {
                                        FocusScope.of(context).unfocus();
                                      }
                                    },
                                    label: Text(
                                      "Marcar",
                                      style: TextStyle(color: Colors.black),
                                    ),
                                    icon: Icon(
                                      Icons.view_timeline_outlined,
                                      color: Colors.black,
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadiusGeometry.circular(10),
                                      ),
                                      backgroundColor: Theme.of(
                                        context,
                                      ).secondaryHeaderColor,
                                    ),
                                  ),
                                )
                              : _showButton(requests.isEmpty, requests[0])
                        : Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton.icon(
                              onPressed: requests.isEmpty
                                  ? null
                                  : () async {
                                      await _openResponseModal(
                                        context,
                                        requests[0],
                                      );

                                      if (mounted) {
                                        FocusScope.of(context).unfocus();
                                      }
                                    },
                              label: Text(
                                "Solicitações",
                                style: TextStyle(color: Colors.black),
                              ),
                              icon: Icon(Icons.visibility, color: Colors.black),
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadiusGeometry.circular(
                                    10,
                                  ),
                                ),
                                backgroundColor: Theme.of(
                                  context,
                                ).secondaryHeaderColor,
                              ),
                            ),
                          );
                  },
                ),
              ],
            ),
            body: Column(
              children: [
                Expanded(child: Center(child: _stream)),
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: Newmessage(chat: _chatInfo),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
