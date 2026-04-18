
class ConfigModel {

  ConfigModel({
    this.websiteName,
    this.websiteBio,
    this.appVersion,
    this.appVersionTitle,
    this.websiteLogo,
    this.websiteWideLogo,
    this.websiteIcon,
    this.websiteIconBase64,
    this.websiteCover,
    this.address,
    this.mainColor,
    this.hoverColor,
    this.dashboardDarkMode,
    this.contactEmail,
    this.phone,
    this.phone2,
    this.whatsappPhone,
    this.facebookLink,
    this.telegramLink,
    this.whatsappLink,
    this.twitterLink,
    this.instagramLink,
    this.youtubeLink,
    this.tiktokLink,
    this.upworkLink,
    this.linkedinLink,
    this.githubLink,
    this.anotherLink1,
    this.anotherLink2,
    this.anotherLink3,
    this.contactPage,
    this.headerCode,
    this.footerCode,
    this.robotsTxt,
    this.appVersionMsg,
    this.appVersionLink,
    this.appVersionIsMandatory,
    this.autoCommentApprova,
    this.adsCode,
    this.getWebsiteLogo,
    this.getWebsiteCover,
    this.getWebsiteWideLogo,
    this.getWebsiteIcon,
    this.pages,
  });

  factory ConfigModel.fromJson(Map<String, dynamic> json) => ConfigModel(
    websiteName: json['website_name'].toString(),
    websiteBio: json['website_bio'].toString(),
    appVersion: json['app_version'].toString(),
    appVersionTitle: json['app_version_title'].toString(),
    websiteLogo: json['website_logo'].toString(),
    websiteWideLogo: json['website_wide_logo'].toString(),
    websiteIcon: json['website_icon'].toString(),
    websiteIconBase64: json['website_icon_base64'].toString(),
    websiteCover: json['website_cover'].toString(),
    address: json['address'].toString(),
    mainColor: json['main_color'].toString(),
    hoverColor: json['hover_color'].toString(),
    dashboardDarkMode: json['dashboard_dark_mode'].toString(),
    contactEmail: json['contact_email'].toString(),
    phone: json['phone'].toString(),
    phone2: json['phone2'].toString(),
    whatsappPhone: json['whatsapp_phone'].toString(),
    facebookLink: json['facebook_link'].toString(),
    telegramLink: json['telegram_link'].toString(),
    whatsappLink: json['whatsapp_link'].toString(),
    twitterLink: json['twitter_link'].toString(),
    instagramLink: json['instagram_link'].toString(),
    youtubeLink: json['youtube_link'].toString(),
    tiktokLink: json['tiktok_link'].toString(),
    upworkLink: json['upwork_link'].toString(),
    linkedinLink: json['linkedin_link'].toString(),
    githubLink: json['github_link'].toString(),
    anotherLink1: json['another_link1'].toString(),
    anotherLink2: json['another_link2'].toString(),
    anotherLink3: json['another_link3'].toString(),
    contactPage: json['contact_page'].toString(),
    headerCode: json['header_code'].toString(),
    footerCode: json['footer_code'].toString(),
    robotsTxt: json['robots_txt'].toString(),
    appVersionMsg: json['app_version_msg'].toString(),
    appVersionLink: json['app_version_link'].toString(),
    appVersionIsMandatory: json['app_version_is_mandatory'].toString(),
    autoCommentApprova: json['auto_comment_approva'].toString(),
    adsCode: json['ads_code'].toString(),
    getWebsiteLogo: json['get_website_logo'].toString(),
    getWebsiteCover: json['get_website_cover'].toString(),
    getWebsiteWideLogo: json['get_website_wide_logo'].toString(),
    getWebsiteIcon: json['get_website_icon'].toString(),
    pages: json['pages'] == null ? <Page>[] : List<Page>.from((json['pages'] as Iterable).map((x) => Page.fromJson(x as Map<String,dynamic>))),
  );
  final String? websiteName;
  final String? websiteBio;
  final String? appVersion;
  final String? appVersionTitle;
  final String? websiteLogo;
  final String? websiteWideLogo;
  final String? websiteIcon;
  final String? websiteIconBase64;
  final String? websiteCover;
  final String? address;
  final String? mainColor;
  final String? hoverColor;
  final String? dashboardDarkMode;
  final String? contactEmail;
  final String? phone;
  final String? phone2;
  final String? whatsappPhone;
  final String? facebookLink;
  final String? telegramLink;
  final String? whatsappLink;
  final String? twitterLink;
  final String? instagramLink;
  final String? youtubeLink;
  final String? tiktokLink;
  final String? upworkLink;
  final String? linkedinLink;
  final String? githubLink;
  final String? anotherLink1;
  final String? anotherLink2;
  final String? anotherLink3;
  final String? contactPage;
  final String? headerCode;
  final String? footerCode;
  final String? robotsTxt;
  final String? appVersionMsg;
  final String? appVersionLink;
  final String? appVersionIsMandatory;
  final String? autoCommentApprova;
  final String? adsCode;
  final String? getWebsiteLogo;
  final String? getWebsiteCover;
  final String? getWebsiteWideLogo;
  final String? getWebsiteIcon;
  final List<Page>? pages;

