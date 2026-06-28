Title: Performing Common Central Role Tasks

URL Source: https://developer.apple.com/library/archive/documentation/NetworkingInternetWeb/Conceptual/CoreBluetooth_concepts/PerformingCommonCentralRoleTasks/PerformingCommonCentralRoleTasks.html

Markdown Content:
Performing Common Central Role Tasks
===============
[](https://developer.apple.com/library/archive/documentation/NetworkingInternetWeb/Conceptual/CoreBluetooth_concepts/PerformingCommonCentralRoleTasks/PerformingCommonCentralRoleTasks.html "Performing Common Central Role Tasks")

[Documentation Archive](https://developer.apple.com/library/archive/navigation/)[Developer](https://developer.apple.com/)

Search

Search Documentation Archive 

Core Bluetooth Programming Guide
================================

[PDF](https://developer.apple.com/library/archive/documentation/NetworkingInternetWeb/Conceptual/CoreBluetooth_concepts/PerformingCommonCentralRoleTasks/PerformingCommonCentralRoleTasks.html "Download PDF")[Companion File](https://developer.apple.com/library/archive/documentation/NetworkingInternetWeb/Conceptual/CoreBluetooth_concepts/PerformingCommonCentralRoleTasks/PerformingCommonCentralRoleTasks.html "Download Companion File")

*   Table of Contents

*   [Download Sample Code](https://developer.apple.com/library/archive/documentation/NetworkingInternetWeb/Conceptual/CoreBluetooth_concepts/PerformingCommonCentralRoleTasks/PerformingCommonCentralRoleTasks.html)

[Next](https://developer.apple.com/library/archive/documentation/NetworkingInternetWeb/Conceptual/CoreBluetooth_concepts/PerformingCommonPeripheralRoleTasks/PerformingCommonPeripheralRoleTasks.html)[Previous](https://developer.apple.com/library/archive/documentation/NetworkingInternetWeb/Conceptual/CoreBluetooth_concepts/CoreBluetoothOverview/CoreBluetoothOverview.html)

[](https://developer.apple.com/library/archive/documentation/NetworkingInternetWeb/Conceptual/CoreBluetooth_concepts/PerformingCommonCentralRoleTasks/PerformingCommonCentralRoleTasks.html)[](https://developer.apple.com/library/archive/documentation/NetworkingInternetWeb/Conceptual/CoreBluetooth_concepts/index.html)[](https://developer.apple.com/library/archive/documentation/NetworkingInternetWeb/Conceptual/CoreBluetooth_concepts/PerformingCommonCentralRoleTasks/PerformingCommonCentralRoleTasks.html "Performing Common Central Role Tasks")
Performing Common Central Role Tasks
====================================

Devices that implement the central role in Bluetooth low energy communication perform a number of common tasks—for example, discovering and connecting to available peripherals, and exploring and interacting with the data that peripherals have to offer. Devices that implement the peripheral role also perform a number of common, but different, tasks—for example, publishing and advertising services, and responding to read, write, and subscription requests from connected centrals.

In this chapter, you will learn how to use the Core Bluetooth framework to perform the most common types of Bluetooth low energy tasks from the central side. The code-based examples that follow will assist you in developing your app to implement the central role on your local device. Specifically, you will learn how to:

*   Start up a central manager object

*   Discover and connect to peripheral devices that are advertising

*   Explore the data on a peripheral device after you’ve connected to it

*   Send read and write requests to a characteristic value of a peripheral’s service

*   Subscribe to a characteristic’s value to be notified when it is updated

In the next chapter, you will learn how to develop your app to implement the peripheral role on your local device.

The code examples that you find in this chapter are simple and abstract; you may need to make appropriate changes to incorporate them into your real world app. More advanced topics related to implementing the central role—including tips, tricks, and best practices—are covered in the later chapters, [Core Bluetooth Background Processing for iOS Apps](https://developer.apple.com/library/archive/documentation/NetworkingInternetWeb/Conceptual/CoreBluetooth_concepts/CoreBluetoothBackgroundProcessingForIOSApps/PerformingTasksWhileYourAppIsInTheBackground.html#//apple_ref/doc/uid/TP40013257-CH7-SW1) and [Best Practices for Interacting with a Remote Peripheral Device](https://developer.apple.com/library/archive/documentation/NetworkingInternetWeb/Conceptual/CoreBluetooth_concepts/BestPracticesForInteractingWithARemotePeripheralDevice/BestPracticesForInteractingWithARemotePeripheralDevice.html#//apple_ref/doc/uid/TP40013257-CH6-SW1).

[](https://developer.apple.com/library/archive/documentation/NetworkingInternetWeb/Conceptual/CoreBluetooth_concepts/PerformingCommonCentralRoleTasks/PerformingCommonCentralRoleTasks.html "Starting Up a Central Manager")
Starting Up a Central Manager
-----------------------------

Because a `CBCentralManager` object is the Core Bluetooth object-oriented representation of a local central device, you allocate and initialize a central manager instance before you can perform any Bluetooth low energy transactions. You initialize your central manager by calling its `initWithDelegate:queue:options:` method:

myCentralManager =
[[CBCentralManager alloc] initWithDelegate:self queue:nil options:nil];

In this example, `self` is set as the delegate to receive any central role events. By specifying the dispatch queue as `nil`, the central manager dispatches central role events using the main queue.

When you create a central manager, the central manager calls the `centralManagerDidUpdateState:` method of its delegate object. You must implement this delegate method to ensure that Bluetooth low energy is supported and available to use on the central device. For more information about how to implement this delegate method, see _[CBCentralManagerDelegate Protocol Reference](https://developer.apple.com/documentation/corebluetooth/cbcentralmanagerdelegate)_.

[](https://developer.apple.com/library/archive/documentation/NetworkingInternetWeb/Conceptual/CoreBluetooth_concepts/PerformingCommonCentralRoleTasks/PerformingCommonCentralRoleTasks.html "Discovering Peripheral Devices That Are Advertising")
Discovering Peripheral Devices That Are Advertising
---------------------------------------------------

Once initialized, the central manager’s first task is peripheral discovery. As mentioned in [Centrals Discover and Connect to Peripherals That Are Advertising](https://developer.apple.com/library/archive/documentation/NetworkingInternetWeb/Conceptual/CoreBluetooth_concepts/CoreBluetoothOverview/CoreBluetoothOverview.html#//apple_ref/doc/uid/TP40013257-CH2-SW3), peripherals make their presence known by advertising. Your app discovers nearby peripheral devices that are advertising by calling the central manager’s `scanForPeripheralsWithServices:options:` method:

[myCentralManager scanForPeripheralsWithServices:nil options:nil];

[](https://developer.apple.com/library/archive/documentation/NetworkingInternetWeb/Conceptual/CoreBluetooth_concepts/PerformingCommonCentralRoleTasks/PerformingCommonCentralRoleTasks.html "Note")
**Note:**If you specify `nil` for the first parameter, the central manager returns _all_ discovered peripherals, regardless of their supported services. In a real app, you typically specify an array of `CBUUID` objects, each of which represents the universally unique identifier (UUID) of a service that a peripheral is advertising. When you specify an array of service UUIDs, the central manager returns only peripherals that advertise those services, allowing you to scan only for devices that you may be interested in.

UUIDs, and the `CBUUID` objects that represent them, are discussed in more detail in [Services and Characteristics Are Identified by UUIDs](https://developer.apple.com/library/archive/documentation/NetworkingInternetWeb/Conceptual/CoreBluetooth_concepts/PerformingCommonPeripheralRoleTasks/PerformingCommonPeripheralRoleTasks.html#//apple_ref/doc/uid/TP40013257-CH4-SW8).

Every time the central manager discovers a peripheral, it calls the `centralManager:didDiscoverPeripheral:advertisementData:RSSI:` method of its delegate object. The newly discovered peripheral is returned as a `CBPeripheral` object. If you plan to connect to the discovered peripheral, keep a strong reference to it so the system does not deallocate it. The following example shows a scenario where you use a class property to maintain a reference to the discovered peripheral:

- (void)centralManager:(CBCentralManager *)central
didDiscoverPeripheral:(CBPeripheral *)peripheral
advertisementData:(NSDictionary *)advertisementData
RSSI:(NSNumber *)RSSI {

NSLog(@"Discovered %@", peripheral.name);
self.discoveredPeripheral = peripheral;
...

If you expect to connect to multiple devices, you might instead keep an `NSArray` of discovered peripherals. In any case, once you’ve found all the peripheral devices that you’re interested in connecting to, stop scanning for other devices in order to save power:

[myCentralManager stopScan];

[](https://developer.apple.com/library/archive/documentation/NetworkingInternetWeb/Conceptual/CoreBluetooth_concepts/PerformingCommonCentralRoleTasks/PerformingCommonCentralRoleTasks.html "Connecting to a Peripheral Device After You’ve Discovered It")
Connecting to a Peripheral Device After You’ve Discovered It
------------------------------------------------------------

After you discover a peripheral device advertising services you are interested in, you request a connection to the peripheral by calling the central manager’s `connectPeripheral:options:` method, naming the discovered peripheral that you want to connect to:

[myCentralManager connectPeripheral:peripheral options:nil];

If the connection request is successful, the central manager calls the `centralManager:didConnectPeripheral:` method of its delegate object. Before you start interacting with the peripheral, you set its delegate to ensure that the delegate receives the appropriate callbacks:

- (void)centralManager:(CBCentralManager *)central
didConnectPeripheral:(CBPeripheral *)peripheral {

NSLog(@"Peripheral connected");
peripheral.delegate = self;
...

[](https://developer.apple.com/library/archive/documentation/NetworkingInternetWeb/Conceptual/CoreBluetooth_concepts/PerformingCommonCentralRoleTasks/PerformingCommonCentralRoleTasks.html "Discovering the Services of a Peripheral That You’re Connected To")
Discovering the Services of a Peripheral That You’re Connected To
-----------------------------------------------------------------

After you have established a connection to a peripheral, you can explore its data. The first step in exploring what a peripheral has to offer is discovering its available services. Because there are size restrictions on the amount of data a peripheral can advertise, you may discover that a peripheral has more services than what it advertises (in its advertising packets). You can discover all of the services that a peripheral offers by calling the peripheral’s `discoverServices:` method, like this:

[peripheral discoverServices:nil];

[](https://developer.apple.com/library/archive/documentation/NetworkingInternetWeb/Conceptual/CoreBluetooth_concepts/PerformingCommonCentralRoleTasks/PerformingCommonCentralRoleTasks.html "Note")
**Note:**In a real app, you typically do not pass in `nil` as the parameter, because doing so returns _all_ the services available on a peripheral device. Because a peripheral may contain many more services than you are interested in, discovering all of them may waste battery life and be an unnecessary use of time. Instead, you typically specify the UUIDs of the services that you already know you are interested in discovering, as shown in [Explore a Peripheral’s Data Wisely](https://developer.apple.com/library/archive/documentation/NetworkingInternetWeb/Conceptual/CoreBluetooth_concepts/BestPracticesForInteractingWithARemotePeripheralDevice/BestPracticesForInteractingWithARemotePeripheralDevice.html#//apple_ref/doc/uid/TP40013257-CH6-SW6).

When the specified services are discovered, the peripheral (the `CBPeripheral` object you’re connected to) calls the `peripheral:didDiscoverServices:` method of its delegate object. Core Bluetooth creates an array of `CBService` objects—one for each service that is discovered on the peripheral. As the following shows, you can implement this delegate method to access the array of discovered services:

- (void)peripheral:(CBPeripheral *)peripheral
didDiscoverServices:(NSError *)error {

for (CBService *service in peripheral.services) {
NSLog(@"Discovered service %@", service);
...
}
...

[](https://developer.apple.com/library/archive/documentation/NetworkingInternetWeb/Conceptual/CoreBluetooth_concepts/PerformingCommonCentralRoleTasks/PerformingCommonCentralRoleTasks.html "Discovering the Characteristics of a Service")
Discovering the Characteristics of a Service
--------------------------------------------

When you find a service that you are interested in, the next step in exploring what a peripheral has to offer is discovering all of the service’s characteristics. Discovering all of the characteristics of a service is as simple as calling the peripheral’s `discoverCharacteristics:forService:` method, specifying the appropriate service, like this:

NSLog(@"Discovering characteristics for service %@", interestingService);
[peripheral discoverCharacteristics:nil forService:interestingService];

[](https://developer.apple.com/library/archive/documentation/NetworkingInternetWeb/Conceptual/CoreBluetooth_concepts/PerformingCommonCentralRoleTasks/PerformingCommonCentralRoleTasks.html "Note")
**Note:**In a real app, you typically do not pass in `nil` as the first parameter, because doing so returns _all_ the characteristics of a peripheral’s service. Because a peripheral’s service may contain many more characteristics than you are interested in, discovering all of them may waste battery life and be an unnecessary use of time. Instead, you typically specify the UUIDs of the characteristics that you already know you are interested in discovering.

The peripheral calls the `peripheral:didDiscoverCharacteristicsForService:error:` method of its delegate object when the characteristics of the specified service are discovered. Core Bluetooth creates an array of `CBCharacteristic` objects—one for each characteristic that is discovered. The following example shows how you can implement this delegate method to simply log every characteristic that is discovered:

- (void)peripheral:(CBPeripheral *)peripheral
didDiscoverCharacteristicsForService:(CBService *)service
error:(NSError *)error {

for (CBCharacteristic *characteristic in service.characteristics) {
NSLog(@"Discovered characteristic %@", characteristic);
...
}
...

[](https://developer.apple.com/library/archive/documentation/NetworkingInternetWeb/Conceptual/CoreBluetooth_concepts/PerformingCommonCentralRoleTasks/PerformingCommonCentralRoleTasks.html "Retrieving the Value of a Characteristic")
Retrieving the Value of a Characteristic
----------------------------------------

A characteristic contains a single value that represents information about a peripheral’s service. For example, a temperature measurement characteristic of a health thermometer service may have a value that indicates a temperature in Celsius. You can retrieve the value of a characteristic by reading it directly or by subscribing to it.

[](https://developer.apple.com/library/archive/documentation/NetworkingInternetWeb/Conceptual/CoreBluetooth_concepts/PerformingCommonCentralRoleTasks/PerformingCommonCentralRoleTasks.html "Reading the Value of a Characteristic")
### Reading the Value of a Characteristic

After you have found a characteristic of a service that you are interested in, you can read the characteristic’s value by calling the peripheral’s `readValueForCharacteristic:` method, specifying the appropriate characteristic, like this:

NSLog(@"Reading value for characteristic %@", interestingCharacteristic);
[peripheral readValueForCharacteristic:interestingCharacteristic];

When you attempt to read the value of a characteristic, the peripheral calls the `peripheral:didUpdateValueForCharacteristic:error:` method of its delegate object to retrieve the value. If the value is successfully retrieved, you can access it through the characteristic’s value property, like this:

- (void)peripheral:(CBPeripheral *)peripheral
didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic
error:(NSError *)error {

NSData *data = characteristic.value;
// parse the data as needed
...

[](https://developer.apple.com/library/archive/documentation/NetworkingInternetWeb/Conceptual/CoreBluetooth_concepts/PerformingCommonCentralRoleTasks/PerformingCommonCentralRoleTasks.html "Note")
**Note:**Not all characteristics are readable. You can determine whether a characteristic is readable by checking if its `properties` attribute includes the `CBCharacteristicPropertyRead` constant. If you try to read a value of a characteristic that is not readable, the `peripheral:didUpdateValueForCharacteristic:error:` delegate method returns a suitable error.

[](https://developer.apple.com/library/archive/documentation/NetworkingInternetWeb/Conceptual/CoreBluetooth_concepts/PerformingCommonCentralRoleTasks/PerformingCommonCentralRoleTasks.html "Subscribing to a Characteristic’s Value")
### Subscribing to a Characteristic’s Value

Though reading the value of a characteristic using the `readValueForCharacteristic:` method can be effective for static values, it is not the most efficient way to retrieve a dynamic value. Retrieve characteristic values that change over time—for instance, your heart rate—by subscribing to them. When you subscribe to a characteristic’s value, you receive a notification from the peripheral when the value changes.

You subscribe to the value of a characteristic that you are interested in by calling the peripheral’s `setNotifyValue:forCharacteristic:` method, specifying the first parameter as `YES`, like this:

[peripheral setNotifyValue:YES forCharacteristic:interestingCharacteristic];

When you subscribe to (or unsubscribe from) a characteristic’s value, the peripheral calls the `peripheral:didUpdateNotificationStateForCharacteristic:error:` method of its delegate object. If the subscription request fails for any reason, you can implement this delegate method to access the cause of the error, as the following example shows:

- (void)peripheral:(CBPeripheral *)peripheral
didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic
error:(NSError *)error {

if (error) {
NSLog(@"Error changing notification state: %@",
[error localizedDescription]);
}
...

[](https://developer.apple.com/library/archive/documentation/NetworkingInternetWeb/Conceptual/CoreBluetooth_concepts/PerformingCommonCentralRoleTasks/PerformingCommonCentralRoleTasks.html "Note")
**Note:**Not all characteristics offer subscription. You can determine if a characteristic offers subscription by checking if its `properties` attribute includes either of the `CBCharacteristicPropertyNotify` or `CBCharacteristicPropertyIndicate` constants.

After you have successfully subscribed to a characteristic’s value, the peripheral device notifies your app when the value has changed. Each time the value changes, the peripheral calls the `peripheral:didUpdateValueForCharacteristic:error:` method of its delegate object. To retrieve the updated value, you can implement this method in the same way as described above in [Reading the Value of a Characteristic](https://developer.apple.com/library/archive/documentation/NetworkingInternetWeb/Conceptual/CoreBluetooth_concepts/PerformingCommonCentralRoleTasks/PerformingCommonCentralRoleTasks.html#//apple_ref/doc/uid/TP40013257-CH3-SW12).

[](https://developer.apple.com/library/archive/documentation/NetworkingInternetWeb/Conceptual/CoreBluetooth_concepts/PerformingCommonCentralRoleTasks/PerformingCommonCentralRoleTasks.html "Writing the Value of a Characteristic")
Writing the Value of a Characteristic
-------------------------------------

Sometimes it makes sense to write the value of a characteristic. For example, if your app interacts with a Bluetooth low energy digital thermostat, you may want to provide the thermostat with a value at which to set the room’s temperature. If a characteristic’s value is writeable, you can write its value with data (an instance of `NSData`) by calling the peripheral’s `writeValue:forCharacteristic:type:` method, like this:

NSLog(@"Writing value for characteristic %@", interestingCharacteristic);
[peripheral writeValue:dataToWrite forCharacteristic:interestingCharacteristic
type:CBCharacteristicWriteWithResponse];

When you write the value of a characteristic, you specify what type of write you want to perform. In the example above, the write type is `CBCharacteristicWriteWithResponse`, which instructs the peripheral to let your app know whether or not the write succeeds by calling the `peripheral:didWriteValueForCharacteristic:error:` method of its delegate object. You implement this delegate method to handle the error condition, as the following example shows:

- (void)peripheral:(CBPeripheral *)peripheral
didWriteValueForCharacteristic:(CBCharacteristic *)characteristic
error:(NSError *)error {

if (error) {
NSLog(@"Error writing characteristic value: %@",
[error localizedDescription]);
}
...

If instead you specify the write type as `CBCharacteristicWriteWithoutResponse`, the write operation is performed as best-effort, and delivery is neither guaranteed nor reported. The peripheral does not call any delegate method. For more information about the write types that are supported in the Core Bluetooth framework, see the `CBCharacteristicWriteType` enumeration in _[CBPeripheral Class Reference](https://developer.apple.com/documentation/corebluetooth/cbperipheral)_.

[](https://developer.apple.com/library/archive/documentation/NetworkingInternetWeb/Conceptual/CoreBluetooth_concepts/PerformingCommonCentralRoleTasks/PerformingCommonCentralRoleTasks.html "Note")
**Note:**Characteristics may support only certain types of writes, or none at all. You determine what type of writes, if any, a characteristic supports by checking its `properties` attribute for one of the `CBCharacteristicPropertyWriteWithoutResponse` or `CBCharacteristicPropertyWrite` constants.

[Next](https://developer.apple.com/library/archive/documentation/NetworkingInternetWeb/Conceptual/CoreBluetooth_concepts/PerformingCommonPeripheralRoleTasks/PerformingCommonPeripheralRoleTasks.html)[Previous](https://developer.apple.com/library/archive/documentation/NetworkingInternetWeb/Conceptual/CoreBluetooth_concepts/CoreBluetoothOverview/CoreBluetoothOverview.html)

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

