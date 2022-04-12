enum SystemEvents { REQUEST, RESPONSE }

extension SystemEventsExtension on SystemEvents {
  get name {
    switch (this) {
      case SystemEvents.REQUEST:
        return 'REQUEST';
      case SystemEvents.RESPONSE:
        return 'RESPONSE';
    }
  }
}
