# Upgrade Guide

## 0.73.0 to 2.0.79

The `Cast` reference implementation has been updated to the new *Receiver 2.0* [api](https://github.com/EricssonBroadcastServices/chromecast-receiver-2). Please consult the [receiver documentation](https://github.com/EricssonBroadcastServices/chromecast-receiver-2/blob/master/sdk/tutorials/chromecast.md), [receiver upgrade guide](https://github.com/EricssonBroadcastServices/chromecast-receiver-2/blob/master/sdk/tutorials/upgrade-guide.md) and the [sender documentation](https://github.com/EricssonBroadcastServices/iOSClientCast/blob/master/Documentation/chromecast-integration.md) for more information.

### API Changes

#### Channel

| reason | api |
| -------- | --- |
| deprecated | `func onDurationChanged(callback: @escaping (Float) -> Void) -> Channel` |
| deprecated | `func onProgramChanged(callback: @escaping (String) -> Void) -> Channel` |
| deprecated | `func refreshControls()` |

#### CustomData

| reason | api |
| -------- | --- |
| deprecated | `let startTime: Int64?` |
| deprecated | `let absoluteStartTime: Int64?` |
| deprecated | `let useLastViewedOffset: Bool?` |

## Adopting 0.73.0
Please consult the [Installation](https://github.com/EricssonBroadcastServices/iOSClientCast/blob/master/README.md#installation) and [Usage](https://github.com/EricssonBroadcastServices/iOSClientCast/blob/master/README.md#getting-started) guides for information about this initial release.
