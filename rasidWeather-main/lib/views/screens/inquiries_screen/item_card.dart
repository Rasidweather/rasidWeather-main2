import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../core/widgets/image_widget.dart';
import '../../../data/model/inquirie_model.dart';
import '../../../generated/assets.dart';
import '../../../utils/date_utils.dart';


class ItemCard extends StatelessWidget {
  const ItemCard({super.key, required this.inquiry});
  final InquiryModel inquiry;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(start: 10, end: 10),
      child: GestureDetector(
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(children: <Widget>[
              SizedBox(
                width: double.infinity,
                child: Text(
                  inquiry.message!,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: 10),
              Row(children: <Widget>[
                ImageView.svgAsset(Assets.svgCalender),
                const SizedBox(width: 5),
                Text(
                  dateTimeToTimeAgo(inquiry.updatedAt!),
                ),
                const Spacer(),
                if (inquiry.hasSupportReply ?? false)
                  Icon(
                    Icons.check,
                    size: 16,
                    color: Theme.of(context).primaryColor,
                  ),
                if (!(inquiry.hasSupportReply ?? false))
                   Text(
                    'inquiries.status.pending'.tr(),
                    style: const TextStyle(color: Colors.amberAccent),
                  ),
              ]),
            ]),
          ),
        ),
        onTap: () => <dynamic, dynamic>{
          // RouterHelper.getArticleDetailsRoute(article.id!, article: article)
        },
      ),
    );
  }
}
