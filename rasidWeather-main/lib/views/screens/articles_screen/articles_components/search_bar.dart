import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../common/constants/index.dart';
import '../../../../helper/router_helper.dart';


class SearchBar extends StatelessWidget {
  const SearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 10),
        height: 65,
        width: MediaQuery.of(context).size.width,
        child: Row(children: <Widget>[
          InkWell(
              child: CircleAvatar(
                  radius: 22,
                  backgroundColor: Colors.grey[400],
                  backgroundImage:
                      // !sb.isSignedIn
                      //     ?
                      const CachedNetworkImageProvider(Images.defaultAvatar)
                  // :
                  // CachedNetworkImageProvider(sb.currentUser!.imageUrl!)
                  ),
              onTap: () {
                RouterHelper.getDashboardRoute('profile');
                // nextScreen(context, ProfilePage());
              }),
          const SizedBox(width: 10),
          Expanded(
              child: InkWell(
                  child: Container(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      height: 40,
                      width: MediaQuery.of(context).size.width,
                      alignment: Alignment.centerRight,
                      decoration: BoxDecoration(
                          color: Theme.of(context).primaryColorLight,
                          border: Border.all(color: Colors.grey[400]!, width: 0.5),
                          borderRadius: BorderRadius.circular(40)),
                      child: Text('search news'.tr(),
                          style: TextStyle(color: Theme.of(context).secondaryHeaderColor, fontSize: 15, fontWeight: FontWeight.w500))),
                  onTap: () {
                    RouterHelper.getSearchRoute();
                  }))
        ]));
  }
}
