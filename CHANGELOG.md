# CHANGELOG

* `3.0.10` Release - [3.0.10](#3010)
* `3.0.00` Release - [3.0.00](#3000)
* `2.2.20` Release - [2.2.20](#2220)
* `2.2.10` Release - [2.2.10](#2210)
* `2.0.93` Release - [2.0.93](#2093)
* `2.0.82` Release - [2.0.82](#2082)
* `2.0.79` Release - [2.0.79](#2079)
* `0.73.x` Releases - [0.73.0](#0730)

## 3.1.000
#### Features
* `EMP-17037` Add support to pass subtitle and audio language when casting.

## 3.0.100
#### Features
* `EMP-17214` Update the cast library to support the latest `Google Cast iOS SDK 4.6.1`

## 3.0.000
#### Breaking Changes
* `EMP-15724` There are several breaking changes from the previous cast client sdk such as `CastEnvironment` , `playbackProperties` have been deprecated. Please check the * [`ChromeCast Integration`](https://github.com/EricssonBroadcastServices/iOSClientCast/blob/master/Documentation/chromecast-integration.md)  for more information

#### Features
* `EMP-15724` Upgrade Cast Sender to follow the new CAF Receiver requirements. 
* `EMP-15724` Add support for passing optional `adParameters` when casting. 


## 2.2.200
#### Features
* `EMP-15180` When subtitle parameter is not specified , pass `None` to the receiver so it will start the chrome cast playback without subtitles. 


## 2.2.100
#### Features
* `EMP-15028` Now the sender app can pass `language` that should be used for mediainfo in control bar.


## 2.2.000

#### Features
* `EMP-14933` Update the cast library to support the latest `Google Cast iOS SDK 4.5.0`

#### Changes
* `Enviornment` has been renamed to `CastEnvironment`

## 2.0.93

#### Changes
* submodules no longer added through ssh

#### Documentation
* Clarified use of `contentID` when preparing `GCKMediaInformation` before starting to casting.

## 2.0.82

#### Bug Fixes
* Fixed a parsing issue for the `VolumeChanged` event
* Improved resilience on error message parsing 

## 2.0.79

* Adopted new *Receiver 2.0* api.

## 0.73.0

* `EMP-10730` *ChromeCast* integration with the *EMP* specific receiver channel.
