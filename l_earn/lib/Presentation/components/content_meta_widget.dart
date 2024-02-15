import 'package:flutter/material.dart';
import 'package:l_earn/DataLayer/Models/content_model.dart';
import 'package:l_earn/Presentation/components/my_price_container.dart';
import 'package:l_earn/utils/mixins.dart';

class ContentMetaWidget extends StatelessWidget with TimeParserMixin, PriceParserMixin{
  const ContentMetaWidget({
    super.key,
    required this.content
  });

  final Content content;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          // '',
          content.title,
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        
        //? ROW WITH PRICE, NUMBER OF READS/VIEWS, CHAPTERS, DATE
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          
          children: [
            MyPriceContainer(
                price: parsePrice(content.price.toString())),
            Expanded(
                child: Text(
                  
              '${content.students} ${content.type == 'book' ? 'read' : 'view'}${content.students == 1 ? '' : 's'} \u2022 ${content.type == 'book' ? content.articles : content.videos} ${content.articles == 1 || content.videos == 1 ? 'chapter' : 'chapters'} \u2022 ${calculateTimeDifference(content.dateCreated)} ago',
              textAlign: TextAlign.right,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(fontSize: 14),
            ))
          ],
        ),
      ],
    );
  }
}

