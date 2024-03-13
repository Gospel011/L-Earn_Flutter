import 'package:flutter/material.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:email_validator/email_validator.dart';

class MyCustomText extends StatelessWidget {
  const MyCustomText({super.key, required this.text, this.maxLines});
  final String text;
  final int? maxLines;

  Future<void> _launchUrl(String url, context) async {
    Uri uri = Uri.parse(url);

    print("Url is $uri with Scheme: ${uri.scheme}");

    if (EmailValidator.validate(url)) {
      uri = Uri.parse('mailto:$url');
    } else if (uri.scheme == '') {
      uri = Uri.parse('https://$url');
    }

    if (!(await launchUrl(uri))) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Can't open url")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return ExpandableText(
      text,
      maxLines: maxLines ?? 5,
      collapseOnTextTap: true,
      expandOnTextTap: true,
      expandText: "read more",
      onUrlTap: (url) {
        print("Url $url tapped");

        _launchUrl(url, context);
      },
      urlStyle: TextStyle(
        color: Colors.blue.shade600,
      ),
      linkStyle: TextStyle(
        color: Colors.black,
      ),
      hashtagStyle:
          const TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.bold),
      onHashtagTap: (value) {
        print("Hashtag $value tapped");
      },
      mentionStyle: const TextStyle(color: Colors.blue),
      onMentionTap: (value) {
        print("Mention: $value tapped");
      },
      collapseText: "",
    );
  }
}