  Map<String, dynamic> toJson() => <String, dynamic>{
    'website_name': websiteName,
    'website_bio': websiteBio,
    'app_version': appVersion,
    'app_version_title': appVersionTitle,
    'website_logo': websiteLogo,
    'website_wide_logo': websiteWideLogo,
    'website_icon': websiteIcon,
    'website_icon_base64': websiteIconBase64,
    'website_cover': websiteCover,
    'address': address,
    'main_color': mainColor,
    'hover_color': hoverColor,
    'dashboard_dark_mode': dashboardDarkMode,
    'contact_email': contactEmail,
    'phone': phone,
    'phone2': phone2,
    'whatsapp_phone': whatsappPhone,
    'facebook_link': facebookLink,
    'telegram_link': telegramLink,
    'whatsapp_link': whatsappLink,
    'twitter_link': twitterLink,
    'instagram_link': instagramLink,
    'youtube_link': youtubeLink,
    'tiktok_link': tiktokLink,
    'upwork_link': upworkLink,
    'linkedin_link': linkedinLink,
    'github_link': githubLink,
    'another_link1': anotherLink1,
    'another_link2': anotherLink2,
    'another_link3': anotherLink3,
    'contact_page': contactPage,
    'header_code': headerCode,
    'footer_code': footerCode,
    'robots_txt': robotsTxt,
    'app_version_msg': appVersionMsg,
    'app_version_link': appVersionLink,
    'app_version_is_mandatory': appVersionIsMandatory,
    'auto_comment_approva': autoCommentApprova,
    'ads_code': adsCode,
    'get_website_logo': getWebsiteLogo,
    'get_website_cover': getWebsiteCover,
    'get_website_wide_logo': getWebsiteWideLogo,
    'get_website_icon': getWebsiteIcon,
    'pages': pages == null ? <Page>[] : List<dynamic>.from(pages!.map((Page x) => x.toJson())),
  };
}

class Page {

  Page({
    this.id,
    this.userId,
    this.title,
    this.titleEn,
    this.slug,
    this.image,
    this.description,
    this.metaDescription,
    this.removable,
    this.createdAt,
    this.updatedAt,
    this.url,
  });

  factory Page.fromJson(Map<String, dynamic> json) => Page(
    id: json['id'].toString(),
    userId: json['user_id'].toString(),
    title: json['title'].toString(),
    titleEn: json['title_en'].toString(),
    slug: json['slug'].toString(),
    image: json['image'].toString(),
    description: json['description'].toString(),
    metaDescription: json['meta_description'].toString(),
    removable: json['removable'].toString(),
    createdAt: json['created_at'] == null ? null : DateTime.parse(json['created_at'].toString()),
    updatedAt: json['updated_at'] == null ? null : DateTime.parse(json['updated_at'].toString()),
    url: json['url'].toString(),
  );
  final String? id;
  final String? userId;
  final String? title;
  final String? titleEn;
  final String? slug;
  final String? image;
  final String? description;
  final String? metaDescription;
  final String? removable;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? url;

  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': id,
    'user_id': userId,
    'title': title,
    'title_en': titleEn,
    'slug': slug,
    'image': image,
    'description': description,
    'meta_description': metaDescription,
    'removable': removable,
    'created_at': createdAt?.toIso8601String(),
    'updated_at': updatedAt?.toIso8601String(),
    'url': url,
  };
}
