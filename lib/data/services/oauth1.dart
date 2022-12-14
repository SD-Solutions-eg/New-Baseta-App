// import 'dart:collection';
// import 'dart:convert';
// import 'dart:math';
//
// import 'package:crypto/crypto.dart' as crypto;
// import 'package:mabella/core/constants/app_config.dart' as config;
// import 'package:mabella/data/services/query_string.dart' as query_string;
//
// /// This Generates a valid OAuth 1.0 URL
// ///
// /// if [isHttps] is true we just return the URL with
// /// [consumerKey] and [consumerSecret] as query parameters
//
// String getOAuthURL(String requestMethod, String queryUrl) {
//   const consumerKey = config.consumerKey;
//   const consumerSecret = config.consumerSecret;
//
//   const String token = "";
//   final String url = queryUrl;
//   final bool containsQueryParams = url.contains("?");
//
//   final Random rand = Random();
//   final List<int> codeUnits = List.generate(10, (index) {
//     return rand.nextInt(26) + 97;
//   });
//
//   /// Random string uniquely generated to identify each signed request
//   final String nonce = String.fromCharCodes(codeUnits);
//
//   /// The timestamp allows the Service Provider to only keep nonce values for a limited time
//   final int timestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;
//
//   String parameters =
//       "oauth_consumer_key=$consumerKey&oauth_signature_method=HMAC-SHA1&oauth_timestamp=$timestamp&oauth_nonce=$nonce&oauth_version=1.0&";
//
//   if (containsQueryParams == true) {
//     parameters = parameters + url.split("?")[1];
//   } else {
//     parameters = parameters.substring(0, parameters.length - 1);
//   }
//
//   final Map<dynamic, dynamic> params = query_string.parse(parameters);
//   final Map<String, dynamic> treeMap = SplayTreeMap<String, dynamic>();
//   treeMap.addAll(params.cast());
//
//   String parameterString = "";
//
//   for (final key in treeMap.keys) {
//     // ignore: prefer_interpolation_to_compose_strings, use_string_buffers
//     parameterString =
//         "${"$parameterString${Uri.encodeQueryComponent(key)}=${treeMap[key]}"}&";
//   }
//
//   parameterString = parameterString.substring(0, parameterString.length - 1);
//
//   final String method = requestMethod;
//   final String baseString =
//       "$method&${Uri.encodeQueryComponent(containsQueryParams == true ? url.split("?")[0] : url)}&${Uri.encodeQueryComponent(parameterString)}";
//
//   const String signingKey = "$consumerSecret&$token";
//   final crypto.Hmac hmacSha1 =
//       crypto.Hmac(crypto.sha1, utf8.encode(signingKey)); // HMAC-SHA1
//
//   /// The Signature is used by the server to verify the
//   /// authenticity of the request and prevent unauthorized access.
//   /// Here we use HMAC-SHA1 method.
//   final crypto.Digest signature = hmacSha1.convert(utf8.encode(baseString));
//
//   final String finalSignature = base64Encode(signature.bytes);
//
//   String requestUrl = "";
//
//   if (containsQueryParams == true) {
//     requestUrl =
//         "${url.split("?")[0]}?$parameterString&oauth_signature=${Uri.encodeQueryComponent(finalSignature)}";
//   } else {
//     requestUrl =
//         "$url?$parameterString&oauth_signature=${Uri.encodeQueryComponent(finalSignature)}";
//   }
//
//   return requestUrl;
// }
