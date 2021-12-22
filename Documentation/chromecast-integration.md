## ChromeCast Integration
`Cast` serves as a **reference implementation** of a  `ChromeCast` sender interface for communicating with the *EMP* `Receiver`. Client applications should define their own custom sender library.

### Getting Started
*EMP ChromeCast layer*, `Cast` extends the default `GoogleCast` framework to work with the *EMP ChromeCast Receiver* and is fully compliant with the default version unless otherwise stated. The framework is not intended to be a replacement for *Google*s implementaion. Please have a look at the [`EMP ChromeCast Receiver`](https://github.com/EricssonBroadcastServices/cast-receiver) for in depth documentation.

`Cast` does not alter the general *ChromeCast* workflow as described by [`Google`](#https://developers.google.com/cast/) in any significant way.

### iOS Permissions Changes
With recent updates to iOS, the operating system will now enforce new restrictions and permissions that affect the Cast user experience. It will also affect how you build the Cast SDK into your app. For your app to maintain Cast functionality with the latest versions of iOS, you must make updates to handle these permissions changes.

`Cast`  library uses the Google Chrome cast sdk which requires Bluetooth® permissions.


Please follow the guidelines in this document to support the iOS version your app supports . 
[`Google Cast`](#https://developers.google.com/cast/docs/ios_sender/permissions_and_discovery)

### Sample Integration

Developers can find a sample implementation of the cast sdk here.  [`iOSClientSDKSampleApp`](https://github.com/EricssonBroadcastServices/iOSClientSDKSampleApp)


### Version 3.0
### Loading Media
Loading media onto the *receiver* requires *client applications* to supply several things. First of all, a valid `SessionToken` and an *Exposure* `Environment` is required as the *receiver* will perform an entitlements request prior to starting playback. Secondly, media identifiers in the form of *EMP asset Id*.

From the version 2.0 & onwards developers do not need to create `CastEnvironment`. They can directly pass the `customer` & `businessUnit` values as `CustomData` in to the cast receiver. 

```Swift
let customData = CustomData(customer: environment.customer, businessUnit: environment.businessUnit, locale: "fr").toJson
```

Then developers can create the `GCKMediaInformationBuilder` & assign the *EMP asset Id* value as `contentID` value.

```Swift
let mediaInfoBuilder = GCKMediaInformationBuilder()
mediaInfoBuilder.contentID = playable.assetId
```

Finally you need to assign the `SessionToken` value as the `GCKMediaLoadRequestDataBuilder.credentials` value to make an authenticated `GCKRequest`. 

```Swift
let mediaInfo = mediaInfoBuilder.build()
        
if let remoteMediaClient = session.remoteMediaClient {
            
   let mediaQueueItemBuilder = GCKMediaQueueItemBuilder()
   mediaQueueItemBuilder.mediaInformation = mediaInfo
   let mediaQueueItem = mediaQueueItemBuilder.build()
   let queueDataBuilder = GCKMediaQueueDataBuilder(queueType: .generic)
   queueDataBuilder.items = [mediaQueueItem]
   queueDataBuilder.repeatMode = remoteMediaClient.mediaStatus?.queueRepeatMode ?? .off
            
    

   let mediaLoadRequestDataBuilder = GCKMediaLoadRequestDataBuilder()
   mediaLoadRequestDataBuilder.credentials = "SessionToken"
   mediaLoadRequestDataBuilder.queueData = queueDataBuilder.build()
   mediaLoadRequestDataBuilder.customData = customData
            
   let request = remoteMediaClient.loadMedia(with: mediaLoadRequestDataBuilder.build())

}
```

#### Server-Side Ad Insertion (SSAI) when casting
if you are planning to use server side ads insertion & required to pass `adParameters` to the cast reciever, you can create `CastAdsOptions` & add it to the `CustomData`. 


```Swift
let adsOptions = CastAdsOptions(latitude: "18.000", longitude: "18.000", mute: true, consent: "consent", deviceMake: "deviceMake", ifa: "ifa", gdprOptin: true)
let customData = CustomData(customer: environment.customer, businessUnit: environment.businessUnit, adParameters: adsOptions).toJson
```

#### Integrate Primetime authentication when casting
if you are planning to use adobe primetime authentication & required to pass `Adobe Primetime Token` when casting, you can add it to the `CustomData` as well. 
```Swift
let customData = CustomData(customer: environment.customer, businessUnit: environment.businessUnit, adobePrimetimeToken: "base64EncodedToken").toJson
```

#### Add support for default cast subtitle & audio language
You can pass subtitle & audio language values when start casting by passing them in the `CustomData`. 

```Swift
let customData = CustomData(customer: environment.customer, businessUnit: environment.businessUnit, subtitleLanguage: "en", audioLanguage: "fr").toJson
```

### Version 2.2.00 or below


### Loading Media
Loading media onto the *receiver* requires *client applications* to supply several things. First of all, a valid `SessionToken` and an *Exposure* `Environment` is required as the *receiver* will perform an entitlements request prior to starting playback. Secondly, media identifiers in the form of *EMP asset Id* (and optionally a program id) for the asset in question.

```Swift
let environment = CastEnvironment(baseUrl: exposureBaseUrl,
customer: "someCustomer",
businessUnit: "someBusinessUnit",
sessionToken: validSessionToken)

let properties = PlaybackProperties(playFrom: "bookmark")
```

PlaybackProperties specify startTime behavior. The following options apply:

* `defaultBehaviour` (default) Start at beginning of the program if programId is included otherwise start at live edge
* `startTime` Start at a Unix startTime
* `beginning` Start at the beginning of the program
* `bookmark` Start at the bookmark returned by EMP backend. If there is no bookmark, it falls back to the defaultBehaviour

Finally, each load request may be complimented with `CustomData` that issues special instructions to the *receiver*.

```Swift
let assetPlayback = CustomData(environment: environment, assetId: "anAssetId", playbackProperties: properties)

// Old versions 
let vodPlayback = CustomData(environment: environment, assetId: "anAssetId", playbackProperties: properties)

let channelPlayback = CustomData(environment: environment, channelId: "aChannelId", playbackProperties: properties)

let programPlaybacl = CustomData(environment: environment, channelId: "aChannelId", programId: "aSpecificProgramId", playbackProperties: properties)
```

These include, but are not limited to:
* Audio and text language
* Start time manipulation
* Timeshift override
* Maximum bitrate selection
* Autoplay behavior
* Session shift configuration
* Language that can be used for mediainfo in control bar.

* When the subtitle parameter ( `textLanguage` ) is not specified , `Cast` will pass `None` to the receiver so it will start the chrome cast playback without the subtitles. 

The actual loading of the configured media is done through *API*s provided by *Google*. An initial set of metadata can be supplied before loading the media. This will show up on the *mini controller* and the *expanded controller*. Once the receiver has loaded the media, the metadata will be updated continuously. It is important to use the correct `contentID` when configuring the `GCKMediaInformation`.

* program playback: use `programId`
* channel playback: use `channelId`
* assets or vods: use `assetId`

Please consult the *Google* [docmentation](#https://developers.google.com/cast/docs/ios_sender_setup) for more information.



```Swift

let mediaInfoBuilder = GCKMediaInformationBuilder()
mediaInfoBuilder.contentID = contentId
mediaInfoBuilder.streamType = .none
mediaInfoBuilder.contentType = "video/mp4"
mediaInfoBuilder.metadata = nil
mediaInfoBuilder.streamDuration = 0
mediaInfoBuilder.mediaTracks = nil
mediaInfoBuilder.textTrackStyle = nil

let mediaInfo = mediaInfoBuilder.build()

let mediaLoadOptions = GCKMediaLoadOptions()

// Provide the custom data to the receiver.
mediaLoadOptions.customData = customData.toJson

GCKCastContext
    .sharedInstance()
    .sessionManager
    .currentCastSession
    .remoteMediaClient?
    .loadMedia(mediaInfo, with: mediaLoadOptions)
```

### Responding to Events
The *EMP Receiver* has been customized to publish several non-standard events. These can be listened to through by creating, registering and then observing `Channel`s.

A `Channel` is an `Cast` specific extension of the *Google* provided `GCKCastChannel` and governs the *sender*-to-*receiver* communication.


Embedded tracks are broadcasted to all connected senders when the tracks or the period change. *Client applications* should listen to the `onTracksUpdated` message and update *UI* accordingly.

```Swift
let channel = Channel()

channel.onTracksUpdated { tracksUpdated in
    // Update UI
}
```

`tracksUpdated` contains information about subtiles and audio along with information about the currently active track(s). Selecting a different track can be done by supplying the `Channel` with a `Track` struct.

```Swift
let englishSubs = tracksUpdated
    .subtitles
    .filter{ $0.language == "en" }
    .first

if let subs = englishSubs {
    channel.use(textTrack: subs)
}
```

Or by specifying the *2 letter code* for the desired language.

```Swift
channel.use(subtitle: "en")
```

The same proceedure applies for audio tracks.

Finally, it is possible to hide the subtitle track.

```Swift
channel.hideSubtitles()
```

A user who joins a session in progress may wish to receive updated status of the *ChromeCast* controls. This can be done by calling `pull()` which will force an `onTracksUpdated` event.

```Swift
channel.pull()
```

There is also several general information events detailing how the stream in question behaves. `onTimeshiftEnabled` for example indicates if timeline UI should be present or not.

```Swift
channel
    .onTimeshiftEnabled { timeshift in
        // Hide or show timeline in UI
    }
    .onVolumeChanged { volumeChanged in
        // Update the volume indicator
    }
    .onAutoplay { autoplay in
        // Indicates if playback during the cast session was started automatically
    }
```

The following methods declare event listeners that may be especially useful for managing *live* playback.

```Swift
channel
    .onEntitlementChange{ entitlement in
        // Indicages the playback session takes place under a new entitlement
    }
    .onStartTimeLive{ startTime in
        // Indicates the start time in *unix epoch* time for the current live stream.
    }
    .onProgramUpdated{ program in
        // The program changed, update relevant media metadata
    }
    .onIsLive { isLive in
        // Update "live now" indicators
    }
```

### Error Handling
Two event listeners declare events related to error handling. The first, `onSegmentMissing`, publishes information about seek cancellation due to missing segments. It can be useful to give users feedback when their intended seek failed.
Beyond that, errors will be broadcasted through the `onError` event.

```Swift
channel
    .onSegmentMissing{ segment in
        // Indicate the seek was cancelled due to missing segments
    }
    .onError{ error in
        // Handle or display the error in question
    }
```

Error handling revolves around three types of errors, `ReceiverError`, `SenderError` and `GCKError`. The former two are defined by `Cast` and the last one provided by *Google*.

`SenderError`s mostly deal with serialization and message translation stemming from the *sender*-to-*receiver* communication. Errors in this domain indicate issues with either the `Cast` framework or it's integration with the *EMP receiver*.

`ReceiverError`s come direcly from the *EMP receiver*. For more information with regards to debugging the receiver, please look at this [documentation](#https://github.com/EricssonBroadcastServices/chromecast-receiver-2/blob/documentation-comments/sdk/tutorials/chromecast.md).
Each `ReceiverError` has an associated `code` and `message`.

Finally, `GCKError` stem from `GoogleCast` framework. More information can be found [here](#https://developers.google.com/cast/docs/debugging)
