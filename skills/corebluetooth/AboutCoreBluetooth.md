Title: About Core Bluetooth

URL Source: https://developer.apple.com/library/archive/documentation/NetworkingInternetWeb/Conceptual/CoreBluetooth_concepts/AboutCoreBluetooth/Introduction.html

Markdown Content:
About Core Bluetooth
===============
[](https://developer.apple.com/library/archive/documentation/NetworkingInternetWeb/Conceptual/CoreBluetooth_concepts/AboutCoreBluetooth/Introduction.html "About Core Bluetooth")

[Documentation Archive](https://developer.apple.com/library/archive/navigation/)[Developer](https://developer.apple.com/)

Search

Search Documentation Archive 

Core Bluetooth Programming Guide
================================

[PDF](https://developer.apple.com/library/archive/documentation/NetworkingInternetWeb/Conceptual/CoreBluetooth_concepts/AboutCoreBluetooth/Introduction.html "Download PDF")[Companion File](https://developer.apple.com/library/archive/documentation/NetworkingInternetWeb/Conceptual/CoreBluetooth_concepts/AboutCoreBluetooth/Introduction.html "Download Companion File")

*   Table of Contents

*   [Download Sample Code](https://developer.apple.com/library/archive/documentation/NetworkingInternetWeb/Conceptual/CoreBluetooth_concepts/AboutCoreBluetooth/Introduction.html)

[Next](https://developer.apple.com/library/archive/documentation/NetworkingInternetWeb/Conceptual/CoreBluetooth_concepts/CoreBluetoothOverview/CoreBluetoothOverview.html)

[](https://developer.apple.com/library/archive/documentation/NetworkingInternetWeb/Conceptual/CoreBluetooth_concepts/AboutCoreBluetooth/Introduction.html)[](https://developer.apple.com/library/archive/documentation/NetworkingInternetWeb/Conceptual/CoreBluetooth_concepts/index.html)[](https://developer.apple.com/library/archive/documentation/NetworkingInternetWeb/Conceptual/CoreBluetooth_concepts/AboutCoreBluetooth/Introduction.html "About Core Bluetooth")[](https://developer.apple.com/library/archive/documentation/NetworkingInternetWeb/Conceptual/CoreBluetooth_concepts/AboutCoreBluetooth/Introduction.html "About Core Bluetooth")
About Core Bluetooth
====================

[](https://developer.apple.com/library/archive/documentation/NetworkingInternetWeb/Conceptual/CoreBluetooth_concepts/AboutCoreBluetooth/Introduction.html)
The Core Bluetooth framework provides the classes needed for your iOS and Mac apps to communicate with devices that are equipped with Bluetooth low energy wireless technology. For example, your app can discover, explore, and interact with low energy peripheral devices, such as heart rate monitors and digital thermostats. As of macOS 10.9 and iOS 6, Mac and iOS devices can also function as Bluetooth low energy peripherals, serving data to other devices, including other Mac and iOS devices.

![Image 1: ../Art/CBTechnologyFramework_2x.png](https://developer.apple.com/library/archive/documentation/NetworkingInternetWeb/Conceptual/CoreBluetooth_concepts/Art/CBTechnologyFramework_2x.png)[](https://developer.apple.com/library/archive/documentation/NetworkingInternetWeb/Conceptual/CoreBluetooth_concepts/AboutCoreBluetooth/Introduction.html "At a Glance")
At a Glance
-----------

Bluetooth low energy wireless technology is based on the Bluetooth 4.0 specification, which, among other things, defines a set of protocols for communicating between low energy devices. The Core Bluetooth framework is an abstraction of the Bluetooth low energy protocol stack. That said, it hides many of the low-level details of the specification from you, the developer, making it much easier for you to develop apps that interact with Bluetooth low energy devices.

[](https://developer.apple.com/library/archive/documentation/NetworkingInternetWeb/Conceptual/CoreBluetooth_concepts/AboutCoreBluetooth/Introduction.html "Centrals and Peripherals Are the Key Players in Core Bluetooth")
### Centrals and Peripherals Are the Key Players in Core Bluetooth

In Bluetooth low energy communication, there are two key players: the central and the peripheral. Each player has a different role. A peripheral typically has data that is needed by other devices. A central typically uses the information served up by a peripheral to accomplish some task. For example, a digital thermostat equipped with Bluetooth low energy technology might provide the temperature of a room to an iOS app that then displays the temperature in a user-friendly way.

Each player performs a different set of tasks when carrying out its role. Peripherals make their presence known by advertising the data they have over the air. Centrals scan for nearby peripherals that might have data they’re interested in. When a central discovers such a peripheral, the central requests to connect to the peripheral and begins exploring and interacting with the peripheral’s data. The peripheral is responsible for responding to the central in appropriate ways.

[](https://developer.apple.com/library/archive/documentation/NetworkingInternetWeb/Conceptual/CoreBluetooth_concepts/AboutCoreBluetooth/Introduction.html "Relevant Chapters")
**Relevant Chapters:**[Core Bluetooth Overview](https://developer.apple.com/library/archive/documentation/NetworkingInternetWeb/Conceptual/CoreBluetooth_concepts/CoreBluetoothOverview/CoreBluetoothOverview.html#//apple_ref/doc/uid/TP40013257-CH2-SW1)

[](https://developer.apple.com/library/archive/documentation/NetworkingInternetWeb/Conceptual/CoreBluetooth_concepts/AboutCoreBluetooth/Introduction.html "Core Bluetooth Simplifies Common Bluetooth Tasks")
### Core Bluetooth Simplifies Common Bluetooth Tasks

The Core Bluetooth framework abstracts away the low-level details from the Bluetooth 4.0 specification. As a result, many of the common Bluetooth low energy tasks you need to implement in your app are simplified. If you are developing an app that implements the central role, Core Bluetooth makes it easy to discover and connect with a peripheral, and to explore and interact with the peripheral’s data. In addition, Core Bluetooth makes it easy to set up your local device to implement the peripheral role.

[](https://developer.apple.com/library/archive/documentation/NetworkingInternetWeb/Conceptual/CoreBluetooth_concepts/AboutCoreBluetooth/Introduction.html "Relevant Chapters")
**Relevant Chapters:**[Performing Common Central Role Tasks](https://developer.apple.com/library/archive/documentation/NetworkingInternetWeb/Conceptual/CoreBluetooth_concepts/PerformingCommonCentralRoleTasks/PerformingCommonCentralRoleTasks.html#//apple_ref/doc/uid/TP40013257-CH3-SW1), [Performing Common Peripheral Role Tasks](https://developer.apple.com/library/archive/documentation/NetworkingInternetWeb/Conceptual/CoreBluetooth_concepts/PerformingCommonPeripheralRoleTasks/PerformingCommonPeripheralRoleTasks.html#//apple_ref/doc/uid/TP40013257-CH4-SW1)

[](https://developer.apple.com/library/archive/documentation/NetworkingInternetWeb/Conceptual/CoreBluetooth_concepts/AboutCoreBluetooth/Introduction.html "iOS App States Affect Bluetooth Behavior")
### iOS App States Affect Bluetooth Behavior

When your iOS app is in the background or in a suspended state, its Bluetooth-related capabilities are affected. By default, your app is unable to perform Bluetooth low energy tasks while it is in the background or in a suspended state. That said, if your app needs to perform Bluetooth low energy tasks while in the background, you can declare it to support one or both of the Core Bluetooth background execution modes (there’s one for the central role, and one for the peripheral role). Even when you declare one or both of these background execution modes, certain Bluetooth tasks operate differently while your app is in the background. You want to take these differences into account when designing your app.

Even apps that support background processing may be terminated by the system at any time to free up memory for the current foreground app. As of iOS 7, Core Bluetooth supports saving state information for central and peripheral manager objects and restoring that state at app launch time. You can use this feature to support long-term actions involving Bluetooth devices.

[](https://developer.apple.com/library/archive/documentation/NetworkingInternetWeb/Conceptual/CoreBluetooth_concepts/AboutCoreBluetooth/Introduction.html "Relevant Chapters")
**Relevant Chapters:**[Core Bluetooth Background Processing for iOS Apps](https://developer.apple.com/library/archive/documentation/NetworkingInternetWeb/Conceptual/CoreBluetooth_concepts/CoreBluetoothBackgroundProcessingForIOSApps/PerformingTasksWhileYourAppIsInTheBackground.html#//apple_ref/doc/uid/TP40013257-CH7-SW1)

[](https://developer.apple.com/library/archive/documentation/NetworkingInternetWeb/Conceptual/CoreBluetooth_concepts/AboutCoreBluetooth/Introduction.html "Follow Best Practices to Enhance the User Experience")
### Follow Best Practices to Enhance the User Experience

The Core Bluetooth framework gives your app control over many of the common Bluetooth low energy transactions. Follow best practices to harness this level of control in a responsible way and enhance the user’s experience.

For example, many of the tasks you perform when implementing the central or the peripheral role use your device’s onboard radio to transmit signals over the air. Because your device’s radio is shared with other forms of wireless communication, and because radio usage has an adverse effect on a device’s battery life, always design your app to minimize how much it uses the radio.

[](https://developer.apple.com/library/archive/documentation/NetworkingInternetWeb/Conceptual/CoreBluetooth_concepts/AboutCoreBluetooth/Introduction.html "Relevant Chapters")
**Relevant Chapters:**[Best Practices for Interacting with a Remote Peripheral Device](https://developer.apple.com/library/archive/documentation/NetworkingInternetWeb/Conceptual/CoreBluetooth_concepts/BestPracticesForInteractingWithARemotePeripheralDevice/BestPracticesForInteractingWithARemotePeripheralDevice.html#//apple_ref/doc/uid/TP40013257-CH6-SW1), [Best Practices for Setting Up Your Local Device as a Peripheral](https://developer.apple.com/library/archive/documentation/NetworkingInternetWeb/Conceptual/CoreBluetooth_concepts/BestPracticesForSettingUpYourIOSDeviceAsAPeripheral/BestPracticesForSettingUpYourIOSDeviceAsAPeripheral.html#//apple_ref/doc/uid/TP40013257-CH5-SW1)

[](https://developer.apple.com/library/archive/documentation/NetworkingInternetWeb/Conceptual/CoreBluetooth_concepts/AboutCoreBluetooth/Introduction.html "How to Use This Document")
How to Use This Document
------------------------

If you have never used the Core Bluetooth framework, or if you are unfamiliar with basic Bluetooth low energy concepts, read this document in its entirety. In [Core Bluetooth Overview](https://developer.apple.com/library/archive/documentation/NetworkingInternetWeb/Conceptual/CoreBluetooth_concepts/CoreBluetoothOverview/CoreBluetoothOverview.html#//apple_ref/doc/uid/TP40013257-CH2-SW1), you learn the key terms and concepts that you need to know for the remainder of the book.

After you understand the key concepts, read [Performing Common Central Role Tasks](https://developer.apple.com/library/archive/documentation/NetworkingInternetWeb/Conceptual/CoreBluetooth_concepts/PerformingCommonCentralRoleTasks/PerformingCommonCentralRoleTasks.html#//apple_ref/doc/uid/TP40013257-CH3-SW1) to learn how to develop your app to implement the central role on your local device. Similarly, to learn how to develop your app to implement the peripheral role on your local device, read [Performing Common Peripheral Role Tasks](https://developer.apple.com/library/archive/documentation/NetworkingInternetWeb/Conceptual/CoreBluetooth_concepts/PerformingCommonPeripheralRoleTasks/PerformingCommonPeripheralRoleTasks.html#//apple_ref/doc/uid/TP40013257-CH4-SW1).

To ensure that your app is performing well and adhering to best practices, read the later chapters: [Core Bluetooth Background Processing for iOS Apps](https://developer.apple.com/library/archive/documentation/NetworkingInternetWeb/Conceptual/CoreBluetooth_concepts/CoreBluetoothBackgroundProcessingForIOSApps/PerformingTasksWhileYourAppIsInTheBackground.html#//apple_ref/doc/uid/TP40013257-CH7-SW1), [Best Practices for Interacting with a Remote Peripheral Device](https://developer.apple.com/library/archive/documentation/NetworkingInternetWeb/Conceptual/CoreBluetooth_concepts/BestPracticesForInteractingWithARemotePeripheralDevice/BestPracticesForInteractingWithARemotePeripheralDevice.html#//apple_ref/doc/uid/TP40013257-CH6-SW1), and [Best Practices for Setting Up Your Local Device as a Peripheral](https://developer.apple.com/library/archive/documentation/NetworkingInternetWeb/Conceptual/CoreBluetooth_concepts/BestPracticesForSettingUpYourIOSDeviceAsAPeripheral/BestPracticesForSettingUpYourIOSDeviceAsAPeripheral.html#//apple_ref/doc/uid/TP40013257-CH5-SW1).

[](https://developer.apple.com/library/archive/documentation/NetworkingInternetWeb/Conceptual/CoreBluetooth_concepts/AboutCoreBluetooth/Introduction.html "See Also")
See Also
--------

The official [Bluetooth Special Interest Group (SIG) website](http://www.bluetooth.org/) provides the definitive information about Bluetooth low energy wireless technology. There, you can also find the [Bluetooth 4.0 specification](https://www.bluetooth.org/en-us/specification/adopted-specifications).

If you are designing hardware accessories that use Bluetooth low energy technology to communicate with Apple products, including Mac, iPhone, iPad, and iPod touch models, read [Bluetooth Accessory Design Guidelines for Apple Products](https://developer.apple.com/hardwaredrivers/BluetoothDesignGuidelines.pdf). If your Bluetooth accessory (that connects to an iOS device through a Bluetooth low energy link) needs access to notifications that are generated on iOS devices, read _[Apple Notification Center Service (ANCS) Specification](https://developer.apple.com/library/archive/documentation/CoreBluetooth/Reference/AppleNotificationCenterServiceSpecification/Introduction/Introduction.html#//apple\_ref/doc/uid/TP40013460)_.

[Next](https://developer.apple.com/library/archive/documentation/NetworkingInternetWeb/Conceptual/CoreBluetooth_concepts/CoreBluetoothOverview/CoreBluetoothOverview.html)

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

