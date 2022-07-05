import 'package:admin/blocs/users_bloc.dart';
import 'package:admin/constants.dart';
import 'package:admin/models/my_user.dart';
import 'package:admin/screens/user_list/components/user_item_widget.dart';
import 'package:admin/utils/app_widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:paginate_firestore/paginate_firestore.dart';
import 'package:provider/provider.dart';


import '../../main.dart';

class UserListScreen extends StatelessWidget {
  static String tag = '/UserListScreen';

  @override
  Widget build(BuildContext context) {
    final UsersBloc ub = Provider.of<UsersBloc>(context, listen: false);
    return Scaffold(
      appBar: appBarWidget('Admins', showBack: false, elevation: 0.0),
      body: PaginateFirestore(
        itemBuilderType: PaginateBuilderType.listView,
        itemBuilder: (context, documentSnapshot, index) {
          final data1 = documentSnapshot[index].data() as Map?;
          MyUser data = MyUser.fromMap(documentSnapshot[index].data() as Map<String, dynamic>);

          return InkWell(
              onTap: (){
                print(data1!["NameSurname"]);
              },
              child: UserItemWidget(data));
        },
        shrinkWrap: true,
        padding: EdgeInsets.all(8),
        // orderBy is compulsory to enable pagination
        query: ub.getAdminList()!,
        itemsPerPage: DocLimit,
        bottomLoader: Loader(),
        initialLoader: Loader(),
        onEmpty: noDataWidget(),
        onError: (e) => Text(e.toString(), style: primaryTextStyle()).center(),
      ),
    ).cornerRadiusWithClipRRect(16);
  }
}
