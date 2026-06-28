Title: Best Practices for Interacting with a Remote Peripheral Device

URL Source: https://developer.apple.com/library/archive/documentation/NetworkingInternetWeb/Conceptual/CoreBluetooth_concepts/BestPracticesForInteractingWithARemotePeripheralDevice/BestPracticesForInteractingWithARemotePeripheralDevice.html

Markdown Content:
[](https://developer.apple.com/library/archive/documentation/NetworkingInternetWeb/Conceptual/CoreBluetooth_concepts/BestPracticesForInteractingWithARemotePeripheralDevice/BestPracticesForInteractingWithARemotePeripheralDevice.html)[](https://developer.apple.com/library/archive/documentation/NetworkingInternetWeb/Conceptual/CoreBluetooth_concepts/BestPracticesForInteractingWithARemotePeripheralDevice/BestPracticesForInteractingWithARemotePeripheralDevice.html "Best Practices for Interacting with a Remote Peripheral Device")
The Core Bluetooth framework makes many of the central-side transactions transparent to your app. That is, your app has control over, and is responsible for, implementing most aspects of the central role, such as device discovery and connectivity, and exploring and interacting with a remote peripheral’s data. This chapter provides guidelines and best practices for harnessing this level of control in a responsible way, especially when developing your app for an iOS device.

[](https://developer.apple.com/library/archive/documentation/NetworkingInternetWeb/Conceptual/CoreBluetooth_concepts/BestPracticesForInteractingWithARemotePeripheralDevice/BestPracticesForInteractingWithARemotePeripheralDevice.html "Be Mindful of Radio Usage and Power Consumption")
Be Mindful of Radio Usage and Power Consumption
-----------------------------------------------

When developing an app that interacts with Bluetooth low energy devices, remember that Bluetooth low energy communication shares your device’s radio to transmit signals over the air. Since other forms of wireless communication may need to use your device’s radio—for instance, Wi-Fi, classic Bluetooth, and even other apps using Bluetooth low energy—develop your app to minimize how much it uses the radio.

Minimizing radio usage is especially important when developing an app for an iOS device, because radio usage has an adverse effect on an iOS device’s battery life. The following guidelines will help you be a good citizen of your device’s radio. As a result, your app will perform better and your device’s battery will last longer.

[](https://developer.apple.com/library/archive/documentation/NetworkingInternetWeb/Conceptual/CoreBluetooth_concepts/BestPracticesForInteractingWithARemotePeripheralDevice/BestPracticesForInteractingWithARemotePeripheralDevice.html "Scan for Devices Only When You Need To")
### Scan for Devices Only When You Need To

When you call the `scanForPeripheralsWithServices:options:` method of the `CBCentralManager` class to discover remote peripheral’s that are advertising services, your central device uses its radio to listen for advertising devices until you explicitly tell it to stop.

Unless you need to discover more devices, stop scanning for other devices after you have found one you want to connect to. Use the `stopScan` method of the `CBCentralManager` class to stop scanning for other devices, as shown in [Connecting to a Peripheral Device After You’ve Discovered It](https://developer.apple.com/library/archive/documentation/NetworkingInternetWeb/Conceptual/CoreBluetooth_concepts/PerformingCommonCentralRoleTasks/PerformingCommonCentralRoleTasks.html#//apple_ref/doc/uid/TP40013257-CH3-SW4).

[](https://developer.apple.com/library/archive/documentation/NetworkingInternetWeb/Conceptual/CoreBluetooth_concepts/BestPracticesForInteractingWithARemotePeripheralDevice/BestPracticesForInteractingWithARemotePeripheralDevice.html "Specify the CBCentralManagerScanOptionAllowDuplicatesKey Option Only When Necessary")
### Specify the CBCentralManagerScanOptionAllowDuplicatesKey Option Only When Necessary

Remote peripheral devices may send out multiple advertising packets per second to announce their presence to listening centrals. When you are scanning for devices using the `scanForPeripheralsWithServices:options:` method, the default behavior of the method is to coalesce multiple discoveries of an advertising peripheral into a single discovery event—that is, the central manager calls the `centralManager:didDiscoverPeripheral:advertisementData:RSSI:` method of its delegate object for each new peripheral it discovers, regardless of how many advertising packets it receives. The central manager also calls this delegate method when the advertisement data of an already-discovered peripheral changes.

If you want to change the default behavior, you can specify the `CBCentralManagerScanOptionAllowDuplicatesKey` constant as a scan option when calling the `scanForPeripheralsWithServices:options:` method. When you do, a discovery event is generated each time the central receives an advertising packet from the peripheral. Turning off the default behavior can be useful for certain use cases, such as initiating a connection to a peripheral based on the peripheral’s proximity (using the peripheral received signal strength indicator (RSSI) value). That said, keep in mind that specifying this scan option may have an adverse effect on battery life and app performance. Therefore, specify this scan option only when it is necessary to fulfill a particular use case.

[](https://developer.apple.com/library/archive/documentation/NetworkingInternetWeb/Conceptual/CoreBluetooth_concepts/BestPracticesForInteractingWithARemotePeripheralDevice/BestPracticesForInteractingWithARemotePeripheralDevice.html "Explore a Peripheral’s Data Wisely")
### Explore a Peripheral’s Data Wisely

A peripheral device may have many more services and characteristics than you may be interested in when you are developing an app to fulfill a specific use case. Discovering all of a peripheral’s services and associated characteristics can negatively affect battery life and your app’s performance. Therefore, you should look for and discover only the services and associated characteristics your app needs.

For example, imagine that you are connected to a peripheral device that has many services available, but your app needs access to only two of them. You can look for and discover these two services only, by passing in an array of their service UUIDs (represented by `CBUUID` objects) to the `discoverServices:` method of the `CBPeripheral` class, like this:

    [peripheral discoverServices:@[firstServiceUUID, secondServiceUUID]];

After you have discovered the two services you are interested in, you can similarly look for and discover only the characteristics of these services that you are interested in. Again, simply pass in an array of the UUIDs that identify the characteristics you want to discover (for each service) to the `discoverCharacteristics:forService:` method of the `CBPeripheral` class.

[](https://developer.apple.com/library/archive/documentation/NetworkingInternetWeb/Conceptual/CoreBluetooth_concepts/BestPracticesForInteractingWithARemotePeripheralDevice/BestPracticesForInteractingWithARemotePeripheralDevice.html "Subscribe to Characteristic Values That Change Often")
### Subscribe to Characteristic Values That Change Often

As described in [Retrieving the Value of a Characteristic](https://developer.apple.com/library/archive/documentation/NetworkingInternetWeb/Conceptual/CoreBluetooth_concepts/PerformingCommonCentralRoleTasks/PerformingCommonCentralRoleTasks.html#//apple_ref/doc/uid/TP40013257-CH3-SW7), there are two ways you can retrieve a characteristic’s value:

*   You can explicitly poll for a characteristic’s value by calling the `readValueForCharacteristic:` method each time you need the value.

*   You can subscribe to the characteristic’s value by calling the `setNotifyValue:forCharacteristic:` method once to receive a notification from the peripheral when the value changes.

It is best practice to subscribe to a characteristic’s value when possible, especially for characteristic values that change often. For an example of how to subscribe to a characteristic’s value, see [Subscribing to a Characteristic’s Value](https://developer.apple.com/library/archive/documentation/NetworkingInternetWeb/Conceptual/CoreBluetooth_concepts/PerformingCommonCentralRoleTasks/PerformingCommonCentralRoleTasks.html#//apple_ref/doc/uid/TP40013257-CH3-SW16).

[](https://developer.apple.com/library/archive/documentation/NetworkingInternetWeb/Conceptual/CoreBluetooth_concepts/BestPracticesForInteractingWithARemotePeripheralDevice/BestPracticesForInteractingWithARemotePeripheralDevice.html "Disconnect from a Device When You Have All the Data You Need")
### Disconnect from a Device When You Have All the Data You Need

You can help reduce your app’s radio usage by disconnecting from a peripheral device when a connection is no longer needed. You should disconnect from a peripheral device in both of the following situations:

*   All characteristic values that you’ve subscribed to have stopped sending notifications. (You can determine whether a characteristic’s value is notifying by accessing the characteristic’s `isNotifying` property.)

*   You have all of the data you need from the peripheral device.

In both cases, cancel any subscriptions you may have and then disconnect from the peripheral. You can cancel any subscription to a characteristic’s value by calling the `setNotifyValue:forCharacteristic:` method, setting the first parameter to `NO`. You can cancel a connection to a peripheral device by calling the `cancelPeripheralConnection:` method of the `CBCentralManager` class, like this:

    [myCentralManager cancelPeripheralConnection:peripheral];

[](https://developer.apple.com/library/archive/documentation/NetworkingInternetWeb/Conceptual/CoreBluetooth_concepts/BestPracticesForInteractingWithARemotePeripheralDevice/BestPracticesForInteractingWithARemotePeripheralDevice.html "Reconnecting to Peripherals")
Reconnecting to Peripherals
---------------------------

Using the Core Bluetooth framework, there are three ways you can reconnect to a peripheral. You can:

*   Retrieve a list of known peripherals—peripherals that you’ve discovered or connected to in the past—using the `retrievePeripheralsWithIdentifiers:` method. If the peripheral you’re looking for is in the list, try to connect to it. This reconnection option is described in [Retrieving a List of Known Peripherals](https://developer.apple.com/library/archive/documentation/NetworkingInternetWeb/Conceptual/CoreBluetooth_concepts/BestPracticesForInteractingWithARemotePeripheralDevice/BestPracticesForInteractingWithARemotePeripheralDevice.html#//apple_ref/doc/uid/TP40013257-CH6-SW10).

*   Retrieve a list of peripheral devices that are currently connected to the system using the `retrieveConnectedPeripheralsWithServices:` method. If the peripheral you’re looking for is in the list, connect it locally to your app. This reconnection option is described in [Retrieving a List of Connected Peripherals](https://developer.apple.com/library/archive/documentation/NetworkingInternetWeb/Conceptual/CoreBluetooth_concepts/BestPracticesForInteractingWithARemotePeripheralDevice/BestPracticesForInteractingWithARemotePeripheralDevice.html#//apple_ref/doc/uid/TP40013257-CH6-SW11).

*   Scan for and discover a peripheral using the `scanForPeripheralsWithServices:options:` method. If you find it, connect to it. These steps are described in [Discovering Peripheral Devices That Are Advertising](https://developer.apple.com/library/archive/documentation/NetworkingInternetWeb/Conceptual/CoreBluetooth_concepts/PerformingCommonCentralRoleTasks/PerformingCommonCentralRoleTasks.html#//apple_ref/doc/uid/TP40013257-CH3-SW3) and [Connecting to a Peripheral Device After You’ve Discovered It](https://developer.apple.com/library/archive/documentation/NetworkingInternetWeb/Conceptual/CoreBluetooth_concepts/PerformingCommonCentralRoleTasks/PerformingCommonCentralRoleTasks.html#//apple_ref/doc/uid/TP40013257-CH3-SW4).

Depending on the use case, you may not want to have to scan for and discover the same peripheral every time you want to reconnect to it. Instead, you may want to try to reconnect using the other options first. As Figure 5-1 shows, one possible reconnection workflow may be to try each of these options in the order in which they’re listed above.

[](https://developer.apple.com/library/archive/documentation/NetworkingInternetWeb/Conceptual/CoreBluetooth_concepts/BestPracticesForInteractingWithARemotePeripheralDevice/BestPracticesForInteractingWithARemotePeripheralDevice.html "Figure 5-1A sample reconnection workflow")

**Figure 5-1**A sample reconnection workflow

![Image 1](https://developer.apple.com/library/archive/documentation/NetworkingInternetWeb/Conceptual/CoreBluetooth_concepts/Art/ReconnectingToAPeripheral_2x.png)[](https://developer.apple.com/library/archive/documentation/NetworkingInternetWeb/Conceptual/CoreBluetooth_concepts/BestPracticesForInteractingWithARemotePeripheralDevice/BestPracticesForInteractingWithARemotePeripheralDevice.html "Retrieving a List of Known Peripherals")
### Retrieving a List of Known Peripherals

The first time you discover a peripheral, the system generates an identifier (a UUID, represented by an `NSUUID` object) to identify the peripheral. You can then store this identifier (using, for instance, the resources of the `NSUserDefaults` class), and later use it to try to reconnect to the peripheral using the `retrievePeripheralsWithIdentifiers:` method of the `CBCentralManager` class. The following describes one way to use this method to reconnect to a peripheral you’ve previously connected to.

When your app launches, call the `retrievePeripheralsWithIdentifiers:` method, passing in an array containing the identifiers of the peripherals you’ve previously discovered and connected to (and whose identifiers you have saved), like this:

knownPeripherals =
[myCentralManager retrievePeripheralsWithIdentifiers:savedIdentifiers];

The central manager tries to match the identifiers you provided to the identifiers of previously discovered peripherals and returns the results as an array of `CBPeripheral` objects. If no matches are found, the array is empty and you should try one of the other two reconnection options. If the array is not empty, let the user select (in the UI) which peripheral to try to reconnect to.

When the user selects a peripheral, try to connect to it by calling the `connectPeripheral:options:` method of the `CBCentralManager` class. If the peripheral device is still available to be connected to, the central manager calls the `centralManager:didConnectPeripheral:` method of its delegate object and the peripheral device is successfully reconnected.

[](https://developer.apple.com/library/archive/documentation/NetworkingInternetWeb/Conceptual/CoreBluetooth_concepts/BestPracticesForInteractingWithARemotePeripheralDevice/BestPracticesForInteractingWithARemotePeripheralDevice.html "Retrieving a List of Connected Peripherals")
### Retrieving a List of Connected Peripherals

Another way to reconnect to a peripheral is by checking to see whether the peripheral you’re looking for is already connected to the system (for instance, by another app). You can do so by calling the `retrieveConnectedPeripheralsWithServices:` method of the `CBCentralManager` class, which returns an array of `CBPeripheral` objects representing peripheral devices that are currently connected to the system.

Because there may be more than one peripheral currently connected to the system, you can pass in an array of `CBUUID` objects (these object represent service UUIDs) to retrieve only peripherals that are currently connected to the system _and_ contain any services that are identified by the UUIDs you specified. If there are no peripheral devices currently connected to the system, the array is empty and you should try one of the other two reconnection options. If the array is not empty, let the user select (in the UI) which one to try to reconnect to.

Assuming that the user finds and selects the desired peripheral, connect it locally to your app by calling the `connectPeripheral:options:` method of the `CBCentralManager` class. (Even though the device is already connected to the system, you must still connect it locally to your app to begin exploring and interacting with it.) When the local connection is established, the central manager calls the `centralManager:didConnectPeripheral:` method of its delegate object, and the peripheral device is successfully reconnected.