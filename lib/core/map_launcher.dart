
import 'package:url_launcher/url_launcher.dart';

class MapLauncher {
  static Future<void> openAt(double lat, double lng, {String? label}) async {
    final encoded = Uri.encodeComponent(label ?? 'Destination');
    final geoUri = Uri.parse('geo:$lat,$lng?q=$lat,$lng($encoded)');
    final webUri = Uri.parse('https://maps.google.com/?q=$lat,$lng($encoded)');
    if (await canLaunchUrl(geoUri)) {
      await launchUrl(geoUri, mode: LaunchMode.externalApplication);
    } else {
      await launchUrl(webUri, mode: LaunchMode.externalApplication);
    }
  }

  static Future<void> call(String phone) async {
    final tel = Uri.parse('tel:$phone');
    if (await canLaunchUrl(tel)) {
      await launchUrl(tel);
    }
  }
}
