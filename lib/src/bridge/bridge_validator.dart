import '../utils/decoder.dart';
import '../types/system_events.dart';

class BridgeValidator {
  static SystemEvents? hasSystemEvent(String eventMessage) {
    var data = SystemEvents.values;

    for (SystemEvents ev in data) {
      if (eventMessage == Decoder.decodeEnum(ev)) return ev;
    }

    return null;
  }
}
