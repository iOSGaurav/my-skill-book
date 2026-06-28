Title: Core Bluetooth Overview

URL Source: https://developer.apple.com/library/archive/documentation/NetworkingInternetWeb/Conceptual/CoreBluetooth_concepts/CoreBluetoothOverview/CoreBluetoothOverview.html

Markdown Content:
Core Bluetooth Overview
===============
[](https://developer.apple.com/library/archive/documentation/NetworkingInternetWeb/Conceptual/CoreBluetooth_concepts/CoreBluetoothOverview/CoreBluetoothOverview.html "Core Bluetooth Overview")

[Documentation Archive](https://developer.apple.com/library/archive/navigation/)[Developer](https://developer.apple.com/)

Search

Search Documentation Archive 

Core Bluetooth Programming Guide
================================

[PDF](https://developer.apple.com/library/archive/documentation/NetworkingInternetWeb/Conceptual/CoreBluetooth_concepts/CoreBluetoothOverview/CoreBluetoothOverview.html "Download PDF")[Companion File](https://developer.apple.com/library/archive/documentation/NetworkingInternetWeb/Conceptual/CoreBluetooth_concepts/CoreBluetoothOverview/CoreBluetoothOverview.html "Download Companion File")

*   Table of Contents

*   [Download Sample Code](https://developer.apple.com/library/archive/documentation/NetworkingInternetWeb/Conceptual/CoreBluetooth_concepts/CoreBluetoothOverview/CoreBluetoothOverview.html)

[Next](https://developer.apple.com/library/archive/documentation/NetworkingInternetWeb/Conceptual/CoreBluetooth_concepts/PerformingCommonCentralRoleTasks/PerformingCommonCentralRoleTasks.html)[Previous](https://developer.apple.com/library/archive/documentation/NetworkingInternetWeb/Conceptual/CoreBluetooth_concepts/AboutCoreBluetooth/Introduction.html)

[](https://developer.apple.com/library/archive/documentation/NetworkingInternetWeb/Conceptual/CoreBluetooth_concepts/CoreBluetoothOverview/CoreBluetoothOverview.html)[](https://developer.apple.com/library/archive/documentation/NetworkingInternetWeb/Conceptual/CoreBluetooth_concepts/index.html)[](https://developer.apple.com/library/archive/documentation/NetworkingInternetWeb/Conceptual/CoreBluetooth_concepts/CoreBluetoothOverview/CoreBluetoothOverview.html "Core Bluetooth Overview")
Core Bluetooth Overview
=======================

The Core Bluetooth framework lets your iOS and Mac apps communicate with Bluetooth low energy devices. For example, your app can discover, explore, and interact with low energy peripheral devices, such as heart rate monitors, digital thermostats, and even other iOS devices.

The framework is an abstraction of the Bluetooth 4.0 specification for use with low energy devices. That said, it hides many of the low-level details of the specification from you, the developer, making it much easier for you to develop apps that interact with Bluetooth low energy devices. Because the framework is based on the specification, some concepts and terminology from the specification have been adopted. This chapter introduces you to the key terms and concepts that you need to know to begin developing great apps using the Core Bluetooth framework.

[](https://developer.apple.com/library/archive/documentation/NetworkingInternetWeb/Conceptual/CoreBluetooth_concepts/CoreBluetoothOverview/CoreBluetoothOverview.html "Important")
**Important:**An iOS app linked on or after iOS 10.0 must include in its `Info.plist` file the usage description keys for the types of data it needs to access or it will crash. To access Bluetooth peripheral data specifically, it must include [NSBluetoothPeripheralUsageDescription](https://developer.apple.com/library/archive/documentation/General/Reference/InfoPlistKeyReference/Articles/CocoaKeys.html#//apple_ref/doc/uid/TP40009251-SW20).

[](https://developer.apple.com/library/archive/documentation/NetworkingInternetWeb/Conceptual/CoreBluetooth_concepts/CoreBluetoothOverview/CoreBluetoothOverview.html "Central and Peripheral Devices and Their Roles in Bluetooth Communication")
Central and Peripheral Devices and Their Roles in Bluetooth Communication
-------------------------------------------------------------------------

There are two major players involved in all Bluetooth low energy communication: the central and the peripheral. Based on a somewhat traditional client-server architecture, a _peripheral_ typically has data that is needed by other devices. A _central_ typically uses the information served up by peripherals to accomplish some particular task. As Figure 1-1 shows, for example, a heart rate monitor may have useful information that your Mac or iOS app may need in order to display the user’s heart rate in a user-friendly way.

[](https://developer.apple.com/library/archive/documentation/NetworkingInternetWeb/Conceptual/CoreBluetooth_concepts/CoreBluetoothOverview/CoreBluetoothOverview.html "Figure 1-1Central and peripheral devices")

**Figure 1-1**Central and peripheral devices

![Image 1](https://developer.apple.com/library/archive/documentation/NetworkingInternetWeb/Conceptual/CoreBluetooth_concepts/Art/CBDevices1_2x.png)[](https://developer.apple.com/library/archive/documentation/NetworkingInternetWeb/Conceptual/CoreBluetooth_concepts/CoreBluetoothOverview/CoreBluetoothOverview.html "Centrals Discover and Connect to Peripherals That Are Advertising")
### Centrals Discover and Connect to Peripherals That Are Advertising

Peripherals broadcast some of the data they have in the form of advertising packets. An _advertising packet_ is a relatively small bundle of data that may contain useful information about what a peripheral has to offer, such as the peripheral’s name and primary functionality. For instance, a digital thermostat may advertise that it provides the current temperature of a room. In Bluetooth low energy, advertising is the primary way that peripherals make their presence known.

A central, on the other hand, can scan and listen for any peripheral device that is advertising information that it’s interested in, as shown in Figure 1-2. A central can ask to connect to any peripheral that it has discovered advertising.

[](https://developer.apple.com/library/archive/documentation/NetworkingInternetWeb/Conceptual/CoreBluetooth_concepts/CoreBluetoothOverview/CoreBluetoothOverview.html "Figure 1-2Advertising and discovery")

**Figure 1-2**Advertising and discovery

![Image 2](https://developer.apple.com/library/archive/documentation/NetworkingInternetWeb/Conceptual/CoreBluetooth_concepts/Art/AdvertisingAndDiscovery_2x.png)[](https://developer.apple.com/library/archive/documentation/NetworkingInternetWeb/Conceptual/CoreBluetooth_concepts/CoreBluetoothOverview/CoreBluetoothOverview.html "How the Data of a Peripheral Is Structured")
### How the Data of a Peripheral Is Structured

The purpose of connecting to a peripheral is to begin exploring and interacting with the data it has to offer. Before you can do this, however, it helps to understand how the data of a peripheral is structured.

Peripherals may contain one or more services or provide useful information about their connected signal strength. A _service_ is a collection of data and associated behaviors for accomplishing a function or feature of a device (or portions of that device). For example, one service of a heart rate monitor may be to expose heart rate data from the monitor’s heart rate sensor.

Services themselves are made up of either characteristics or included services (that is, references to other services). A _characteristic_ provides further details about a peripheral’s service. For example, the heart rate service just described may contain one characteristic that describes the intended body location of the device’s heart rate sensor and another characteristic that transmits heart rate measurement data. Figure 1-3 illustrates one possible structure of a heart rate monitor’s service and characteristics.

[](https://developer.apple.com/library/archive/documentation/NetworkingInternetWeb/Conceptual/CoreBluetooth_concepts/CoreBluetoothOverview/CoreBluetoothOverview.html "Figure 1-3A peripheral’s service and characteristics")

**Figure 1-3**A peripheral’s service and characteristics

![Image 3](https://developer.apple.com/library/archive/documentation/NetworkingInternetWeb/Conceptual/CoreBluetooth_concepts/Art/CBPeripheralData_Example_2x.png)[](https://developer.apple.com/library/archive/documentation/NetworkingInternetWeb/Conceptual/CoreBluetooth_concepts/CoreBluetoothOverview/CoreBluetoothOverview.html "Centrals Explore and Interact with the Data on a Peripheral")
### Centrals Explore and Interact with the Data on a Peripheral

After a central has successfully established a connection to a peripheral, it can discover the full range of services and characteristics the peripheral has to offer (advertising data might contain only a fraction of the available services).

A central can also interact with a peripheral’s service by reading or writing the value of that service’s characteristic. For example, your app may request the current room temperature from a digital thermostat, or it may provide the thermostat with a value at which to set the room’s temperature.

[](https://developer.apple.com/library/archive/documentation/NetworkingInternetWeb/Conceptual/CoreBluetooth_concepts/CoreBluetoothOverview/CoreBluetoothOverview.html "How Centrals, Peripherals, and Peripheral Data Are Represented")
How Centrals, Peripherals, and Peripheral Data Are Represented
--------------------------------------------------------------

The major players and data involved in Bluetooth low energy communication are mapped onto the Core Bluetooth framework in a simple, straightforward way.

[](https://developer.apple.com/library/archive/documentation/NetworkingInternetWeb/Conceptual/CoreBluetooth_concepts/CoreBluetoothOverview/CoreBluetoothOverview.html "Objects on the Central Side")
### Objects on the Central Side

When you are using a local central to interact with a remote peripheral, you are performing actions on the central side of Bluetooth low energy communication. Unless you are setting up a local peripheral device—and using it to respond to requests by a central—most of your Bluetooth transactions will take place on the central side.

For information about how to implement the central role in your app, see [Performing Common Central Role Tasks](https://developer.apple.com/library/archive/documentation/NetworkingInternetWeb/Conceptual/CoreBluetooth_concepts/PerformingCommonCentralRoleTasks/PerformingCommonCentralRoleTasks.html#//apple_ref/doc/uid/TP40013257-CH3-SW1) and [Best Practices for Interacting with a Remote Peripheral Device](https://developer.apple.com/library/archive/documentation/NetworkingInternetWeb/Conceptual/CoreBluetooth_concepts/BestPracticesForInteractingWithARemotePeripheralDevice/BestPracticesForInteractingWithARemotePeripheralDevice.html#//apple_ref/doc/uid/TP40013257-CH6-SW1)

[](https://developer.apple.com/library/archive/documentation/NetworkingInternetWeb/Conceptual/CoreBluetooth_concepts/CoreBluetoothOverview/CoreBluetoothOverview.html "Local Centrals and Remote Peripherals")
#### Local Centrals and Remote Peripherals

On the central side, a local central device is represented by a `CBCentralManager` object. These objects are used to manage discovered or connected remote peripheral devices (represented by `CBPeripheral` objects), including scanning for, discovering, and connecting to advertising peripherals. Figure 1-4 shows how local centrals and remote peripherals are represented in the Core Bluetooth framework.

[](https://developer.apple.com/library/archive/documentation/NetworkingInternetWeb/Conceptual/CoreBluetooth_concepts/CoreBluetoothOverview/CoreBluetoothOverview.html "Figure 1-4Core Bluetooth objects on the central side")

**Figure 1-4**Core Bluetooth objects on the central side

![Image 4](https://developer.apple.com/library/archive/documentation/NetworkingInternetWeb/Conceptual/CoreBluetooth_concepts/Art/CBObjects_CentralSide_2x.png)[](https://developer.apple.com/library/archive/documentation/NetworkingInternetWeb/Conceptual/CoreBluetooth_concepts/CoreBluetoothOverview/CoreBluetoothOverview.html "A Remote Peripheral’s Data Are Represented by CBService and CBCharacteristic Objects")
#### A Remote Peripheral’s Data Are Represented by CBService and CBCharacteristic Objects

When you are interacting with the data on a remote peripheral (represented by a `CBPeripheral` object), you are dealing with its services and characteristics. In the Core Bluetooth framework, the services of a remote peripheral are represented by `CBService` objects. Similarly, the characteristics of a remote peripheral’s service are represented by `CBCharacteristic` objects. Figure 1-5 illustrates the basic structure of a remote peripheral’s services and characteristics.

[](https://developer.apple.com/library/archive/documentation/NetworkingInternetWeb/Conceptual/CoreBluetooth_concepts/CoreBluetoothOverview/CoreBluetoothOverview.html "Figure 1-5A remote peripheral’s tree of services and characteristics")

**Figure 1-5**A remote peripheral’s tree of services and characteristics

![Image 5](https://developer.apple.com/library/archive/documentation/NetworkingInternetWeb/Conceptual/CoreBluetooth_concepts/Art/TreeOfServicesAndCharacteristics_Remote_2x.png)[](https://developer.apple.com/library/archive/documentation/NetworkingInternetWeb/Conceptual/CoreBluetooth_concepts/CoreBluetoothOverview/CoreBluetoothOverview.html "Objects on the Peripheral Side")
### Objects on the Peripheral Side

As of macOS 10.9 and iOS 6, Mac and iOS devices can function as Bluetooth low energy peripherals, serving data to other devices, including other Mac, iPhone, and iPad devices. When setting up your device to implement the peripheral role, you are performing actions on the peripheral side of Bluetooth low energy communication.

[](https://developer.apple.com/library/archive/documentation/NetworkingInternetWeb/Conceptual/CoreBluetooth_concepts/CoreBluetoothOverview/CoreBluetoothOverview.html "Local Peripherals and Remote Centrals")
#### Local Peripherals and Remote Centrals

On the peripheral side, a local peripheral device is represented by a `CBPeripheralManager` object. These objects are used to manage published services within the local peripheral device’s database of services and characteristics and to advertise these services to remote central devices (represented by `CBCentral` objects). Peripheral manager objects are also used to respond to read and write requests from these remote centrals. Figure 1-6 shows how local peripherals and remote centrals are represented in the Core Bluetooth framework.

[](https://developer.apple.com/library/archive/documentation/NetworkingInternetWeb/Conceptual/CoreBluetooth_concepts/CoreBluetoothOverview/CoreBluetoothOverview.html "Figure 1-6Core Bluetooth objects on the peripheral side")

**Figure 1-6**Core Bluetooth objects on the peripheral side

![Image 6](https://developer.apple.com/library/archive/documentation/NetworkingInternetWeb/Conceptual/CoreBluetooth_concepts/Art/CBObjects_PeripheralSide_2x.png)[](https://developer.apple.com/library/archive/documentation/NetworkingInternetWeb/Conceptual/CoreBluetooth_concepts/CoreBluetoothOverview/CoreBluetoothOverview.html "A Local Peripheral’s Data Are Represented by CBMutableService and CBMutableCharacteristic Objects")
#### A Local Peripheral’s Data Are Represented by CBMutableService and CBMutableCharacteristic Objects

When you are setting up and interacting with the data on a local peripheral (represented by a `CBPeripheralManager` object), you are dealing with mutable versions of its services and characteristics. In the Core Bluetooth framework, the services of a local peripheral are represented by `CBMutableService` objects. Similarly, the characteristics of a local peripheral’s service are represented by `CBMutableCharacteristic` objects. Figure 1-7 illustrates the basic structure of a local peripheral’s services and characteristics.

[](https://developer.apple.com/library/archive/documentation/NetworkingInternetWeb/Conceptual/CoreBluetooth_concepts/CoreBluetoothOverview/CoreBluetoothOverview.html "Figure 1-7A local peripheral’s tree of services and characteristics")

**Figure 1-7**A local peripheral’s tree of services and characteristics

![Image 7](https://developer.apple.com/library/archive/documentation/NetworkingInternetWeb/Conceptual/CoreBluetooth_concepts/Art/TreeOfServicesAndCharacteristics_Local_2x.png)
For more information about how to set up your local device to implement the peripheral role, see [Performing Common Peripheral Role Tasks](https://developer.apple.com/library/archive/documentation/NetworkingInternetWeb/Conceptual/CoreBluetooth_concepts/PerformingCommonPeripheralRoleTasks/PerformingCommonPeripheralRoleTasks.html#//apple_ref/doc/uid/TP40013257-CH4-SW1) and [Best Practices for Setting Up Your Local Device as a Peripheral](https://developer.apple.com/library/archive/documentation/NetworkingInternetWeb/Conceptual/CoreBluetooth_concepts/BestPracticesForSettingUpYourIOSDeviceAsAPeripheral/BestPracticesForSettingUpYourIOSDeviceAsAPeripheral.html#//apple_ref/doc/uid/TP40013257-CH5-SW1).

[Next](https://developer.apple.com/library/archive/documentation/NetworkingInternetWeb/Conceptual/CoreBluetooth_concepts/PerformingCommonCentralRoleTasks/PerformingCommonCentralRoleTasks.html)[Previous](https://developer.apple.com/library/archive/documentation/NetworkingInternetWeb/Conceptual/CoreBluetooth_concepts/AboutCoreBluetooth/Introduction.html)

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

