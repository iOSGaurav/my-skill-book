Title: Best Practices for Setting Up Your Local Device as a Peripheral

URL Source: https://developer.apple.com/library/archive/documentation/NetworkingInternetWeb/Conceptual/CoreBluetooth_concepts/BestPracticesForSettingUpYourIOSDeviceAsAPeripheral/BestPracticesForSettingUpYourIOSDeviceAsAPeripheral.html

Markdown Content:
Best Practices for Setting Up Your Local Device as a Peripheral
===============
[](https://developer.apple.com/library/archive/documentation/NetworkingInternetWeb/Conceptual/CoreBluetooth_concepts/BestPracticesForSettingUpYourIOSDeviceAsAPeripheral/BestPracticesForSettingUpYourIOSDeviceAsAPeripheral.html "Best Practices for Setting Up Your Local Device as a Peripheral")

[Documentation Archive](https://developer.apple.com/library/archive/navigation/)[Developer](https://developer.apple.com/)

Search

Search Documentation Archive 

Core Bluetooth Programming Guide
================================

[PDF](https://developer.apple.com/library/archive/documentation/NetworkingInternetWeb/Conceptual/CoreBluetooth_concepts/BestPracticesForSettingUpYourIOSDeviceAsAPeripheral/BestPracticesForSettingUpYourIOSDeviceAsAPeripheral.html "Download PDF")[Companion File](https://developer.apple.com/library/archive/documentation/NetworkingInternetWeb/Conceptual/CoreBluetooth_concepts/BestPracticesForSettingUpYourIOSDeviceAsAPeripheral/BestPracticesForSettingUpYourIOSDeviceAsAPeripheral.html "Download Companion File")

*   Table of Contents

*   [Download Sample Code](https://developer.apple.com/library/archive/documentation/NetworkingInternetWeb/Conceptual/CoreBluetooth_concepts/BestPracticesForSettingUpYourIOSDeviceAsAPeripheral/BestPracticesForSettingUpYourIOSDeviceAsAPeripheral.html)

[Next](https://developer.apple.com/library/archive/documentation/NetworkingInternetWeb/Conceptual/CoreBluetooth_concepts/RevisionHistory.html)[Previous](https://developer.apple.com/library/archive/documentation/NetworkingInternetWeb/Conceptual/CoreBluetooth_concepts/BestPracticesForInteractingWithARemotePeripheralDevice/BestPracticesForInteractingWithARemotePeripheralDevice.html)

[](https://developer.apple.com/library/archive/documentation/NetworkingInternetWeb/Conceptual/CoreBluetooth_concepts/BestPracticesForSettingUpYourIOSDeviceAsAPeripheral/BestPracticesForSettingUpYourIOSDeviceAsAPeripheral.html)[](https://developer.apple.com/library/archive/documentation/NetworkingInternetWeb/Conceptual/CoreBluetooth_concepts/index.html)[](https://developer.apple.com/library/archive/documentation/NetworkingInternetWeb/Conceptual/CoreBluetooth_concepts/BestPracticesForSettingUpYourIOSDeviceAsAPeripheral/BestPracticesForSettingUpYourIOSDeviceAsAPeripheral.html "Best Practices for Setting Up Your Local Device as a Peripheral")
Best Practices for Setting Up Your Local Device as a Peripheral
===============================================================

As with many central-side transactions, the Core Bluetooth framework give you control over implementing most aspects of the peripheral role. This chapter provides guidelines and best practices for harnessing this level of control in a responsible way.

[](https://developer.apple.com/library/archive/documentation/NetworkingInternetWeb/Conceptual/CoreBluetooth_concepts/BestPracticesForSettingUpYourIOSDeviceAsAPeripheral/BestPracticesForSettingUpYourIOSDeviceAsAPeripheral.html "Advertising Considerations")
Advertising Considerations
--------------------------

Advertising peripheral data is an important part of setting up your local device to implement the peripheral role. The following sections assist you in doing so in an appropriate way.

[](https://developer.apple.com/library/archive/documentation/NetworkingInternetWeb/Conceptual/CoreBluetooth_concepts/BestPracticesForSettingUpYourIOSDeviceAsAPeripheral/BestPracticesForSettingUpYourIOSDeviceAsAPeripheral.html "Respect the Limits of Advertising Data")
### Respect the Limits of Advertising Data

You advertise your peripheral’s data by passing in a dictionary of advertising data to the `startAdvertising:` method of the `CBPeripheralManager` class, as described in [Advertising Your Services](https://developer.apple.com/library/archive/documentation/NetworkingInternetWeb/Conceptual/CoreBluetooth_concepts/PerformingCommonPeripheralRoleTasks/PerformingCommonPeripheralRoleTasks.html#//apple_ref/doc/uid/TP40013257-CH4-SW5). When you create an advertising dictionary, keep in mind that there are limits to what, as well as how much, you can advertise.

Although advertising packets in general can hold a variety of information about the peripheral device, you may advertise only your device’s local name and the UUIDs of any services you want to advertise. That is, when you create your advertising dictionary, you may specify only the following two keys: `CBAdvertisementDataLocalNameKey` and `CBAdvertisementDataServiceUUIDsKey`. You receive an error if you specify any other keys.

There are also limits as to how much space you can use when advertising data. When your app is in the foreground, it can use up to 28 bytes of space in the initial advertisement data for any combination of the two supported advertising data keys. If this space is used up, there are an additional 10 bytes of space in the scan response that can be used only for the local name. Any service UUIDs that do not fit in the allotted space are added to a special “overflow” area; they can be discovered only by an iOS device that is explicitly scanning for them. While your app is in the background, the local name is not advertised and all service UUIDs are place in the overflow area.

[](https://developer.apple.com/library/archive/documentation/NetworkingInternetWeb/Conceptual/CoreBluetooth_concepts/BestPracticesForSettingUpYourIOSDeviceAsAPeripheral/BestPracticesForSettingUpYourIOSDeviceAsAPeripheral.html "Note")
**Note:**These sizes do not include the 2 bytes of header information that are required for each new data type. The exact format of advertising and response data is defined in the Bluetooth 4.0 specification, Volume 3, Part C, Section 11.

To help you stay within these space constraints, limit the service UUIDs you advertise to those that identify your primary services.

[](https://developer.apple.com/library/archive/documentation/NetworkingInternetWeb/Conceptual/CoreBluetooth_concepts/BestPracticesForSettingUpYourIOSDeviceAsAPeripheral/BestPracticesForSettingUpYourIOSDeviceAsAPeripheral.html "Advertise Data Only When You Need To")
### Advertise Data Only When You Need To

Since advertising peripheral data uses your local device’s radio (and thus your device’s battery), advertise only when you want other devices to connect to you. Once connected, these devices can explore and interact the peripheral’s data directly, without the need for any advertising packets. Therefore, to minimize radio usage, increase app performance, and preserve your device’s battery, stop advertising when it is no longer necessary to facilitate any intended Bluetooth low energy transaction. To stop advertising on your local peripheral, simply call the `stopAdvertising` method of the `CBPeripheralManager` class, like this:

[myPeripheralManager stopAdvertising];

[](https://developer.apple.com/library/archive/documentation/NetworkingInternetWeb/Conceptual/CoreBluetooth_concepts/BestPracticesForSettingUpYourIOSDeviceAsAPeripheral/BestPracticesForSettingUpYourIOSDeviceAsAPeripheral.html "Let the User Decide When to Advertise")
#### Let the User Decide When to Advertise

Knowing when to advertise is often something only the user can know. For example, it doesn’t make sense to have your app advertise services on your device when you know there aren’t any other Bluetooth low energy devices nearby. Since your app is often unaware of what other devices are nearby, provide in your app’s user interface (UI) a way for the user to decide when to advertise.

[](https://developer.apple.com/library/archive/documentation/NetworkingInternetWeb/Conceptual/CoreBluetooth_concepts/BestPracticesForSettingUpYourIOSDeviceAsAPeripheral/BestPracticesForSettingUpYourIOSDeviceAsAPeripheral.html "Configuring Your Characteristics")
Configuring Your Characteristics
--------------------------------

When you create a mutable characteristic, you set its properties, value, and permissions. These settings determine how connected centrals access and interact with the characteristic’s value. Although you may decide to configure the properties and permissions of your characteristics differently based on the needs of your app, the following sections provide some guidance when you need to perform the following two tasks:

*   Allow connected centrals to subscribe to your characteristics

*   Protect sensitive characteristic values from being accessed by unpaired centrals

[](https://developer.apple.com/library/archive/documentation/NetworkingInternetWeb/Conceptual/CoreBluetooth_concepts/BestPracticesForSettingUpYourIOSDeviceAsAPeripheral/BestPracticesForSettingUpYourIOSDeviceAsAPeripheral.html "Configure Your Characteristics to Support Notifications")
### Configure Your Characteristics to Support Notifications

As described in [Subscribe to Characteristic Values That Change Often](https://developer.apple.com/library/archive/documentation/NetworkingInternetWeb/Conceptual/CoreBluetooth_concepts/BestPracticesForInteractingWithARemotePeripheralDevice/BestPracticesForInteractingWithARemotePeripheralDevice.html#//apple_ref/doc/uid/TP40013257-CH6-SW7), it is recommended that centrals subscribe to characteristic values (of a remote peripheral’s service) that change often. When possible, encourage this practice by allowing connected centrals to subscribe to your characteristics’ values.

When you create a mutable characteristic, configure it to support subscriptions by setting the characteristic’s properties with the `CBCharacteristicPropertyNotify` constant, like this:

myCharacteristic = [[CBMutableCharacteristic alloc]
initWithType:myCharacteristicUUID
properties:CBCharacteristicPropertyRead | CBCharacteristicPropertyNotify
value:nil permissions:CBAttributePermissionsReadable];

In this example, the characteristic’s value is readable, and it can be subscribed to by a connected central.

[](https://developer.apple.com/library/archive/documentation/NetworkingInternetWeb/Conceptual/CoreBluetooth_concepts/BestPracticesForSettingUpYourIOSDeviceAsAPeripheral/BestPracticesForSettingUpYourIOSDeviceAsAPeripheral.html "Require a Paired Connection to Access Sensitive Data")
### Require a Paired Connection to Access Sensitive Data

Depending on the use case, you may want to vend a service that has one or more characteristic whose value needs to be secure. For example, imagine that you want to vend a social media profile service. This service may have characteristics whose values represent a member’s profile information, such as first name, last name, and email address. More than likely, you want to allow only trusted devices to retrieve a member’s email address.

You can ensure that only trusted devices have access to sensitive characteristic values by setting the appropriate characteristic properties and permissions. To continue the example above, to allow only trusted devices to retrieve a member’s email address, set the appropriate characteristic’s properties and permissions, like this:

emailCharacteristic = [[CBMutableCharacteristic alloc]
initWithType:emailCharacteristicUUID
properties:CBCharacteristicPropertyRead
| CBCharacteristicPropertyNotifyEncryptionRequired
value:nil permissions:CBAttributePermissionsReadEncryptionRequired];

In this example, the characteristic is configured to allow only trusted devices to read or subscribe to its value. When a connected, remote central tries to read or subscribe to this characteristic’s value, Core Bluetooth tries to pair your local peripheral with the central to create a secure connection.

For example, if the central and the peripheral are iOS devices, both devices receive an alert indicating that the other device would like to pair. The alert on the central device contains a code that you must enter into a text field on the peripheral device’s alert to complete the pairing process.

After the pairing process is complete, the peripheral considers the paired central a trusted device and allows the central access to its encrypted characteristic values.

[Next](https://developer.apple.com/library/archive/documentation/NetworkingInternetWeb/Conceptual/CoreBluetooth_concepts/RevisionHistory.html)[Previous](https://developer.apple.com/library/archive/documentation/NetworkingInternetWeb/Conceptual/CoreBluetooth_concepts/BestPracticesForInteractingWithARemotePeripheralDevice/BestPracticesForInteractingWithARemotePeripheralDevice.html)

* * *

Copyright © 2013 Apple Inc. All Rights Reserved. [Terms of Use](http://www.apple.com/legal/internet-services/terms/site.html) | [Privacy Policy](http://www.apple.com/privacy/) | Updated: 2013-09-18

Sending feedback…
-----------------

We’re sorry, an error has occurred.
-----------------------------------

Please try submitting your feedback later.

Thank you for providing feedback!
---------------------------------

Your input helps improve our developer documentation.

How helpful is this document?
-----------------------------

*

 Very helpful   Somewhat helpful   Not helpful  

How can we improve this document?
---------------------------------

- [x]  Fix typos or links  - [x]  Fix incorrect information  - [x]  Add or update code samples  - [x]  Add or update illustrations  - [x]  Add information about...  

*
_* Required information_

To submit a product bug or enhancement request, please visit the [Bug Reporter](https://developer.apple.com/bugreporter/) page.

Please read [Apple's Unsolicited Idea Submission Policy](http://www.apple.com/legal/policies/ideas.html) before you send us your feedback.