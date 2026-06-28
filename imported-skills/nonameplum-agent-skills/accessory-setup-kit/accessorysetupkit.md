# https://developer.apple.com/documentation/accessorysetupkit

Framework

# AccessorySetupKit

Enable privacy-preserving discovery and configuration of accessories.

## Overview

Use AccessorySetupKit to discover and configure Bluetooth or Wi-Fi accessories with images and names provided by the app. Allow seamless, privacy-preserving user consent and control for Bluetooth, Wi-Fi, and Local Network permissions. AccessorySetupKit apps can access enhanced accessory controls including accessory pairing removal and renaming.

To use AccessorySetupKit with Wi-Fi Aware, specify Wi-Fi Aware properties in a `ASDiscoveryDescriptor` prior to beginning accessory discovery.

## Topics

### Essentials

Setting up and authorizing a Bluetooth accessory

Discover, select, and set up a specific Bluetooth accessory without requesting permission to use Bluetooth.

Discovering and configuring accessories

Detect nearby accessories and facilitate their setup.

`class ASAccessorySession`

A class to coordinate accessory discovery.

### Accessory discovery

`class ASAccessoryEvent`

Properties of an event encountered during accessory discovery.

`enum ASAccessoryEventType`

An enumeration of the types of events encountered during accessory discovery

`class ASDiscoveryDescriptor`

Descriptive traits used to discover accessories.

### Accessory description

`class ASAccessory`

An accessory discovered by the accessory session.

`class ASDiscoveredAccessory`

A discovered accessory, for use in creating a customized picker display item.

`enum AccessoryState`

An enumeration of possible authorization states of an accessory.

### Displaying picker items

`class ASPickerDisplayItem`

An accessory as presented by the discovery picker.

`class ASDiscoveredDisplayItem`

A picker display item created from customizing a discovered accessory.

`class ASMigrationDisplayItem`

A previously-discovered accessory as presented by the discovery picker, for use when migrating it to AccessorySetupKit.

### Information property list keys

`NSAccessorySetupSupports`

An array of strings that indicates the wireless technologies AccessorySetupKit uses when discovering and configuring accessories.

`NSAccessorySetupBluetoothCompanyIdentifiers`

An array of strings that represent the Bluetooth company identifiers for accessories that your app configures.

`NSAccessorySetupBluetoothNames`

An array of strings that represent the Bluetooth device names or substrings for accessories that your app configures.

`NSAccessorySetupBluetoothServices`

An array of strings that represent the hexadecimal values of Bluetooth SIG-defined services or custom services for accessories your app configures.

### Errors

`struct ASError`

An error encountered during accessory discovery.

`let ASErrorDomain: String`

NSError domain for AccessorySetupKit errors.

`enum Code`

Codes that describe errors encountered during accessory discovery.

---

# https://developer.apple.com/documentation/accessorysetupkit/asdiscoverydescriptor

- AccessorySetupKit
- ASDiscoveryDescriptor

Class

# ASDiscoveryDescriptor

Descriptive traits used to discover accessories.

class ASDiscoveryDescriptor

## Mentioned in

Discovering and configuring accessories

## Overview

Use an instance of this type to identify accessories your app can set up, then set it as the `descriptor` property of an `ASPickerDisplayItem`.

Some of the Bluetooth identifier properties work together to filter matching accessories, as described in the following table.

| Use | Filter property | Also requires | Description |
| --- | --- | --- | --- |
| Required | `bluetoothServiceUUID` or `bluetoothCompanyIdentifier` | (none) | Provide at least one UUID or manufacturer ID to filter. |
| Optional | `bluetoothNameSubstring` | `bluetoothServiceUUID` or `bluetoothCompanyIdentifier` | Provide a name substring to look for. Requires setting at least a service UUID or company ID, which identifies the service or company using the name. |
| Optional | `bluetoothManufacturerDataBlob` and `bluetoothManufacturerDataMask` | `bluetoothCompanyIdentifier` | When using manufacturer data filters, provide both the data and mask. These properties should have the same length and be less than or equal to the size of the advertised payload. The `bluetoothCompanyIdentifier` identifies the manufacturer associated with the data. |
| Optional | `bluetoothServiceDataBlob` and `bluetoothServiceDataMask` | `bluetoothServiceUUID` | When using UUID service data filters, provide both the data and mask. These properties should have the same length and be less than or equal to the size of the advertised payload. The `bluetoothServiceUUID` identifies the service associated with the data. |

The descriptor also allows you to set the `bluetoothRange` of matched accessories; set its value to `ASDiscoveryDescriptor.Range.immediate` to limit discovery of Bluetooth accessories to those within the immediate proximity of the device running your app.

## Topics

### Specifying Bluetooth properties

`var bluetoothCompanyIdentifier: ASBluetoothCompanyIdentifier`

The accessory’s 16-bit Bluetooth Company Identifier.

`struct ASBluetoothCompanyIdentifier`

The type used to identify a Bluetooth accessory provider.

`var bluetoothManufacturerDataBlob: Data?`

A byte buffer that matches the accessory’s Bluetooth manufacturer data.

`var bluetoothManufacturerDataMask: Data?`

The accessory’s Bluetooth manufacturer data mask.

`var bluetoothServiceDataBlob: Data?`

A byte buffer that matches the accessory’s Bluetooth service data.

`var bluetoothServiceDataMask: Data?`

The accessory’s Bluetooth service data mask.

`var bluetoothNameSubstring: String?`

The accessory’s over-the-air Bluetooth name substring.

`var bluetoothNameSubstringCompareOptions: NSString.CompareOptions`

The accessory’s over-the-air Bluetooth name substring compare options.

`var bluetoothServiceUUID: CBUUID?`

The accessory’s Bluetooth service UUID.

`var bluetoothRange: ASDiscoveryDescriptor.Range`

A property that tells the session to discover accessories within a specific Bluetooth range.

`enum Range`

The Bluetooth range in which to discover accessories.

### Specifying Wi-Fi properties

`var ssid: String?`

The SSID of the accessory’s Wi-Fi network.

`var ssidPrefix: String?`

The prefix string of SSID of the accessory’s Wi-Fi network.

### Specifying options

`var supportedOptions: ASAccessory.SupportOptions`

Options supported by an accessory.

`struct SupportOptions`

Options of discoverable accessories.

### Specifying Wi-Fi Aware properties

`var wifiAwareServiceName: String?`

The accessory’s Wi-Fi Aware’s service name if available.

`var wifiAwareServiceRole: ASDiscoveryDescriptor.WiFiAwareServiceRole`

The role of the accessory’s Wi-Fi Aware’s service.

`enum WiFiAwareServiceRole`

A type that defines the role of an accessory’s Wi-Fi Aware’s service.

`var wifiAwareModelNameMatch: ASPropertyCompareString?`

The accessory’s Wi-Fi Aware model name and matching options.

`var wifiAwareVendorNameMatch: ASPropertyCompareString?`

The accessory’s Wi-Fi Aware vendor name and matching options.

`class ASPropertyCompareString`

A type that specifies how to filter a property against a given string and comparison options.

## Relationships

### Inherits From

- `NSObject`

### Conforms To

- `CVarArg`
- `CustomDebugStringConvertible`
- `CustomStringConvertible`
- `Equatable`
- `Hashable`
- `NSObjectProtocol`
- `Sendable`
- `SendableMetatype`

## See Also

### Accessory discovery

`class ASAccessoryEvent`

Properties of an event encountered during accessory discovery.

`enum ASAccessoryEventType`

An enumeration of the types of events encountered during accessory discovery

---

# https://developer.apple.com/documentation/accessorysetupkit/setting-up-and-authorizing-a-bluetooth-accessory

- AccessorySetupKit
- Setting up and authorizing a Bluetooth accessory

Sample Code

# Setting up and authorizing a Bluetooth accessory

Discover, select, and set up a specific Bluetooth accessory without requesting permission to use Bluetooth.

Download

Xcode 16.0+

## Overview

This sample project uses two app targets to demonstrate how to use AccessorySetupKit. `ASKSampleAccessory` simulates Bluetooth dice, while `ASKSample` highlights how to use AccessorySetupKit to onboard the accessory.

The `ASKSample` target uses AccessorySetupKit to authorize the use of a Bluetooth dice accessory and receive roll results. When you tap the “Add Dice” button, the app searches for dice and presents the set up AccessorySetupKit UI. AccessorySetupKit then authorizes and grants the app access to that accessory. After authorization, you can connect to the accessory and receive roll results until you decide to disconnect or remove authorization altogether.

### Configure the sample code project

Because this sample app relies on using Bluetooth to connect with the accessory functionality, you can’t run this sample in Simulator — you’ll need to run it on a device. To run this sample, you’ll need the following:

- An Apple Developer profile.

- Two devices running iOS 18 or iPadOS 18 or later.

### Using the applications

1. Run the two targets on separate devices.

2. In `ASKSampleAccessory`, tap “Power On”.

3. In `ASKSample`, tap “Add Dice” and authorize the accessory using the AccessorySetupKit UI.

The accessory is now authorized for use in the app.

## See Also

### Essentials

Discovering and configuring accessories

Detect nearby accessories and facilitate their setup.

`class ASAccessorySession`

A class to coordinate accessory discovery.

---

# https://developer.apple.com/documentation/accessorysetupkit/discovering-and-configuring-accessories

- AccessorySetupKit
- Discovering and configuring accessories

Article

# Discovering and configuring accessories

Detect nearby accessories and facilitate their setup.

## Overview

Use the AccessorySetupKit framework to simplify discovery and configuration of Bluetooth or Wi-Fi accessories. This allows the person using your app to use these devices without granting overly-broad Bluetooth or Wi-Fi access.

To discover accessories and present them in your app:

1. Declare that your app uses AccessorySetupKit in its information property list.

2. In your app, create and activate an instance of `ASAccessorySession`.

3. Provide information about your supported accessories to display a picker. This lets the person using your app discover and select nearby accessories to configure.

4. When the picker sends an accessory added event, use information about the selected device to create a Bluetooth or Wi-Fi connection.

### Declare your app’s accessories

To prepare your app to discover accessories, add the `NSAccessorySetupKitSupports` key to its information property list. Set its value to an array of strings that contains one or more of the following values:

`Bluetooth`

Add this value if your app discovers accessories using Bluetooth or Bluetooth Low Energy.

`WiFi`

Add this value if your app discovers accessories by finding Wi-Fi SSIDs that the accessories publish.

If you add `Bluetooth` to the list of supported protocols, you also need to add the following keys and values to your app’s information property list:

`NSAccessorySetupBluetoothCompanyIdentifiers`

An array of strings that represent the Bluetooth company identifiers for accessories your app configures.

`NSAccessorySetupBluetoothNames`

An array of strings that represent the Bluetooth device names for accessories your app configures.

`NSAccessorySetupBluetoothServices`

An array of strings that represent the hexadecimal values of Bluetooth services for accessories your app configures.

### Activate a discovery session

The `ASAccessorySession` is how your app uses the AccessorySetupKit framework. In your app, you create an instance of `ASAccessorySession` and activate it to receive callbacks with events as the session processes events. The `activate(on:eventHandler:)` method takes a `DispatchQueue` and an event-handling block or closure. The callbacks occur on the provided queue, which defaults to `main`.

The event handler receives a single parameter of type `ASAccessoryEvent`, which has an `eventType` that you use to determine what to do with each callback. For example, shortly after activating the session, your callback receives the `ASAccessoryEventType.activated` event. The following listing comments on the meaning of these events and how you may want to handle them.

let session = ASAccessorySession()
override func viewDidLoad() {
super.viewDidLoad()

session.activate(on: DispatchQueue.main) { [weak self] event in
guard let self else { return }

switch event.eventType {
case .activated:
// Use previously-discovered accessories in
// session.accessories, if necessary.
case .accessoryAdded:
// Handle addition of an accessory by person using the app.
case .accessoryRemoved, .accessoryChanged:
// Handle removal or change of previously-added
// accessory, if necessary.
case .invalidated:
// The session is now invalid and you can't use it further.
case .migrationComplete:
// Handle migration.
case .pickerDidPresent:
// Update state for picker appearing, if necessary.
case .pickerDidDismiss:
// Update state for picker disappearing, if necessary.
case .unknown:
// Handle unknown event type, if appropriate.
@unknown default:
// Reserve this space for yet-to-be-defined event types.
}
}
}

### Display an accessory picker

When the session activates, its `accessories` array contains any accessories previously authorized for the app, which you can inspect. To discover new devices, your app needs to show an accessory picker. The person using the app uses this picker to choose the accessory to configure.

Create instances of `ASPickerDisplayItem` that describe the items in the session that your app can configure. Collect these items in an array and pass them to the session for the operating system to present a picker:

private func showMyPicker() {
var descriptor = ASDiscoveryDescriptor()
descriptor.bluetoothServiceUUID = CBUUID(string: MY_ACCESSORY_UUID_STRING) // If using Wi-Fi, set descriptor.ssid instead.

let displayName = "My Accessory"
guard let productImage = UIImage(named: MY_ACCESSORY_IMAGE_NAME) else { return }

var items: [ASPickerDisplayItem] = []
items.append (ASPickerDisplayItem(name: displayName,
productImage: productImage,
descriptor: descriptor))

// Create additional picker items if you support multiple accessories
// with different Wi-Fi SSIDs or Bluetooth service UUIDs.

session.showPicker(for: items) { error in
if let error {
// Handle error.
} else {
// Perform any post-picker cleanup.
// If the picker finished by selecting an item, the event
// handler receives it as an event of type `.accessoryAdded`.
}
}
}

Each display item’s `descriptor`, a property of type `ASDiscoveryDescriptor`, needs to have a `bluetoothCompanyIdentifier` or `bluetoothServiceUUID`, and at least one of the following accessory identifiers:

- `bluetoothNameSubstring`

- A `bluetoothManufacturerDataBlob` and `bluetoothManufacturerDataMask` set to the same length.

- A `bluetoothServiceDataBlob` and `bluetoothServiceDataMask` set to the same length.

- Either `ssid` or `ssidPrefix`, which needs to have a non-zero length. Only supply one of these; the app crashes if you supply both.

For Bluetooth accessories, the accessory identifiers you use in display items need to match the values you supply in the app’s information property list.

Along with filtering matched accessories to show in the picker, the display item and its descriptor allow you to control certain behaviors of the picker interaction. You can limit the `bluetoothRange` of the descriptor to only match accessories in the immediate physical proximity of the device running the app. To specify behaviors like allowing renaming of the accessory during setup, or confirming accessory authorization before showing the setup view, set the display item’s `setupOptions`.

When the picker appears, the person using the app sees a view of all nearby accessories that match the identifiers you provide. When multiple devices match a given identifier, the picker shows a separate item for each unique device. This allows the person to select a single device with the picker.

The following figure shows a single accessory selected in the picker.

### Use the picker when migrating to AccessorySetupKit

You can also perform a one-time migration of previously-configured accessories, which adds them to the AccessorySetupKit framework’s list of known accessories. To do this, create instances of `ASMigrationDisplayItem` and include them in the array of items you send to `showPicker(for:completionHandler:)`.

For items you want to migrate, set one or both of the following:

- An `hotspotSSID`, which must be a full SSID and not a prefix.

- An `peripheralIdentifier`, which corresponds to the `identifier` property of the `CBPeer` type.

### Perform custom filtering

Some apps need to obtain over-the-air (OTA) data from discovered accessories and perform additional filtering before showing them in the picker. The filtering includes tasks like validating the authenticity of an accessory, testing whether it’s in pairing mode, and other checks. If your app needs do this, set the picker’s display settings to use the `filterDiscoveryResults` option. If you need unlimited time to perform filtering and perform additional actions like downloading product artwork, set the `discoveryTimeout` to `unbounded`.

The following code performs these setup steps:

let settings = ASPickerDisplaySettings.default
settings.discoveryTimeout = .unbounded
settings.options.insert(.filterDiscoveryResults)
session.pickerDisplaySettings = settings

When the session produces an `ASAccessoryEventType.accessoryDiscovered` event, examine the accessory and determine whether to display it in the picker. To add the accessory to the picker, create a `ASDiscoveredDisplayItem`. Using this type gives you the option to customize the item’s display with a specific name and a custom image. Then call `updatePicker(showing:completionHandler:)` on the session to show the customized item.

The following example demonstrates an event handler that inspects discovered accessories and adds customized items to the picker.

session.activate(on: .main) { [weak self] event in
guard let strongSelf = self else { return }
switch event.eventType {
case .accessoryDiscovered:
if let accessory = event.accessory as? ASDiscoveredAccessory {
if myShouldDisplayAccessory(advertisement: accessory.bluetoothAdvertisementData,
rssi: accessory.bluetoothRSSI) {
let item = ASDiscoveredDisplayItem(name: "More Specific Product Name",
productImage: UIImage(named: "AssetPreparedJustInTime")!,
accessory: accessory)
session.updatePicker(showing: [item]) { error in
print(error)
}
}
}
}
}

If your custom filtering process requires the app to finish the accessory discovery early, manually end the discovery process by calling `finishPickerDiscovery(completionHandler:)`. If your filtering process didn’t add any discovered items to the picker, this call shows a timeout message in the app.

### Connect and configure the selected device

When the person picks an accessory, the picker sends an event of type `ASAccessoryEventType.accessoryAdded`, followed by an `ASAccessoryEventType.pickerDidDismiss` event when they dismiss the picker. If your app presents its own UI to configure the accessory, wait for the picker to dismiss, then use the accessory from the first event. You can handle this scenario by rewriting your event handler closure from before as follows, storing the accessory on the first event and retrieving it on the second.

case .accessoryAdded:
self.pickedAccessory = event.accessory
case .pickerDidDismiss:
guard let accessory = self.pickedAccessory else { return }
self.pickedAccessory = nil
self.handleAccessoryAdded(accessory)

The event’s `accessory` property contains details of the selected device, like its `displayName` and an `bluetoothIdentifier` for Bluetooth devices or `ssid` for Wi-Fi. Use this information to connect to the accessory — using Core Bluetooth for Bluetooth or Network Extension for Wi-Fi — and begin your device-specific setup process.

private func handleAccessoryAdded(_ accessory: ASAccessory) {
if let btIdentifier = accessory.bluetoothIdentifier {
// Use Core Bluetooth to communicate with and configure the accessory.
}
else if let ssid = accessory.ssid {
// Create a `NEHotspotConfiguration` with this SSID to configure.
}
}

Because the app discovered the device with AccessorySetupKit, connecting to the device won’t invoke the TCC or other alerts that the system normally shows when using these system frameworks.

Starting in watchOS 26, if your iOS app has a companion watchOS app, the watchOS app can use CoreBluetooth to communicate with a device that someone set up by using AccessorySetupKit in the iOS app. Unlike iOS, however, the watchOS app still shows TCC alerts when connecting.

## See Also

### Essentials

Setting up and authorizing a Bluetooth accessory

Discover, select, and set up a specific Bluetooth accessory without requesting permission to use Bluetooth.

`class ASAccessorySession`

A class to coordinate accessory discovery.

---

# https://developer.apple.com/documentation/accessorysetupkit/asaccessorysession

- AccessorySetupKit
- ASAccessorySession

Class

# ASAccessorySession

A class to coordinate accessory discovery.

class ASAccessorySession

## Mentioned in

Discovering and configuring accessories

## Overview

Use an instance of `ASAccessorySession` to interact with the AccessorySetupKit framework.

Start the session by calling `activate(on:eventHandler:)`, and pass in a dispatch queue and an event-handling closure. AccessorySetupKit calls instances to describe accessories your app can set up. Pass this array to the session’s `showPicker(for:completionHandler:)` method to allow someone using your app to choose a discovered accessory to set up. Your event handler receives events as the picker appears and dismisses, as well as when the person using the app adds an accessory.

## Topics

### Managing the session life cycle

Activate the session and start delivering events to an event handler.

`func invalidate()`

Invalidate the session by stopping any operations.

### Displaying an accessory picker

Present a picker that shows accessories managed by a Device Discovery Extension in your app.

Present a picker that shows discovered accessories matching an array of display items.

### Customizing picker behavior

`var pickerDisplaySettings: ASPickerDisplaySettings?`

Settings that affect the display of the accessory picker.

`class ASPickerDisplaySettings`

A type that contains settings to customize the display of the accessory picker

### Updating the picker

Updates the picker with app-filtered accessories.

### Ending filtered discovery

Finish the discovery session in the picker and show a timeout error.

### Accessing discovered accessories

[`var accessories: [ASAccessory]`](https://developer.apple.com/documentation/accessorysetupkit/asaccessorysession/accessories)

An array of previously-selected accessories for this application.

### Managing accessories

Displays a view to rename an accessory.

`struct RenameOptions`

Options that affect the behavior of an accessory renaming operation.

Removes an accessory.

### Managing authorization

Finish authorization of a partially-setup accessory.

`class ASAccessorySettings`

Properties of an accessory.

End authorization of a partially-configured accessory as a failure.

Displays a view to upgrade an accessory with additional technology permissions.

## Relationships

### Inherits From

- `NSObject`

### Conforms To

- `CVarArg`
- `CustomDebugStringConvertible`
- `CustomStringConvertible`
- `Equatable`
- `Hashable`
- `NSObjectProtocol`
- `Sendable`
- `SendableMetatype`

## See Also

### Essentials

Setting up and authorizing a Bluetooth accessory

Discover, select, and set up a specific Bluetooth accessory without requesting permission to use Bluetooth.

Detect nearby accessories and facilitate their setup.

---

# https://developer.apple.com/documentation/accessorysetupkit/asaccessoryevent

- AccessorySetupKit
- ASAccessoryEvent

Class

# ASAccessoryEvent

Properties of an event encountered during accessory discovery.

class ASAccessoryEvent

## Mentioned in

Discovering and configuring accessories

## Overview

The event handler you register with the session’s `activate(on:eventHandler:)` method receives objects of this type from the session. Each event identifies the type of event and which accessory (if any) is involved.

## Topics

### Inspecting the event

`var accessory: ASAccessory?`

The accessory involved in the event, if any.

`class ASAccessory`

An accessory discovered by the accessory session.

`var eventType: ASAccessoryEventType`

The type of event, such as accessory addition or removal, or picker presentation or removal.

`enum ASAccessoryEventType`

An enumeration of the types of events encountered during accessory discovery

### Handling errors

`var error: (any Error)?`

The error associated with the event, if any.

## Relationships

### Inherits From

- `NSObject`

### Conforms To

- `CVarArg`
- `CustomDebugStringConvertible`
- `CustomStringConvertible`
- `Equatable`
- `Hashable`
- `NSObjectProtocol`
- `Sendable`
- `SendableMetatype`

## See Also

### Accessory discovery

`class ASDiscoveryDescriptor`

Descriptive traits used to discover accessories.

---

# https://developer.apple.com/documentation/accessorysetupkit/asaccessoryeventtype

- AccessorySetupKit
- ASAccessoryEventType

Enumeration

# ASAccessoryEventType

An enumeration of the types of events encountered during accessory discovery

Mac Catalyst

enum ASAccessoryEventType

## Topics

### Creating an event type instance

`init?(rawValue: Int)`

### Accessory events

`case accessoryAdded`

The session added an accessory.

`case accessoryChanged`

The properties of an accessory changed.

`case accessoryRemoved`

The session removed an accessory.

### Life cycle events

`case activated`

The discovery session activated.

`case invalidated`

The discovery session invalidated.

### Discovery events

`case accessoryDiscovered`

The session discovered an accessory.

### Picker events

`case pickerDidPresent`

The discovery session picker appeared.

`case pickerDidDismiss`

The discovery session picker dismissed.

`case pickerSetupBridging`

The discovery session picker started bridging with an accessory.

`case pickerSetupPairing`

The discovery session picker started pairing with a Bluetooth accessory.

`case pickerSetupFailed`

The discovery session picker setup failed.

`case pickerSetupRename`

The discovery session picker started renaming an accessory.

### Migration events

`case migrationComplete`

The migration of an accessory completed.

### Unclassified events

`case unknown`

An unknown event occurred.

## Relationships

### Conforms To

- `BitwiseCopyable`
- `Equatable`
- `Hashable`
- `RawRepresentable`
- `Sendable`
- `SendableMetatype`

## See Also

### Accessory discovery

`class ASAccessoryEvent`

Properties of an event encountered during accessory discovery.

`class ASDiscoveryDescriptor`

Descriptive traits used to discover accessories.

---

# https://developer.apple.com/documentation/accessorysetupkit/asaccessory

- AccessorySetupKit
- ASAccessory

Class

# ASAccessory

An accessory discovered by the accessory session.

class ASAccessory

## Topics

### Accessing identifiers

`var bluetoothIdentifier: UUID?`

The accessory’s unique Bluetooth identifier, if any.

`var bluetoothTransportBridgingIdentifier: Data?`

The accessory’s Bluetooth identifier, if any, for use when bridging classic transport profiles.

`var ssid: String?`

The accessory’s Wi-Fi SSID, if any.

### Presenting a display name

`var displayName: String`

The accessory’s name, suitable for displaying to someone using your app.

### Inspecting the accessory’s descriptor

`var descriptor: ASDiscoveryDescriptor`

The descriptor used to discover the accessory.

### Inspecting accessory state

`var state: ASAccessory.AccessoryState`

The current authorization state of the accessory.

`enum AccessoryState`

An enumeration of possible authorization states of an accessory.

### Working with Wi-Fi Aware

`var wifiAwarePairedDeviceID: ASAccessory.WiFiAwarePairedDeviceID`

The accessory’s Wi-Fi Aware Pairing Identifier.

`typealias WiFiAwarePairedDeviceID`

The type used for an accessory’s Wi-Fi Aware Pairing Identifier.

## Relationships

### Inherits From

- `NSObject`

### Inherited By

- `ASDiscoveredAccessory`

### Conforms To

- `CVarArg`
- `CustomDebugStringConvertible`
- `CustomStringConvertible`
- `Equatable`
- `Hashable`
- `NSObjectProtocol`
- `Sendable`
- `SendableMetatype`

## See Also

### Accessory description

`class ASDiscoveredAccessory`

A discovered accessory, for use in creating a customized picker display item.

---

# https://developer.apple.com/documentation/accessorysetupkit/asdiscoveredaccessory

- AccessorySetupKit
- ASDiscoveredAccessory

Class

# ASDiscoveredAccessory

A discovered accessory, for use in creating a customized picker display item.

class ASDiscoveredAccessory

## Overview

When your app’s picker uses the `filterDiscoveryResults` option, you receive `ASAccessoryEventType.accessoryDiscovered` events that contain this type. Use the discovered accessory’s Bluetooth properties to create a new `ASDiscoveredDisplayItem`, incorporating traits like a custom accessory name or a newly downloaded product image. You can then add this item to the picker to allow the person using the app to set up the accessory.

## Topics

### Working with accessory properties

[`var bluetoothAdvertisementData: [AnyHashable : Any]?`](https://developer.apple.com/documentation/accessorysetupkit/asdiscoveredaccessory/bluetoothadvertisementdata)

The Bluetooth advertisement data from the discovered accessory.

`var bluetoothRSSI: Int?`

The Bluetooth RSSI (Received Signal Strength Indicator) value from the discovered accessory.

## Relationships

### Inherits From

- `ASAccessory`

### Conforms To

- `CVarArg`
- `CustomDebugStringConvertible`
- `CustomStringConvertible`
- `Equatable`
- `Hashable`
- `NSObjectProtocol`
- `Sendable`
- `SendableMetatype`

## See Also

### Accessory description

`class ASAccessory`

An accessory discovered by the accessory session.

`enum AccessoryState`

An enumeration of possible authorization states of an accessory.

---

# https://developer.apple.com/documentation/accessorysetupkit/asaccessory/accessorystate

- AccessorySetupKit
- ASAccessory
- ASAccessory.AccessoryState

Enumeration

# ASAccessory.AccessoryState

An enumeration of possible authorization states of an accessory.

enum AccessoryState

## Topics

### Creating a state instance

`init?(rawValue: Int)`

### Accessory states

`case unauthorized`

The accessory is invalid or unauthorized.

`case awaitingAuthorization`

The accessory is selected, but full authorization is still pending.

`case authorized`

The accessory is authorized and available.

## Relationships

### Conforms To

- `BitwiseCopyable`
- `Equatable`
- `Hashable`
- `RawRepresentable`
- `Sendable`
- `SendableMetatype`

## See Also

### Accessory description

`class ASAccessory`

An accessory discovered by the accessory session.

`class ASDiscoveredAccessory`

A discovered accessory, for use in creating a customized picker display item.

---

# https://developer.apple.com/documentation/accessorysetupkit/aspickerdisplayitem

- AccessorySetupKit
- ASPickerDisplayItem

Class

# ASPickerDisplayItem

An accessory as presented by the discovery picker.

class ASPickerDisplayItem

## Mentioned in

Discovering and configuring accessories

## Overview

Create instances of `ASPickerDisplayItem` that describe the accessories you want to discover. Each item contains a name and product image to display, plus an `ASDiscoveryDescriptor` that identifies the kind of accessories to match. Pass these in an array to `showPicker(for:completionHandler:)` to display a picker that allows the person using your app to discover and select nearby accessories.

Filter the matched accessories by supplying a `descriptor`, which contains various Bluetooth and Wi-Fi properties to match. The descriptor also allows you to set the `bluetoothRange` of matched accessories; set its value to `ASDiscoveryDescriptor.Range.immediate` to limit discovery of Bluetooth accessories to those within the immediate proximity of the device running your app.

To enable different behaviors during setup, use the `setupOptions` property, which is an option set (Swift) or bitfield (Objective-C) of behavior options. The defined options in `ASPickerDisplayItem.SetupOptions` allow you to specify behaviors like allowing renaming of the accessory during setup, or confirming accessory authorization before showing the setup view.

## Topics

### Creating a display item

`init(name: String, productImage: UIImage, descriptor: ASDiscoveryDescriptor)`

Creates a picker display item with a name and image to display and a descriptor to match discovered accessories.

### Specifying discovery properties

`var descriptor: ASDiscoveryDescriptor`

A descriptor that the picker uses to determine which discovered accessories to display.

### Customizing display properties

`var name: String`

The accessory name to display in the picker.

`var productImage: UIImage`

An image of the accessory to display in the picker.

### Customizing setup options

`var setupOptions: ASPickerDisplayItem.SetupOptions`

Custom setup options for the accessory.

`struct SetupOptions`

Setup options offered by the accessory picker.

`var renameOptions: ASAccessory.RenameOptions`

Options to allow renaming a matched accessory.

`struct RenameOptions`

Options that affect the behavior of an accessory renaming operation.

## Relationships

### Inherits From

- `NSObject`

### Inherited By

- `ASDiscoveredDisplayItem`
- `ASMigrationDisplayItem`

### Conforms To

- `CVarArg`
- `CustomDebugStringConvertible`
- `CustomStringConvertible`
- `Equatable`
- `Hashable`
- `NSObjectProtocol`
- `Sendable`
- `SendableMetatype`

## See Also

### Displaying picker items

`class ASDiscoveredDisplayItem`

A picker display item created from customizing a discovered accessory.

`class ASMigrationDisplayItem`

A previously-discovered accessory as presented by the discovery picker, for use when migrating it to AccessorySetupKit.

---

# https://developer.apple.com/documentation/accessorysetupkit/asdiscovereddisplayitem

- AccessorySetupKit
- ASDiscoveredDisplayItem

Class

# ASDiscoveredDisplayItem

A picker display item created from customizing a discovered accessory.

class ASDiscoveredDisplayItem

## Mentioned in

Discovering and configuring accessories

## Overview

Use this type when your app’s picker uses the `filterDiscoveryResults` option. With this option enabled, your discovery session receives `ASAccessoryEventType.accessoryDiscovered` events with discovered accessories. To include a discovered accessory in the picker, create an instance of this class, optionally using the Bluetooth properties of the event’s `ASDiscoveredAccessory` to provide a more specific name or product image. Then send the `ASDiscoveredDisplayItem` to the picker with the session’s `updatePicker(showing:completionHandler:)` method.

## Topics

### Creating an updated display item

`init(name: String, productImage: UIImage, accessory: ASDiscoveredAccessory)`

Creates a discovered picker display item with a name and image to display and a descriptor to match discovered accessories.

## Relationships

### Inherits From

- `ASPickerDisplayItem`

### Conforms To

- `CVarArg`
- `CustomDebugStringConvertible`
- `CustomStringConvertible`
- `Equatable`
- `Hashable`
- `NSObjectProtocol`
- `Sendable`
- `SendableMetatype`

## See Also

### Displaying picker items

`class ASPickerDisplayItem`

An accessory as presented by the discovery picker.

`class ASMigrationDisplayItem`

A previously-discovered accessory as presented by the discovery picker, for use when migrating it to AccessorySetupKit.

---

# https://developer.apple.com/documentation/accessorysetupkit/asmigrationdisplayitem

- AccessorySetupKit
- ASMigrationDisplayItem

Class

# ASMigrationDisplayItem

A previously-discovered accessory as presented by the discovery picker, for use when migrating it to AccessorySetupKit.

class ASMigrationDisplayItem

## Mentioned in

Discovering and configuring accessories

## Overview

Create instances of `ASMigrationDisplayItem` by calling the superclass’s initializer `init(name:productImage:descriptor:)`, then specify the Bluetooth `peripheralIdentifier`, the Wi-Fi `hotspotSSID`, or both, for the specific accessory you want to migrate.

## Topics

### Accessory identifiers

`var peripheralIdentifier: UUID?`

The Bluetooth identifier of the accessory to migrate.

`var hotspotSSID: String?`

The Wi-Fi hotspot SSID of the accessory to migrate.

`var wifiAwarePairedDeviceID: ASAccessory.WiFiAwarePairedDeviceID`

The Wi-Fi Aware paired device identififer of the accessory to migrate.

## Relationships

### Inherits From

- `ASPickerDisplayItem`

### Conforms To

- `CVarArg`
- `CustomDebugStringConvertible`
- `CustomStringConvertible`
- `Equatable`
- `Hashable`
- `NSObjectProtocol`
- `Sendable`
- `SendableMetatype`

## See Also

### Displaying picker items

`class ASPickerDisplayItem`

An accessory as presented by the discovery picker.

`class ASDiscoveredDisplayItem`

A picker display item created from customizing a discovered accessory.

---

# https://developer.apple.com/documentation/accessorysetupkit/aserror

- AccessorySetupKit
- ASError

Structure

# ASError

An error encountered during accessory discovery.

struct ASError

## Topics

### Activation errors

`static var activationFailed: ASError.Code`

### Life cycle errors

`static var invalidated: ASError.Code`

### Configuration errors

`static var extensionNotFound: ASError.Code`

`static var invalidRequest: ASError.Code`

### Picker errors

`static var pickerRestricted: ASError.Code`

`static var pickerAlreadyActive: ASError.Code`

### Cancellation and permission errors

`static var userCancelled: ASError.Code`

`static var userRestricted: ASError.Code`

### Communication errors

`static var connectionFailed: ASError.Code`

`static var discoveryTimeout: ASError.Code`

### Success cases

`static var success: ASError.Code`

### Unclassified errors

`static var unknown: ASError.Code`

### Accessing the error domain

`static var errorDomain: String`

`let ASErrorDomain: String`

NSError domain for AccessorySetupKit errors.

## Relationships

### Conforms To

- `CustomNSError`
- `Equatable`
- `Error`
- `Hashable`
- `Sendable`
- `SendableMetatype`

## See Also

### Errors

`enum Code`

Codes that describe errors encountered during accessory discovery.

---

# https://developer.apple.com/documentation/accessorysetupkit/aserrordomain

- AccessorySetupKit
- ASErrorDomain

Global Variable

# ASErrorDomain

NSError domain for AccessorySetupKit errors.

Mac Catalyst

let ASErrorDomain: String

## See Also

### Errors

`struct ASError`

An error encountered during accessory discovery.

`enum Code`

Codes that describe errors encountered during accessory discovery.

---

# https://developer.apple.com/documentation/accessorysetupkit/aserror/code

- AccessorySetupKit
- ASError
- ASError.Code

Enumeration

# ASError.Code

Codes that describe errors encountered during accessory discovery.

enum Code

## Topics

### Activation errors

`case activationFailed`

Session activation failed.

### Timeout and life cycle errors

`case discoveryTimeout`

Accessory discovery timed out.

`case invalidated`

The session invalidated prior to completing the operation.

### Configuration errors

`case extensionNotFound`

The framework couldn’t find the app extension.

`case userRestricted`

The person using the app restricted access.

`case invalidRequest`

The session received an invalid request.

### Picker errors

`case pickerRestricted`

The picker can’t be used because the app is in the background.

`case pickerAlreadyActive`

The picker received a show request when it was already active.

### Cancellation errors

`case userCancelled`

The person using the app canceled the operation.

### Communication errors

`case connectionFailed`

The session was unable to establish a connection.

### Success cases

`case success`

A code that represents a successful action.

### Unclassified errors

`case unknown`

An underlying failure with an unknown cause.

### Accessing the error domain

`static var errorDomain: String`

`let ASErrorDomain: String`

NSError domain for AccessorySetupKit errors.

### Working with raw values

`init?(rawValue: Int)`

## Relationships

### Conforms To

- `BitwiseCopyable`
- `Equatable`
- `Hashable`
- `RawRepresentable`
- `Sendable`
- `SendableMetatype`

## See Also

### Errors

`struct ASError`

An error encountered during accessory discovery.

---

# https://developer.apple.com/documentation/accessorysetupkit/asdiscoverydescriptor)



---

# https://developer.apple.com/documentation/accessorysetupkit/setting-up-and-authorizing-a-bluetooth-accessory)

# The page you're looking for can't be found.

Search developer.apple.comSearch Icon

---

# https://developer.apple.com/documentation/accessorysetupkit/discovering-and-configuring-accessories)

# The page you're looking for can't be found.

Search developer.apple.comSearch Icon

---

# https://developer.apple.com/documentation/accessorysetupkit/asaccessorysession)



---

# https://developer.apple.com/documentation/accessorysetupkit/asaccessoryevent)



---

# https://developer.apple.com/documentation/accessorysetupkit/asaccessoryeventtype)



---

# https://developer.apple.com/documentation/accessorysetupkit/asaccessory)



---

# https://developer.apple.com/documentation/accessorysetupkit/asdiscoveredaccessory)



---

# https://developer.apple.com/documentation/accessorysetupkit/asaccessory/accessorystate)

# The page you're looking for can't be found.

Search developer.apple.comSearch Icon

---

# https://developer.apple.com/documentation/accessorysetupkit/aspickerdisplayitem)



---

# https://developer.apple.com/documentation/accessorysetupkit/asdiscovereddisplayitem)



---

# https://developer.apple.com/documentation/accessorysetupkit/asmigrationdisplayitem)



---

# https://developer.apple.com/documentation/accessorysetupkit/aserror)



---

# https://developer.apple.com/documentation/accessorysetupkit/aserrordomain)



---

# https://developer.apple.com/documentation/accessorysetupkit/aserror/code)



---

# https://developer.apple.com/documentation/accessorysetupkit/asaccessory/accessorystate/init(rawvalue:)

#app-main)

- AccessorySetupKit
- ASAccessory
- ASAccessory.AccessoryState
- init(rawValue:)

Initializer

# init(rawValue:)

init?(rawValue: Int)

---

# https://developer.apple.com/documentation/accessorysetupkit/asaccessory/accessorystate/unauthorized

- AccessorySetupKit
- ASAccessory
- ASAccessory.AccessoryState
- ASAccessory.AccessoryState.unauthorized

Case

# ASAccessory.AccessoryState.unauthorized

The accessory is invalid or unauthorized.

case unauthorized

## See Also

### Accessory states

`case awaitingAuthorization`

The accessory is selected, but full authorization is still pending.

`case authorized`

The accessory is authorized and available.

---

# https://developer.apple.com/documentation/accessorysetupkit/asaccessory/accessorystate/awaitingauthorization

- AccessorySetupKit
- ASAccessory
- ASAccessory.AccessoryState
- ASAccessory.AccessoryState.awaitingAuthorization

Case

# ASAccessory.AccessoryState.awaitingAuthorization

The accessory is selected, but full authorization is still pending.

case awaitingAuthorization

## See Also

### Accessory states

`case unauthorized`

The accessory is invalid or unauthorized.

`case authorized`

The accessory is authorized and available.

---

# https://developer.apple.com/documentation/accessorysetupkit/asaccessory/accessorystate/authorized

- AccessorySetupKit
- ASAccessory
- ASAccessory.AccessoryState
- ASAccessory.AccessoryState.authorized

Case

# ASAccessory.AccessoryState.authorized

The accessory is authorized and available.

case authorized

## See Also

### Accessory states

`case unauthorized`

The accessory is invalid or unauthorized.

`case awaitingAuthorization`

The accessory is selected, but full authorization is still pending.

---

# https://developer.apple.com/documentation/accessorysetupkit/asaccessory/accessorystate/init(rawvalue:))

)#app-main)

# The page you're looking for can't be found.

Search developer.apple.comSearch Icon

---

# https://developer.apple.com/documentation/accessorysetupkit/asaccessory/accessorystate/unauthorized)

# The page you're looking for can't be found.

Search developer.apple.comSearch Icon

---

# https://developer.apple.com/documentation/accessorysetupkit/asaccessory/accessorystate/awaitingauthorization)

# The page you're looking for can't be found.

Search developer.apple.comSearch Icon

---

# https://developer.apple.com/documentation/accessorysetupkit/asaccessory/accessorystate/authorized)

# The page you're looking for can't be found.

Search developer.apple.comSearch Icon

---

# https://developer.apple.com/documentation/accessorysetupkit/asaccessorysession/activate(on:eventhandler:)

#app-main)

- AccessorySetupKit
- ASAccessorySession
- activate(on:eventHandler:)

Instance Method

# activate(on:eventHandler:)

Activate the session and start delivering events to an event handler.

func activate(
on queue: dispatch_queue_t,

)

## Parameters

`queue`

The dispatch the session uses to deliver events to `eventHandler`.

`eventHandler`

A closure or block that receives events generated by the session. Each call as a parameter, and expects no return value.

## Mentioned in

Discovering and configuring accessories

## See Also

### Managing the session life cycle

`func invalidate()`

Invalidate the session by stopping any operations.

---

# https://developer.apple.com/documentation/accessorysetupkit/asaccessorysession/showpicker(for:completionhandler:)

#app-main)

- AccessorySetupKit
- ASAccessorySession
- showPicker(for:completionHandler:)

Instance Method

# showPicker(for:completionHandler:)

Present a picker that shows discovered accessories matching an array of display items.

func showPicker(
for displayItems: [ASPickerDisplayItem],

)
func showPicker(for displayItems: [ASPickerDisplayItem]) async throws

## Parameters

`displayItems`

An array of `ASPickerDisplayItem` instances describing accessories your app can set up. The picker displays only discovered accessories that match the properties of items in this array.

`completionHandler`

A block or closure that the picker calls when it completes the operation. The completion handler receives an `NSError` instance if the picker encounters an error.

## Mentioned in

Discovering and configuring accessories

## Discussion

The session’s event handler receives events when this picker displays and dismisses, as well as when the person using the app picks an accessory.

To migrate previously-configured accessories to AccessorySetupKit, add instances of `ASMigrationDisplayItem` to the `displayItems` array.

## See Also

### Displaying an accessory picker

Present a picker that shows accessories managed by a Device Discovery Extension in your app.

---

# https://developer.apple.com/documentation/accessorysetupkit/asaccessorysession/invalidate()

#app-main)

- AccessorySetupKit
- ASAccessorySession
- invalidate()

Instance Method

# invalidate()

Invalidate the session by stopping any operations.

func invalidate()

## Discussion

This call breaks any retain cycles. The session is unusable after calling `invalidate`.

## See Also

### Managing the session life cycle

Activate the session and start delivering events to an event handler.

---

# https://developer.apple.com/documentation/accessorysetupkit/asaccessorysession/showpicker(completionhandler:)

#app-main)

- AccessorySetupKit
- ASAccessorySession
- showPicker(completionHandler:)

Instance Method

# showPicker(completionHandler:)

Present a picker that shows accessories managed by a Device Discovery Extension in your app.

func showPicker() async throws

## Parameters

`completionHandler`

A block or closure that the picker calls when it completes the operation. The completion handler receives an `NSError` instance if the picker encounters an error.

## Discussion

Use this method when your app includes a DeviceDiscoveryExtension for its supported accessories. If your app doesn’t use DDE, call `showPicker(for:completionHandler:)` with an array of `ASPickerDisplayItem` instances instead.

The session’s event handler receives events when this picker displays and dismisses, as well as when the person using the app picks an accessory.

## See Also

### Displaying an accessory picker

Present a picker that shows discovered accessories matching an array of display items.

---

# https://developer.apple.com/documentation/accessorysetupkit/asaccessorysession/pickerdisplaysettings

- AccessorySetupKit
- ASAccessorySession
- pickerDisplaySettings

Instance Property

# pickerDisplaySettings

Settings that affect the display of the accessory picker.

@NSCopying
var pickerDisplaySettings: ASPickerDisplaySettings? { get set }

## Discussion

Use this property to configure settings like the picker timeout.

## See Also

### Customizing picker behavior

`class ASPickerDisplaySettings`

A type that contains settings to customize the display of the accessory picker

---

# https://developer.apple.com/documentation/accessorysetupkit/aspickerdisplaysettings

- AccessorySetupKit
- ASPickerDisplaySettings

Class

# ASPickerDisplaySettings

A type that contains settings to customize the display of the accessory picker

class ASPickerDisplaySettings

## Topics

### Accessing the default instance

``class var `default`: ASPickerDisplaySettings``

An empty settings object.

### Customizing the discovery timeout

`var discoveryTimeout: ASPickerDisplaySettings.DiscoveryTimeout`

Custom timeout for picker. Default is 30 seconds.

`struct DiscoveryTimeout`

The type used for the accessory picker’s discovery timeout value.

### Customizing picker options

`var options: ASPickerDisplaySettings.Options`

Custom options for the picker.

`struct Options`

Options offered by the accessory picker.

## Relationships

### Inherits From

- `NSObject`

### Conforms To

- `CVarArg`
- `CustomDebugStringConvertible`
- `CustomStringConvertible`
- `Equatable`
- `Hashable`
- `NSObjectProtocol`
- `Sendable`
- `SendableMetatype`

## See Also

### Customizing picker behavior

`var pickerDisplaySettings: ASPickerDisplaySettings?`

Settings that affect the display of the accessory picker.

---

# https://developer.apple.com/documentation/accessorysetupkit/asaccessorysession/finishpickerdiscovery(completionhandler:)

#app-main)

- AccessorySetupKit
- ASAccessorySession
- finishPickerDiscovery(completionHandler:)

Instance Method

# finishPickerDiscovery(completionHandler:)

Finish the discovery session in the picker and show a timeout error.

func finishPickerDiscovery() async throws

## Parameters

`completionHandler`

A block or closure that executes after this operation completes. The completion handler receives an `NSError` instance if the operation encounters an error.

## Mentioned in

Discovering and configuring accessories

## Discussion

Use this method if you previously set the picker display setting `discoveryTimeout` to `unbounded` in order to perform manual filtering of discovered accessories. Calling this method finishes the discovery session in the picker and shows a timeout error if the session didn’t find any desired accessories.

Calling this method after updating the picker with discovered accessories has no effect.

---

# https://developer.apple.com/documentation/accessorysetupkit/asaccessorysession/renameaccessory(_:options:completionhandler:)

#app-main)

- AccessorySetupKit
- ASAccessorySession
- renameAccessory(\_:options:completionHandler:)

Instance Method

# renameAccessory(\_:options:completionHandler:)

Displays a view to rename an accessory.

func renameAccessory(
_ accessory: ASAccessory,
options renameOptions: ASAccessory.RenameOptions = [],

)
func renameAccessory(
_ accessory: ASAccessory,
options renameOptions: ASAccessory.RenameOptions = []
) async throws

## Parameters

`accessory`

The accessory to rename.

`renameOptions`

Options that affect the behavior of the rename operation.

`completionHandler`

A block or closure that executes after the rename operation completes. The completion handler receives an `NSError` instance if the rename operation encounters an error.

## Discussion

To rename a Wi-Fi SSID with this method, use the option `ssid`.

## See Also

### Managing accessories

`struct RenameOptions`

Options that affect the behavior of an accessory renaming operation.

Removes an accessory.

---

# https://developer.apple.com/documentation/accessorysetupkit/asaccessory/renameoptions

- AccessorySetupKit
- ASAccessory
- ASAccessory.RenameOptions

Structure

# ASAccessory.RenameOptions

Options that affect the behavior of an accessory renaming operation.

struct RenameOptions

## Topics

### Creating an options instance

`init(rawValue: UInt)`

### Options

`static var ssid: ASAccessory.RenameOptions`

An option to change an accessory’s SSID along with its display name.

## Relationships

### Conforms To

- `BitwiseCopyable`
- `Equatable`
- `ExpressibleByArrayLiteral`
- `OptionSet`
- `RawRepresentable`
- `Sendable`
- `SendableMetatype`
- `SetAlgebra`

## See Also

### Managing accessories

Displays a view to rename an accessory.

Removes an accessory.

---

# https://developer.apple.com/documentation/accessorysetupkit/asaccessorysession/removeaccessory(_:completionhandler:)

#app-main)

- AccessorySetupKit
- ASAccessorySession
- removeAccessory(\_:completionHandler:)

Instance Method

# removeAccessory(\_:completionHandler:)

Removes an accessory.

func removeAccessory(
_ accessory: ASAccessory,

)
func removeAccessory(_ accessory: ASAccessory) async throws

## Parameters

`accessory`

The accessory to remove.

`completionHandler`

A block or closure that executes after the remove operation completes. The completion handler receives an `NSError` instance if the remove operation encounters an error.

## See Also

### Managing accessories

Displays a view to rename an accessory.

`struct RenameOptions`

Options that affect the behavior of an accessory renaming operation.

---

# https://developer.apple.com/documentation/accessorysetupkit/asaccessorysession/finishauthorization(for:settings:completionhandler:)

#app-main)

- AccessorySetupKit
- ASAccessorySession
- finishAuthorization(for:settings:completionHandler:)

Instance Method

# finishAuthorization(for:settings:completionHandler:)

Finish authorization of a partially-setup accessory.

func finishAuthorization(
for accessory: ASAccessory,
settings: ASAccessorySettings,

)
func finishAuthorization(
for accessory: ASAccessory,
settings: ASAccessorySettings
) async throws

## Discussion

Use this method in scenarios where an accessory has multiple wireless interfaces. For example, when an accessory has both Bluetooth and Wi-Fi, and your descriptor may only provides an SSID prefix. In this case, the Bluetooth interface onboards first and your app needs to then finish authorization with the full SSID.

## See Also

### Managing authorization

`class ASAccessorySettings`

Properties of an accessory.

End authorization of a partially-configured accessory as a failure.

Displays a view to upgrade an accessory with additional technology permissions.

---

# https://developer.apple.com/documentation/accessorysetupkit/asaccessorysettings

- AccessorySetupKit
- ASAccessorySettings

Class

# ASAccessorySettings

Properties of an accessory.

class ASAccessorySettings

## Topics

### Applying default settings

``class var `default`: ASAccessorySettings``

An empty settings object.

### Inspecting accessory settings

`var ssid: String?`

A hotspot identifier that clients can use to connect to an accessory’s hotspot.

`var bluetoothTransportBridgingIdentifier: Data?`

A 6-byte identifier for bridging classic transport profiles.

## Relationships

### Inherits From

- `NSObject`

### Conforms To

- `CVarArg`
- `CustomDebugStringConvertible`
- `CustomStringConvertible`
- `Equatable`
- `Hashable`
- `NSObjectProtocol`
- `Sendable`
- `SendableMetatype`

## See Also

### Managing authorization

Finish authorization of a partially-setup accessory.

End authorization of a partially-configured accessory as a failure.

Displays a view to upgrade an accessory with additional technology permissions.

---

# https://developer.apple.com/documentation/accessorysetupkit/asaccessorysession/failauthorization(for:completionhandler:)

#app-main)

- AccessorySetupKit
- ASAccessorySession
- failAuthorization(for:completionHandler:)

Instance Method

# failAuthorization(for:completionHandler:)

End authorization of a partially-configured accessory as a failure.

func failAuthorization(
for accessory: ASAccessory,

)
func failAuthorization(for accessory: ASAccessory) async throws

## See Also

### Managing authorization

Finish authorization of a partially-setup accessory.

`class ASAccessorySettings`

Properties of an accessory.

Displays a view to upgrade an accessory with additional technology permissions.

---

# https://developer.apple.com/documentation/accessorysetupkit/asaccessorysession/updateauthorization(for:descriptor:completionhandler:)

#app-main)

- AccessorySetupKit
- ASAccessorySession
- updateAuthorization(for:descriptor:completionHandler:)

Instance Method

# updateAuthorization(for:descriptor:completionHandler:)

Displays a view to upgrade an accessory with additional technology permissions.

func updateAuthorization(
for accessory: ASAccessory,
descriptor: ASDiscoveryDescriptor,

)
func updateAuthorization(
for accessory: ASAccessory,
descriptor: ASDiscoveryDescriptor
) async throws

## Parameters

`accessory`

The accessory to update.

`descriptor`

An updated descriptor that the picker uses to add new technology authorization for the provided accessory.

`completionHandler`

A block or closure that executes after the picker is shown. The completion handler receives an `NSError` instance if the upgrade operation encounters an error. In Swift, you can omit the completion handler by calling the method asynchronously and catching any error thrown by the method.

## Discussion

Call this method to upgrade previously-added SSID-based accessories to use WiFi Aware.

## See Also

### Managing authorization

Finish authorization of a partially-setup accessory.

`class ASAccessorySettings`

Properties of an accessory.

End authorization of a partially-configured accessory as a failure.

---

# https://developer.apple.com/documentation/accessorysetupkit/asaccessorysession/activate(on:eventhandler:)),

),#app-main)

# The page you're looking for can't be found.

Search developer.apple.comSearch Icon

---

# https://developer.apple.com/documentation/accessorysetupkit/asaccessorysession/showpicker(for:completionhandler:))

)#app-main)

# The page you're looking for can't be found.

Search developer.apple.comSearch Icon

---

# https://developer.apple.com/documentation/accessorysetupkit/asaccessorysession/activate(on:eventhandler:))

)#app-main)

# The page you're looking for can't be found.

Search developer.apple.comSearch Icon

---

# https://developer.apple.com/documentation/accessorysetupkit/asaccessorysession/invalidate())

)#app-main)

# The page you're looking for can't be found.

Search developer.apple.comSearch Icon

---

# https://developer.apple.com/documentation/accessorysetupkit/asaccessorysession/showpicker(completionhandler:))

)#app-main)

# The page you're looking for can't be found.

Search developer.apple.comSearch Icon

---

# https://developer.apple.com/documentation/accessorysetupkit/asaccessorysession/pickerdisplaysettings)

# The page you're looking for can't be found.

Search developer.apple.comSearch Icon

---

# https://developer.apple.com/documentation/accessorysetupkit/aspickerdisplaysettings)



---

# https://developer.apple.com/documentation/accessorysetupkit/asaccessorysession/updatepicker(showing:completionhandler:))

)#app-main)

# The page you're looking for can't be found.

Search developer.apple.comSearch Icon

---

# https://developer.apple.com/documentation/accessorysetupkit/asaccessorysession/finishpickerdiscovery(completionhandler:))

)#app-main)

# The page you're looking for can't be found.

Search developer.apple.comSearch Icon

---

# https://developer.apple.com/documentation/accessorysetupkit/asaccessorysession/accessories)

# The page you're looking for can't be found.

Search developer.apple.comSearch Icon

---

# https://developer.apple.com/documentation/accessorysetupkit/asaccessorysession/renameaccessory(_:options:completionhandler:))

)#app-main)

# The page you're looking for can't be found.

Search developer.apple.comSearch Icon

---

# https://developer.apple.com/documentation/accessorysetupkit/asaccessory/renameoptions)

# The page you're looking for can't be found.

Search developer.apple.comSearch Icon

---

# https://developer.apple.com/documentation/accessorysetupkit/asaccessorysession/removeaccessory(_:completionhandler:))

)#app-main)

# The page you're looking for can't be found.

Search developer.apple.comSearch Icon

---

# https://developer.apple.com/documentation/accessorysetupkit/asaccessorysession/finishauthorization(for:settings:completionhandler:))

)#app-main)

# The page you're looking for can't be found.

Search developer.apple.comSearch Icon

---

# https://developer.apple.com/documentation/accessorysetupkit/asaccessorysettings)



---

# https://developer.apple.com/documentation/accessorysetupkit/asaccessorysession/failauthorization(for:completionhandler:))

)#app-main)

# The page you're looking for can't be found.

Search developer.apple.comSearch Icon

---

# https://developer.apple.com/documentation/accessorysetupkit/asaccessorysession/updateauthorization(for:descriptor:completionhandler:))

)#app-main)

# The page you're looking for can't be found.

Search developer.apple.comSearch Icon

---

# https://developer.apple.com/documentation/accessorysetupkit/aspickerdisplayitem/descriptor

- AccessorySetupKit
- ASPickerDisplayItem
- descriptor

Instance Property

# descriptor

A descriptor that the picker uses to determine which discovered accessories to display.

@NSCopying
var descriptor: ASDiscoveryDescriptor { get }

## Mentioned in

Discovering and configuring accessories

---

# https://developer.apple.com/documentation/accessorysetupkit/asdiscoverydescriptor/bluetoothserviceuuid

- AccessorySetupKit
- ASDiscoveryDescriptor
- bluetoothServiceUUID

Instance Property

# bluetoothServiceUUID

The accessory’s Bluetooth service UUID.

@NSCopying
var bluetoothServiceUUID: CBUUID? { get set }

## Mentioned in

Discovering and configuring accessories

## See Also

### Specifying Bluetooth properties

`var bluetoothCompanyIdentifier: ASBluetoothCompanyIdentifier`

The accessory’s 16-bit Bluetooth Company Identifier.

`struct ASBluetoothCompanyIdentifier`

The type used to identify a Bluetooth accessory provider.

`var bluetoothManufacturerDataBlob: Data?`

A byte buffer that matches the accessory’s Bluetooth manufacturer data.

`var bluetoothManufacturerDataMask: Data?`

The accessory’s Bluetooth manufacturer data mask.

`var bluetoothServiceDataBlob: Data?`

A byte buffer that matches the accessory’s Bluetooth service data.

`var bluetoothServiceDataMask: Data?`

The accessory’s Bluetooth service data mask.

`var bluetoothNameSubstring: String?`

The accessory’s over-the-air Bluetooth name substring.

`var bluetoothNameSubstringCompareOptions: NSString.CompareOptions`

The accessory’s over-the-air Bluetooth name substring compare options.

`var bluetoothRange: ASDiscoveryDescriptor.Range`

A property that tells the session to discover accessories within a specific Bluetooth range.

`enum Range`

The Bluetooth range in which to discover accessories.

---

# https://developer.apple.com/documentation/accessorysetupkit/asdiscoverydescriptor/bluetoothcompanyidentifier

- AccessorySetupKit
- ASDiscoveryDescriptor
- bluetoothCompanyIdentifier

Instance Property

# bluetoothCompanyIdentifier

The accessory’s 16-bit Bluetooth Company Identifier.

var bluetoothCompanyIdentifier: ASBluetoothCompanyIdentifier { get set }

## Mentioned in

Discovering and configuring accessories

## See Also

### Specifying Bluetooth properties

`struct ASBluetoothCompanyIdentifier`

The type used to identify a Bluetooth accessory provider.

`var bluetoothManufacturerDataBlob: Data?`

A byte buffer that matches the accessory’s Bluetooth manufacturer data.

`var bluetoothManufacturerDataMask: Data?`

The accessory’s Bluetooth manufacturer data mask.

`var bluetoothServiceDataBlob: Data?`

A byte buffer that matches the accessory’s Bluetooth service data.

`var bluetoothServiceDataMask: Data?`

The accessory’s Bluetooth service data mask.

`var bluetoothNameSubstring: String?`

The accessory’s over-the-air Bluetooth name substring.

`var bluetoothNameSubstringCompareOptions: NSString.CompareOptions`

The accessory’s over-the-air Bluetooth name substring compare options.

`var bluetoothServiceUUID: CBUUID?`

The accessory’s Bluetooth service UUID.

`var bluetoothRange: ASDiscoveryDescriptor.Range`

A property that tells the session to discover accessories within a specific Bluetooth range.

`enum Range`

The Bluetooth range in which to discover accessories.

---

# https://developer.apple.com/documentation/accessorysetupkit/asdiscoverydescriptor/bluetoothnamesubstring

- AccessorySetupKit
- ASDiscoveryDescriptor
- bluetoothNameSubstring

Instance Property

# bluetoothNameSubstring

The accessory’s over-the-air Bluetooth name substring.

var bluetoothNameSubstring: String? { get set }

## Mentioned in

Discovering and configuring accessories

## See Also

### Specifying Bluetooth properties

`var bluetoothCompanyIdentifier: ASBluetoothCompanyIdentifier`

The accessory’s 16-bit Bluetooth Company Identifier.

`struct ASBluetoothCompanyIdentifier`

The type used to identify a Bluetooth accessory provider.

`var bluetoothManufacturerDataBlob: Data?`

A byte buffer that matches the accessory’s Bluetooth manufacturer data.

`var bluetoothManufacturerDataMask: Data?`

The accessory’s Bluetooth manufacturer data mask.

`var bluetoothServiceDataBlob: Data?`

A byte buffer that matches the accessory’s Bluetooth service data.

`var bluetoothServiceDataMask: Data?`

The accessory’s Bluetooth service data mask.

`var bluetoothNameSubstringCompareOptions: NSString.CompareOptions`

The accessory’s over-the-air Bluetooth name substring compare options.

`var bluetoothServiceUUID: CBUUID?`

The accessory’s Bluetooth service UUID.

`var bluetoothRange: ASDiscoveryDescriptor.Range`

A property that tells the session to discover accessories within a specific Bluetooth range.

`enum Range`

The Bluetooth range in which to discover accessories.

---

# https://developer.apple.com/documentation/accessorysetupkit/asdiscoverydescriptor/bluetoothmanufacturerdatablob

- AccessorySetupKit
- ASDiscoveryDescriptor
- bluetoothManufacturerDataBlob

Instance Property

# bluetoothManufacturerDataBlob

A byte buffer that matches the accessory’s Bluetooth manufacturer data.

var bluetoothManufacturerDataBlob: Data? { get set }

## Mentioned in

Discovering and configuring accessories

## See Also

### Specifying Bluetooth properties

`var bluetoothCompanyIdentifier: ASBluetoothCompanyIdentifier`

The accessory’s 16-bit Bluetooth Company Identifier.

`struct ASBluetoothCompanyIdentifier`

The type used to identify a Bluetooth accessory provider.

`var bluetoothManufacturerDataMask: Data?`

The accessory’s Bluetooth manufacturer data mask.

`var bluetoothServiceDataBlob: Data?`

A byte buffer that matches the accessory’s Bluetooth service data.

`var bluetoothServiceDataMask: Data?`

The accessory’s Bluetooth service data mask.

`var bluetoothNameSubstring: String?`

The accessory’s over-the-air Bluetooth name substring.

`var bluetoothNameSubstringCompareOptions: NSString.CompareOptions`

The accessory’s over-the-air Bluetooth name substring compare options.

`var bluetoothServiceUUID: CBUUID?`

The accessory’s Bluetooth service UUID.

`var bluetoothRange: ASDiscoveryDescriptor.Range`

A property that tells the session to discover accessories within a specific Bluetooth range.

`enum Range`

The Bluetooth range in which to discover accessories.

---

# https://developer.apple.com/documentation/accessorysetupkit/asdiscoverydescriptor/bluetoothmanufacturerdatamask

- AccessorySetupKit
- ASDiscoveryDescriptor
- bluetoothManufacturerDataMask

Instance Property

# bluetoothManufacturerDataMask

The accessory’s Bluetooth manufacturer data mask.

var bluetoothManufacturerDataMask: Data? { get set }

## Mentioned in

Discovering and configuring accessories

## See Also

### Specifying Bluetooth properties

`var bluetoothCompanyIdentifier: ASBluetoothCompanyIdentifier`

The accessory’s 16-bit Bluetooth Company Identifier.

`struct ASBluetoothCompanyIdentifier`

The type used to identify a Bluetooth accessory provider.

`var bluetoothManufacturerDataBlob: Data?`

A byte buffer that matches the accessory’s Bluetooth manufacturer data.

`var bluetoothServiceDataBlob: Data?`

A byte buffer that matches the accessory’s Bluetooth service data.

`var bluetoothServiceDataMask: Data?`

The accessory’s Bluetooth service data mask.

`var bluetoothNameSubstring: String?`

The accessory’s over-the-air Bluetooth name substring.

`var bluetoothNameSubstringCompareOptions: NSString.CompareOptions`

The accessory’s over-the-air Bluetooth name substring compare options.

`var bluetoothServiceUUID: CBUUID?`

The accessory’s Bluetooth service UUID.

`var bluetoothRange: ASDiscoveryDescriptor.Range`

A property that tells the session to discover accessories within a specific Bluetooth range.

`enum Range`

The Bluetooth range in which to discover accessories.

---

# https://developer.apple.com/documentation/accessorysetupkit/asdiscoverydescriptor/bluetoothservicedatablob

- AccessorySetupKit
- ASDiscoveryDescriptor
- bluetoothServiceDataBlob

Instance Property

# bluetoothServiceDataBlob

A byte buffer that matches the accessory’s Bluetooth service data.

var bluetoothServiceDataBlob: Data? { get set }

## Mentioned in

Discovering and configuring accessories

## See Also

### Specifying Bluetooth properties

`var bluetoothCompanyIdentifier: ASBluetoothCompanyIdentifier`

The accessory’s 16-bit Bluetooth Company Identifier.

`struct ASBluetoothCompanyIdentifier`

The type used to identify a Bluetooth accessory provider.

`var bluetoothManufacturerDataBlob: Data?`

A byte buffer that matches the accessory’s Bluetooth manufacturer data.

`var bluetoothManufacturerDataMask: Data?`

The accessory’s Bluetooth manufacturer data mask.

`var bluetoothServiceDataMask: Data?`

The accessory’s Bluetooth service data mask.

`var bluetoothNameSubstring: String?`

The accessory’s over-the-air Bluetooth name substring.

`var bluetoothNameSubstringCompareOptions: NSString.CompareOptions`

The accessory’s over-the-air Bluetooth name substring compare options.

`var bluetoothServiceUUID: CBUUID?`

The accessory’s Bluetooth service UUID.

`var bluetoothRange: ASDiscoveryDescriptor.Range`

A property that tells the session to discover accessories within a specific Bluetooth range.

`enum Range`

The Bluetooth range in which to discover accessories.

---

# https://developer.apple.com/documentation/accessorysetupkit/asdiscoverydescriptor/bluetoothservicedatamask

- AccessorySetupKit
- ASDiscoveryDescriptor
- bluetoothServiceDataMask

Instance Property

# bluetoothServiceDataMask

The accessory’s Bluetooth service data mask.

var bluetoothServiceDataMask: Data? { get set }

## Mentioned in

Discovering and configuring accessories

## See Also

### Specifying Bluetooth properties

`var bluetoothCompanyIdentifier: ASBluetoothCompanyIdentifier`

The accessory’s 16-bit Bluetooth Company Identifier.

`struct ASBluetoothCompanyIdentifier`

The type used to identify a Bluetooth accessory provider.

`var bluetoothManufacturerDataBlob: Data?`

A byte buffer that matches the accessory’s Bluetooth manufacturer data.

`var bluetoothManufacturerDataMask: Data?`

The accessory’s Bluetooth manufacturer data mask.

`var bluetoothServiceDataBlob: Data?`

A byte buffer that matches the accessory’s Bluetooth service data.

`var bluetoothNameSubstring: String?`

The accessory’s over-the-air Bluetooth name substring.

`var bluetoothNameSubstringCompareOptions: NSString.CompareOptions`

The accessory’s over-the-air Bluetooth name substring compare options.

`var bluetoothServiceUUID: CBUUID?`

The accessory’s Bluetooth service UUID.

`var bluetoothRange: ASDiscoveryDescriptor.Range`

A property that tells the session to discover accessories within a specific Bluetooth range.

`enum Range`

The Bluetooth range in which to discover accessories.

---

# https://developer.apple.com/documentation/accessorysetupkit/asdiscoverydescriptor/bluetoothrange

- AccessorySetupKit
- ASDiscoveryDescriptor
- bluetoothRange

Instance Property

# bluetoothRange

A property that tells the session to discover accessories within a specific Bluetooth range.

var bluetoothRange: ASDiscoveryDescriptor.Range { get set }

## Mentioned in

Discovering and configuring accessories

## See Also

### Specifying Bluetooth properties

`var bluetoothCompanyIdentifier: ASBluetoothCompanyIdentifier`

The accessory’s 16-bit Bluetooth Company Identifier.

`struct ASBluetoothCompanyIdentifier`

The type used to identify a Bluetooth accessory provider.

`var bluetoothManufacturerDataBlob: Data?`

A byte buffer that matches the accessory’s Bluetooth manufacturer data.

`var bluetoothManufacturerDataMask: Data?`

The accessory’s Bluetooth manufacturer data mask.

`var bluetoothServiceDataBlob: Data?`

A byte buffer that matches the accessory’s Bluetooth service data.

`var bluetoothServiceDataMask: Data?`

The accessory’s Bluetooth service data mask.

`var bluetoothNameSubstring: String?`

The accessory’s over-the-air Bluetooth name substring.

`var bluetoothNameSubstringCompareOptions: NSString.CompareOptions`

The accessory’s over-the-air Bluetooth name substring compare options.

`var bluetoothServiceUUID: CBUUID?`

The accessory’s Bluetooth service UUID.

`enum Range`

The Bluetooth range in which to discover accessories.

---

# https://developer.apple.com/documentation/accessorysetupkit/asdiscoverydescriptor/range/immediate

- AccessorySetupKit
- ASDiscoveryDescriptor
- ASDiscoveryDescriptor.Range
- ASDiscoveryDescriptor.Range.immediate

Case

# ASDiscoveryDescriptor.Range.immediate

A range in the immediate vicinity of the device performing accessory discovery.

case immediate

## Discussion

This range means that an accessory is right next to the device running your app.

## See Also

### Bluetooth options

``case `default```

The default range in which to discover accessories.

---

# https://developer.apple.com/documentation/accessorysetupkit/asbluetoothcompanyidentifier

- AccessorySetupKit
- ASBluetoothCompanyIdentifier

Structure

# ASBluetoothCompanyIdentifier

The type used to identify a Bluetooth accessory provider.

Mac Catalyst

struct ASBluetoothCompanyIdentifier

## Topics

### Creating an identifier

`init(UInt16)`

`init(rawValue: UInt16)`

## Relationships

### Conforms To

- `BitwiseCopyable`
- `Equatable`
- `Hashable`
- `RawRepresentable`
- `Sendable`
- `SendableMetatype`

## See Also

### Specifying Bluetooth properties

`var bluetoothCompanyIdentifier: ASBluetoothCompanyIdentifier`

The accessory’s 16-bit Bluetooth Company Identifier.

`var bluetoothManufacturerDataBlob: Data?`

A byte buffer that matches the accessory’s Bluetooth manufacturer data.

`var bluetoothManufacturerDataMask: Data?`

The accessory’s Bluetooth manufacturer data mask.

`var bluetoothServiceDataBlob: Data?`

A byte buffer that matches the accessory’s Bluetooth service data.

`var bluetoothServiceDataMask: Data?`

The accessory’s Bluetooth service data mask.

`var bluetoothNameSubstring: String?`

The accessory’s over-the-air Bluetooth name substring.

`var bluetoothNameSubstringCompareOptions: NSString.CompareOptions`

The accessory’s over-the-air Bluetooth name substring compare options.

`var bluetoothServiceUUID: CBUUID?`

The accessory’s Bluetooth service UUID.

`var bluetoothRange: ASDiscoveryDescriptor.Range`

A property that tells the session to discover accessories within a specific Bluetooth range.

`enum Range`

The Bluetooth range in which to discover accessories.

---

# https://developer.apple.com/documentation/accessorysetupkit/asdiscoverydescriptor/bluetoothnamesubstringcompareoptions

- AccessorySetupKit
- ASDiscoveryDescriptor
- bluetoothNameSubstringCompareOptions

Instance Property

# bluetoothNameSubstringCompareOptions

The accessory’s over-the-air Bluetooth name substring compare options.

var bluetoothNameSubstringCompareOptions: NSString.CompareOptions { get set }

## See Also

### Specifying Bluetooth properties

`var bluetoothCompanyIdentifier: ASBluetoothCompanyIdentifier`

The accessory’s 16-bit Bluetooth Company Identifier.

`struct ASBluetoothCompanyIdentifier`

The type used to identify a Bluetooth accessory provider.

`var bluetoothManufacturerDataBlob: Data?`

A byte buffer that matches the accessory’s Bluetooth manufacturer data.

`var bluetoothManufacturerDataMask: Data?`

The accessory’s Bluetooth manufacturer data mask.

`var bluetoothServiceDataBlob: Data?`

A byte buffer that matches the accessory’s Bluetooth service data.

`var bluetoothServiceDataMask: Data?`

The accessory’s Bluetooth service data mask.

`var bluetoothNameSubstring: String?`

The accessory’s over-the-air Bluetooth name substring.

`var bluetoothServiceUUID: CBUUID?`

The accessory’s Bluetooth service UUID.

`var bluetoothRange: ASDiscoveryDescriptor.Range`

A property that tells the session to discover accessories within a specific Bluetooth range.

`enum Range`

The Bluetooth range in which to discover accessories.

---

# https://developer.apple.com/documentation/accessorysetupkit/asdiscoverydescriptor/range

- AccessorySetupKit
- ASDiscoveryDescriptor
- ASDiscoveryDescriptor.Range

Enumeration

# ASDiscoveryDescriptor.Range

The Bluetooth range in which to discover accessories.

enum Range

## Topics

### Creating an options instance

`init?(rawValue: Int)`

### Bluetooth options

``case `default```

The default range in which to discover accessories.

`case immediate`

A range in the immediate vicinity of the device performing accessory discovery.

## Relationships

### Conforms To

- `BitwiseCopyable`
- `Equatable`
- `Hashable`
- `RawRepresentable`
- `Sendable`
- `SendableMetatype`

## See Also

### Specifying Bluetooth properties

`var bluetoothCompanyIdentifier: ASBluetoothCompanyIdentifier`

The accessory’s 16-bit Bluetooth Company Identifier.

`struct ASBluetoothCompanyIdentifier`

The type used to identify a Bluetooth accessory provider.

`var bluetoothManufacturerDataBlob: Data?`

A byte buffer that matches the accessory’s Bluetooth manufacturer data.

`var bluetoothManufacturerDataMask: Data?`

The accessory’s Bluetooth manufacturer data mask.

`var bluetoothServiceDataBlob: Data?`

A byte buffer that matches the accessory’s Bluetooth service data.

`var bluetoothServiceDataMask: Data?`

The accessory’s Bluetooth service data mask.

`var bluetoothNameSubstring: String?`

The accessory’s over-the-air Bluetooth name substring.

`var bluetoothNameSubstringCompareOptions: NSString.CompareOptions`

The accessory’s over-the-air Bluetooth name substring compare options.

`var bluetoothServiceUUID: CBUUID?`

The accessory’s Bluetooth service UUID.

`var bluetoothRange: ASDiscoveryDescriptor.Range`

A property that tells the session to discover accessories within a specific Bluetooth range.

---

# https://developer.apple.com/documentation/accessorysetupkit/asdiscoverydescriptor/ssid

- AccessorySetupKit
- ASDiscoveryDescriptor
- ssid

Instance Property

# ssid

The SSID of the accessory’s Wi-Fi network.

var ssid: String? { get set }

## Mentioned in

Discovering and configuring accessories

## See Also

### Specifying Wi-Fi properties

`var ssidPrefix: String?`

The prefix string of SSID of the accessory’s Wi-Fi network.

---

# https://developer.apple.com/documentation/accessorysetupkit/asdiscoverydescriptor/ssidprefix

- AccessorySetupKit
- ASDiscoveryDescriptor
- ssidPrefix

Instance Property

# ssidPrefix

The prefix string of SSID of the accessory’s Wi-Fi network.

var ssidPrefix: String? { get set }

## Mentioned in

Discovering and configuring accessories

## See Also

### Specifying Wi-Fi properties

`var ssid: String?`

The SSID of the accessory’s Wi-Fi network.

---

# https://developer.apple.com/documentation/accessorysetupkit/asdiscoverydescriptor/supportedoptions

- AccessorySetupKit
- ASDiscoveryDescriptor
- supportedOptions

Instance Property

# supportedOptions

Options supported by an accessory.

var supportedOptions: ASAccessory.SupportOptions { get set }

## See Also

### Specifying options

`struct SupportOptions`

Options of discoverable accessories.

---

# https://developer.apple.com/documentation/accessorysetupkit/asaccessory/supportoptions

- AccessorySetupKit
- ASAccessory
- ASAccessory.SupportOptions

Structure

# ASAccessory.SupportOptions

Options of discoverable accessories.

struct SupportOptions

## Topics

### Creating an options instance

`init(rawValue: UInt)`

### Bluetooth options

`static var bluetoothPairingLE: ASAccessory.SupportOptions`

The accessory supports Bluetooth Low Energy pairing.

`static var bluetoothTransportBridging: ASAccessory.SupportOptions`

The accessory supports bridging to Bluetooth classic transport.

`static var bluetoothHID: ASAccessory.SupportOptions`

The accessory supports Bluetooth Low Energy HID service.

## Relationships

### Conforms To

- `BitwiseCopyable`
- `Equatable`
- `ExpressibleByArrayLiteral`
- `OptionSet`
- `RawRepresentable`
- `Sendable`
- `SendableMetatype`
- `SetAlgebra`

## See Also

### Specifying options

`var supportedOptions: ASAccessory.SupportOptions`

Options supported by an accessory.

---

# https://developer.apple.com/documentation/accessorysetupkit/asdiscoverydescriptor/wifiawareservicename

- AccessorySetupKit
- ASDiscoveryDescriptor
- wifiAwareServiceName

Instance Property

# wifiAwareServiceName

The accessory’s Wi-Fi Aware’s service name if available.

var wifiAwareServiceName: String? { get set }

## See Also

### Specifying Wi-Fi Aware properties

`var wifiAwareServiceRole: ASDiscoveryDescriptor.WiFiAwareServiceRole`

The role of the accessory’s Wi-Fi Aware’s service.

`enum WiFiAwareServiceRole`

A type that defines the role of an accessory’s Wi-Fi Aware’s service.

`var wifiAwareModelNameMatch: ASPropertyCompareString?`

The accessory’s Wi-Fi Aware model name and matching options.

`var wifiAwareVendorNameMatch: ASPropertyCompareString?`

The accessory’s Wi-Fi Aware vendor name and matching options.

`class ASPropertyCompareString`

A type that specifies how to filter a property against a given string and comparison options.

---

# https://developer.apple.com/documentation/accessorysetupkit/asdiscoverydescriptor/wifiawareservicerole-swift.property

- AccessorySetupKit
- ASDiscoveryDescriptor
- wifiAwareServiceRole

Instance Property

# wifiAwareServiceRole

The role of the accessory’s Wi-Fi Aware’s service.

var wifiAwareServiceRole: ASDiscoveryDescriptor.WiFiAwareServiceRole { get set }

## Discussion

This property defaults to `ASDiscoveryDescriptor.WiFiAwareServiceRole.subscriber`

## See Also

### Specifying Wi-Fi Aware properties

`var wifiAwareServiceName: String?`

The accessory’s Wi-Fi Aware’s service name if available.

`enum WiFiAwareServiceRole`

A type that defines the role of an accessory’s Wi-Fi Aware’s service.

`var wifiAwareModelNameMatch: ASPropertyCompareString?`

The accessory’s Wi-Fi Aware model name and matching options.

`var wifiAwareVendorNameMatch: ASPropertyCompareString?`

The accessory’s Wi-Fi Aware vendor name and matching options.

`class ASPropertyCompareString`

A type that specifies how to filter a property against a given string and comparison options.

---

# https://developer.apple.com/documentation/accessorysetupkit/asdiscoverydescriptor/wifiawareservicerole-swift.enum

- AccessorySetupKit
- ASDiscoveryDescriptor
- ASDiscoveryDescriptor.WiFiAwareServiceRole

Enumeration

# ASDiscoveryDescriptor.WiFiAwareServiceRole

A type that defines the role of an accessory’s Wi-Fi Aware’s service.

enum WiFiAwareServiceRole

## Topics

### Determining service role

`case subscriber`

The subscriber service role.

`case publisher`

The publisher service role.

### Working with raw values

`init?(rawValue: Int)`

## Relationships

### Conforms To

- `BitwiseCopyable`
- `Equatable`
- `Hashable`
- `RawRepresentable`
- `Sendable`
- `SendableMetatype`

## See Also

### Specifying Wi-Fi Aware properties

`var wifiAwareServiceName: String?`

The accessory’s Wi-Fi Aware’s service name if available.

`var wifiAwareServiceRole: ASDiscoveryDescriptor.WiFiAwareServiceRole`

The role of the accessory’s Wi-Fi Aware’s service.

`var wifiAwareModelNameMatch: ASPropertyCompareString?`

The accessory’s Wi-Fi Aware model name and matching options.

`var wifiAwareVendorNameMatch: ASPropertyCompareString?`

The accessory’s Wi-Fi Aware vendor name and matching options.

`class ASPropertyCompareString`

A type that specifies how to filter a property against a given string and comparison options.

---

# https://developer.apple.com/documentation/accessorysetupkit/asdiscoverydescriptor/wifiawaremodelnamematch

- AccessorySetupKit
- ASDiscoveryDescriptor
- wifiAwareModelNameMatch

Instance Property

# wifiAwareModelNameMatch

The accessory’s Wi-Fi Aware model name and matching options.

@NSCopying
var wifiAwareModelNameMatch: ASPropertyCompareString? { get set }

## See Also

### Specifying Wi-Fi Aware properties

`var wifiAwareServiceName: String?`

The accessory’s Wi-Fi Aware’s service name if available.

`var wifiAwareServiceRole: ASDiscoveryDescriptor.WiFiAwareServiceRole`

The role of the accessory’s Wi-Fi Aware’s service.

`enum WiFiAwareServiceRole`

A type that defines the role of an accessory’s Wi-Fi Aware’s service.

`var wifiAwareVendorNameMatch: ASPropertyCompareString?`

The accessory’s Wi-Fi Aware vendor name and matching options.

`class ASPropertyCompareString`

A type that specifies how to filter a property against a given string and comparison options.

---

# https://developer.apple.com/documentation/accessorysetupkit/asdiscoverydescriptor/wifiawarevendornamematch

- AccessorySetupKit
- ASDiscoveryDescriptor
- wifiAwareVendorNameMatch

Instance Property

# wifiAwareVendorNameMatch

The accessory’s Wi-Fi Aware vendor name and matching options.

@NSCopying
var wifiAwareVendorNameMatch: ASPropertyCompareString? { get set }

## See Also

### Specifying Wi-Fi Aware properties

`var wifiAwareServiceName: String?`

The accessory’s Wi-Fi Aware’s service name if available.

`var wifiAwareServiceRole: ASDiscoveryDescriptor.WiFiAwareServiceRole`

The role of the accessory’s Wi-Fi Aware’s service.

`enum WiFiAwareServiceRole`

A type that defines the role of an accessory’s Wi-Fi Aware’s service.

`var wifiAwareModelNameMatch: ASPropertyCompareString?`

The accessory’s Wi-Fi Aware model name and matching options.

`class ASPropertyCompareString`

A type that specifies how to filter a property against a given string and comparison options.

---

# https://developer.apple.com/documentation/accessorysetupkit/aspropertycomparestring

- AccessorySetupKit
- ASPropertyCompareString

Class

# ASPropertyCompareString

A type that specifies how to filter a property against a given string and comparison options.

class ASPropertyCompareString

## Topics

### Creating a compare string instance

`init(string: String, compareOptions: NSString.CompareOptions)`

Creates a property compare string instance with the given string and comparison options.

### Accessing compare string properties

`var string: String`

The string to compare against.

`var compareOptions: NSString.CompareOptions`

Comparison options to apply when comparing strings.

## Relationships

### Inherits From

- `NSObject`

### Conforms To

- `CVarArg`
- `CustomDebugStringConvertible`
- `CustomStringConvertible`
- `Equatable`
- `Hashable`
- `NSObjectProtocol`
- `Sendable`
- `SendableMetatype`

## See Also

### Specifying Wi-Fi Aware properties

`var wifiAwareServiceName: String?`

The accessory’s Wi-Fi Aware’s service name if available.

`var wifiAwareServiceRole: ASDiscoveryDescriptor.WiFiAwareServiceRole`

The role of the accessory’s Wi-Fi Aware’s service.

`enum WiFiAwareServiceRole`

A type that defines the role of an accessory’s Wi-Fi Aware’s service.

`var wifiAwareModelNameMatch: ASPropertyCompareString?`

The accessory’s Wi-Fi Aware model name and matching options.

`var wifiAwareVendorNameMatch: ASPropertyCompareString?`

The accessory’s Wi-Fi Aware vendor name and matching options.

---

# https://developer.apple.com/documentation/accessorysetupkit/aspickerdisplayitem/descriptor)

# The page you're looking for can't be found.

Search developer.apple.comSearch Icon

---

# https://developer.apple.com/documentation/accessorysetupkit/aspickerdisplayitem).



---

# https://developer.apple.com/documentation/accessorysetupkit/asdiscoverydescriptor/bluetoothserviceuuid)

# The page you're looking for can't be found.

Search developer.apple.comSearch Icon

---

# https://developer.apple.com/documentation/accessorysetupkit/asdiscoverydescriptor/bluetoothcompanyidentifier)

# The page you're looking for can't be found.

Search developer.apple.comSearch Icon

---

# https://developer.apple.com/documentation/accessorysetupkit/asdiscoverydescriptor/bluetoothnamesubstring)

# The page you're looking for can't be found.

Search developer.apple.comSearch Icon

---

# https://developer.apple.com/documentation/accessorysetupkit/asdiscoverydescriptor/bluetoothmanufacturerdatablob)

# The page you're looking for can't be found.

Search developer.apple.comSearch Icon

---

# https://developer.apple.com/documentation/accessorysetupkit/asdiscoverydescriptor/bluetoothmanufacturerdatamask)

# The page you're looking for can't be found.

Search developer.apple.comSearch Icon

---

# https://developer.apple.com/documentation/accessorysetupkit/asdiscoverydescriptor/bluetoothservicedatablob)

# The page you're looking for can't be found.

Search developer.apple.comSearch Icon

---

# https://developer.apple.com/documentation/accessorysetupkit/asdiscoverydescriptor/bluetoothservicedatamask)

# The page you're looking for can't be found.

Search developer.apple.comSearch Icon

---

# https://developer.apple.com/documentation/accessorysetupkit/asdiscoverydescriptor/bluetoothrange)

# The page you're looking for can't be found.

Search developer.apple.comSearch Icon

---

# https://developer.apple.com/documentation/accessorysetupkit/asdiscoverydescriptor/range/immediate)

# The page you're looking for can't be found.

Search developer.apple.comSearch Icon

---

# https://developer.apple.com/documentation/accessorysetupkit/asbluetoothcompanyidentifier)

# The page you're looking for can't be found.

Search developer.apple.comSearch Icon

---

# https://developer.apple.com/documentation/accessorysetupkit/asdiscoverydescriptor/bluetoothnamesubstringcompareoptions)

# The page you're looking for can't be found.

Search developer.apple.comSearch Icon

---

# https://developer.apple.com/documentation/accessorysetupkit/asdiscoverydescriptor/range)

# The page you're looking for can't be found.

Search developer.apple.comSearch Icon

---

# https://developer.apple.com/documentation/accessorysetupkit/asdiscoverydescriptor/ssid)

# The page you're looking for can't be found.

Search developer.apple.comSearch Icon

---

# https://developer.apple.com/documentation/accessorysetupkit/asdiscoverydescriptor/ssidprefix)

# The page you're looking for can't be found.

Search developer.apple.comSearch Icon

---

# https://developer.apple.com/documentation/accessorysetupkit/asdiscoverydescriptor/supportedoptions)

# The page you're looking for can't be found.

Search developer.apple.comSearch Icon

---

# https://developer.apple.com/documentation/accessorysetupkit/asaccessory/supportoptions)

# The page you're looking for can't be found.

Search developer.apple.comSearch Icon

---

# https://developer.apple.com/documentation/accessorysetupkit/asdiscoverydescriptor/wifiawareservicename)

# The page you're looking for can't be found.

Search developer.apple.comSearch Icon

---

# https://developer.apple.com/documentation/accessorysetupkit/asdiscoverydescriptor/wifiawareservicerole-swift.property)

# The page you're looking for can't be found.

Search developer.apple.comSearch Icon

---

# https://developer.apple.com/documentation/accessorysetupkit/asdiscoverydescriptor/wifiawareservicerole-swift.enum)

# The page you're looking for can't be found.

Search developer.apple.comSearch Icon

---

# https://developer.apple.com/documentation/accessorysetupkit/asdiscoverydescriptor/wifiawaremodelnamematch)

# The page you're looking for can't be found.

Search developer.apple.comSearch Icon

---

# https://developer.apple.com/documentation/accessorysetupkit/asdiscoverydescriptor/wifiawarevendornamematch)

# The page you're looking for can't be found.

Search developer.apple.comSearch Icon

---

# https://developer.apple.com/documentation/accessorysetupkit/aspropertycomparestring)



---

# https://developer.apple.com/documentation/accessorysetupkit/asaccessory/bluetoothidentifier

- AccessorySetupKit
- ASAccessory
- bluetoothIdentifier

Instance Property

# bluetoothIdentifier

The accessory’s unique Bluetooth identifier, if any.

var bluetoothIdentifier: UUID? { get }

## Mentioned in

Discovering and configuring accessories

## Discussion

Use this identifier to establish a connection to the accessory.

## See Also

### Accessing identifiers

`var bluetoothTransportBridgingIdentifier: Data?`

The accessory’s Bluetooth identifier, if any, for use when bridging classic transport profiles.

`var ssid: String?`

The accessory’s Wi-Fi SSID, if any.

---

# https://developer.apple.com/documentation/accessorysetupkit/asaccessory/bluetoothtransportbridgingidentifier

- AccessorySetupKit
- ASAccessory
- bluetoothTransportBridgingIdentifier

Instance Property

# bluetoothTransportBridgingIdentifier

The accessory’s Bluetooth identifier, if any, for use when bridging classic transport profiles.

var bluetoothTransportBridgingIdentifier: Data? { get }

## See Also

### Accessing identifiers

`var bluetoothIdentifier: UUID?`

The accessory’s unique Bluetooth identifier, if any.

`var ssid: String?`

The accessory’s Wi-Fi SSID, if any.

---

# https://developer.apple.com/documentation/accessorysetupkit/asaccessory/ssid

- AccessorySetupKit
- ASAccessory
- ssid

Instance Property

# ssid

The accessory’s Wi-Fi SSID, if any.

var ssid: String? { get }

## Mentioned in

Discovering and configuring accessories

## Discussion

Use this identifier to establish a connection to the accessory.

## See Also

### Accessing identifiers

`var bluetoothIdentifier: UUID?`

The accessory’s unique Bluetooth identifier, if any.

`var bluetoothTransportBridgingIdentifier: Data?`

The accessory’s Bluetooth identifier, if any, for use when bridging classic transport profiles.

---

# https://developer.apple.com/documentation/accessorysetupkit/asaccessory/displayname

- AccessorySetupKit
- ASAccessory
- displayName

Instance Property

# displayName

The accessory’s name, suitable for displaying to someone using your app.

var displayName: String { get }

## Mentioned in

Discovering and configuring accessories

---

# https://developer.apple.com/documentation/accessorysetupkit/asaccessory/descriptor

- AccessorySetupKit
- ASAccessory
- descriptor

Instance Property

# descriptor

The descriptor used to discover the accessory.

@NSCopying
var descriptor: ASDiscoveryDescriptor { get }

---

# https://developer.apple.com/documentation/accessorysetupkit/asaccessory/state

- AccessorySetupKit
- ASAccessory
- state

Instance Property

# state

The current authorization state of the accessory.

var state: ASAccessory.AccessoryState { get }

## See Also

### Inspecting accessory state

`enum AccessoryState`

An enumeration of possible authorization states of an accessory.

---

# https://developer.apple.com/documentation/accessorysetupkit/asaccessory/wifiawarepaireddeviceid-swift.property

- AccessorySetupKit
- ASAccessory
- wifiAwarePairedDeviceID

Instance Property

# wifiAwarePairedDeviceID

The accessory’s Wi-Fi Aware Pairing Identifier.

var wifiAwarePairedDeviceID: ASAccessory.WiFiAwarePairedDeviceID { get }

## Discussion

Use this identifier to establish a connection to the accessory using Wi-Fi Aware Framework.

## See Also

### Working with Wi-Fi Aware

`typealias WiFiAwarePairedDeviceID`

The type used for an accessory’s Wi-Fi Aware Pairing Identifier.

---

# https://developer.apple.com/documentation/accessorysetupkit/asaccessory/wifiawarepaireddeviceid-swift.typealias

- AccessorySetupKit
- ASAccessory
- ASAccessory.WiFiAwarePairedDeviceID

Type Alias

# ASAccessory.WiFiAwarePairedDeviceID

The type used for an accessory’s Wi-Fi Aware Pairing Identifier.

typealias WiFiAwarePairedDeviceID = UInt64

## See Also

### Working with Wi-Fi Aware

`var wifiAwarePairedDeviceID: ASAccessory.WiFiAwarePairedDeviceID`

The accessory’s Wi-Fi Aware Pairing Identifier.

---

# https://developer.apple.com/documentation/accessorysetupkit/asaccessory/bluetoothidentifier)

# The page you're looking for can't be found.

Search developer.apple.comSearch Icon

---

# https://developer.apple.com/documentation/accessorysetupkit/asaccessory/bluetoothtransportbridgingidentifier)

# The page you're looking for can't be found.

Search developer.apple.comSearch Icon

---

# https://developer.apple.com/documentation/accessorysetupkit/asaccessory/ssid)



---

# https://developer.apple.com/documentation/accessorysetupkit/asaccessory/displayname)



---

# https://developer.apple.com/documentation/accessorysetupkit/asaccessory/descriptor)



---

# https://developer.apple.com/documentation/accessorysetupkit/asaccessory/state)



---

# https://developer.apple.com/documentation/accessorysetupkit/asaccessory/wifiawarepaireddeviceid-swift.property)

# The page you're looking for can't be found.

Search developer.apple.comSearch Icon

---

# https://developer.apple.com/documentation/accessorysetupkit/asaccessory/wifiawarepaireddeviceid-swift.typealias)

# The page you're looking for can't be found.

Search developer.apple.comSearch Icon

---

# https://developer.apple.com/documentation/accessorysetupkit/aspickerdisplayitem/setupoptions-swift.property

- AccessorySetupKit
- ASPickerDisplayItem
- setupOptions

Instance Property

# setupOptions

Custom setup options for the accessory.

var setupOptions: ASPickerDisplayItem.SetupOptions { get set }

## Mentioned in

Discovering and configuring accessories

## See Also

### Customizing setup options

`struct SetupOptions`

Setup options offered by the accessory picker.

`var renameOptions: ASAccessory.RenameOptions`

Options to allow renaming a matched accessory.

`struct RenameOptions`

Options that affect the behavior of an accessory renaming operation.

---

# https://developer.apple.com/documentation/accessorysetupkit/aspickerdisplayitem/setupoptions-swift.struct

- AccessorySetupKit
- ASPickerDisplayItem
- ASPickerDisplayItem.SetupOptions

Structure

# ASPickerDisplayItem.SetupOptions

Setup options offered by the accessory picker.

struct SetupOptions

## Topics

### Creating an options instance

`init(rawValue: UInt)`

### Options

`static var rename: ASPickerDisplayItem.SetupOptions`

An option to ask the person using the app to rename the accessory.

`static var confirmAuthorization: ASPickerDisplayItem.SetupOptions`

An option to require the app to finish accessory authorization before showing the setup view.

`static var finishInApp: ASPickerDisplayItem.SetupOptions`

An option to ask the person setting up the accessory to finish additional setup in the app after the accessory is authorized.

## Relationships

### Conforms To

- `BitwiseCopyable`
- `Equatable`
- `ExpressibleByArrayLiteral`
- `OptionSet`
- `RawRepresentable`
- `Sendable`
- `SendableMetatype`
- `SetAlgebra`

## See Also

### Customizing setup options

`var setupOptions: ASPickerDisplayItem.SetupOptions`

Custom setup options for the accessory.

`var renameOptions: ASAccessory.RenameOptions`

Options to allow renaming a matched accessory.

`struct RenameOptions`

Options that affect the behavior of an accessory renaming operation.

---

# https://developer.apple.com/documentation/accessorysetupkit/aspickerdisplayitem/init(name:productimage:descriptor:)

#app-main)

- AccessorySetupKit
- ASPickerDisplayItem
- init(name:productImage:descriptor:)

Initializer

# init(name:productImage:descriptor:)

Creates a picker display item with a name and image to display and a descriptor to match discovered accessories.

init(
name: String,
productImage: UIImage,
descriptor: ASDiscoveryDescriptor
)

## Parameters

`name`

The accessory name to display in the picker.

`productImage`

An image of the accessory to display in the picker.

`descriptor`

A descriptor that the picker uses to determine which discovered accessories to display.

---

# https://developer.apple.com/documentation/accessorysetupkit/aspickerdisplayitem/name

- AccessorySetupKit
- ASPickerDisplayItem
- name

Instance Property

# name

The accessory name to display in the picker.

var name: String { get }

## See Also

### Customizing display properties

`var productImage: UIImage`

An image of the accessory to display in the picker.

---

# https://developer.apple.com/documentation/accessorysetupkit/aspickerdisplayitem/productimage

- AccessorySetupKit
- ASPickerDisplayItem
- productImage

Instance Property

# productImage

An image of the accessory to display in the picker.

@NSCopying
var productImage: UIImage { get }

## See Also

### Customizing display properties

`var name: String`

The accessory name to display in the picker.

---

# https://developer.apple.com/documentation/accessorysetupkit/aspickerdisplayitem/renameoptions

- AccessorySetupKit
- ASPickerDisplayItem
- renameOptions

Instance Property

# renameOptions

Options to allow renaming a matched accessory.

var renameOptions: ASAccessory.RenameOptions { get set }

## Discussion

To permit renaming, include `rename` in the `setupOptions`

## See Also

### Customizing setup options

`var setupOptions: ASPickerDisplayItem.SetupOptions`

Custom setup options for the accessory.

`struct SetupOptions`

Setup options offered by the accessory picker.

`struct RenameOptions`

Options that affect the behavior of an accessory renaming operation.

---

# https://developer.apple.com/documentation/accessorysetupkit/aspickerdisplayitem/descriptor),

,#app-main)

# The page you're looking for can't be found.

Search developer.apple.comSearch Icon

---

# https://developer.apple.com/documentation/accessorysetupkit/aspickerdisplayitem/setupoptions-swift.property)

# The page you're looking for can't be found.

Search developer.apple.comSearch Icon

---

# https://developer.apple.com/documentation/accessorysetupkit/aspickerdisplayitem/setupoptions-swift.struct)

# The page you're looking for can't be found.

Search developer.apple.comSearch Icon

---

# https://developer.apple.com/documentation/accessorysetupkit/aspickerdisplayitem/init(name:productimage:descriptor:))

)#app-main)

# The page you're looking for can't be found.

Search developer.apple.comSearch Icon

---

# https://developer.apple.com/documentation/accessorysetupkit/aspickerdisplayitem/name)



---

# https://developer.apple.com/documentation/accessorysetupkit/aspickerdisplayitem/productimage)

# The page you're looking for can't be found.

Search developer.apple.comSearch Icon

---

# https://developer.apple.com/documentation/accessorysetupkit/aspickerdisplayitem/renameoptions)

# The page you're looking for can't be found.

Search developer.apple.comSearch Icon

---

# https://developer.apple.com/documentation/accessorysetupkit/asaccessoryevent/eventtype

- AccessorySetupKit
- ASAccessoryEvent
- eventType

Instance Property

# eventType

The type of event, such as accessory addition or removal, or picker presentation or removal.

var eventType: ASAccessoryEventType { get }

## Mentioned in

Discovering and configuring accessories

## Discussion

Some event types may indicate that the event is a subclass of `ASAccessoryEvent` that provides additional properties.

## See Also

### Inspecting the event

`var accessory: ASAccessory?`

The accessory involved in the event, if any.

`class ASAccessory`

An accessory discovered by the accessory session.

`enum ASAccessoryEventType`

An enumeration of the types of events encountered during accessory discovery

---

# https://developer.apple.com/documentation/accessorysetupkit/asaccessoryeventtype/activated

- AccessorySetupKit
- ASAccessoryEventType
- ASAccessoryEventType.activated

Case

# ASAccessoryEventType.activated

The discovery session activated.

Mac Catalyst

case activated

## Mentioned in

Discovering and configuring accessories

## See Also

### Life cycle events

`case invalidated`

The discovery session invalidated.

---

# https://developer.apple.com/documentation/accessorysetupkit/asaccessorysession/accessories

- AccessorySetupKit
- ASAccessorySession
- accessories

Instance Property

# accessories

An array of previously-selected accessories for this application.

var accessories: [ASAccessory] { get }

## Mentioned in

Discovering and configuring accessories

## Discussion

To monitor for changes in this list, use your event handler to watch for the events `ASAccessoryEventType.accessoryAdded`, `ASAccessoryEventType.accessoryChanged`, and `ASAccessoryEventType.accessoryRemoved`.

---

# https://developer.apple.com/documentation/accessorysetupkit/asmigrationdisplayitem/hotspotssid

- AccessorySetupKit
- ASMigrationDisplayItem
- hotspotSSID

Instance Property

# hotspotSSID

The Wi-Fi hotspot SSID of the accessory to migrate.

var hotspotSSID: String? { get set }

## Mentioned in

Discovering and configuring accessories

## See Also

### Accessory identifiers

`var peripheralIdentifier: UUID?`

The Bluetooth identifier of the accessory to migrate.

`var wifiAwarePairedDeviceID: ASAccessory.WiFiAwarePairedDeviceID`

The Wi-Fi Aware paired device identififer of the accessory to migrate.

---

# https://developer.apple.com/documentation/accessorysetupkit/asmigrationdisplayitem/peripheralidentifier

- AccessorySetupKit
- ASMigrationDisplayItem
- peripheralIdentifier

Instance Property

# peripheralIdentifier

The Bluetooth identifier of the accessory to migrate.

var peripheralIdentifier: UUID? { get set }

## Mentioned in

Discovering and configuring accessories

## See Also

### Accessory identifiers

`var hotspotSSID: String?`

The Wi-Fi hotspot SSID of the accessory to migrate.

`var wifiAwarePairedDeviceID: ASAccessory.WiFiAwarePairedDeviceID`

The Wi-Fi Aware paired device identififer of the accessory to migrate.

---

# https://developer.apple.com/documentation/accessorysetupkit/aspickerdisplaysettings/options-swift.struct/filterdiscoveryresults

- AccessorySetupKit
- ASPickerDisplaySettings
- ASPickerDisplaySettings.Options
- filterDiscoveryResults

Type Property

# filterDiscoveryResults

An option to pass discovered accessories to the app for more custom filtering, before they’re displayed in the picker for selection.

static var filterDiscoveryResults: ASPickerDisplaySettings.Options { get }

## Mentioned in

Discovering and configuring accessories

## Discussion

When your picker uses this option, your `ASAccessorySession` receives events of type `ASAccessoryEventType.accessoryDiscovered`. Handle this event by examining the discovered accessory. To include it in the picker, create a new `ASDiscoveredDisplayItem` for it and call `updatePicker(showing:completionHandler:)`.

---

# https://developer.apple.com/documentation/accessorysetupkit/aspickerdisplaysettings/discoverytimeout-swift.property

- AccessorySetupKit
- ASPickerDisplaySettings
- discoveryTimeout

Instance Property

# discoveryTimeout

Custom timeout for picker. Default is 30 seconds.

var discoveryTimeout: ASPickerDisplaySettings.DiscoveryTimeout { get set }

## Mentioned in

Discovering and configuring accessories

## See Also

### Customizing the discovery timeout

`struct DiscoveryTimeout`

The type used for the accessory picker’s discovery timeout value.

---

# https://developer.apple.com/documentation/accessorysetupkit/aspickerdisplaysettings/discoverytimeout-swift.struct/unbounded

- AccessorySetupKit
- ASPickerDisplaySettings
- ASPickerDisplaySettings.DiscoveryTimeout
- unbounded

Type Property

# unbounded

A picker discovery that only times out when the app tells it to.

static let unbounded: ASPickerDisplaySettings.DiscoveryTimeout

## Mentioned in

Discovering and configuring accessories

## Discussion

Use this timeout value if you set the picker display option `filterDiscoveryResults` and need unlimited time for filtering. After performing manual discovery, perform the manual timeout by calling the `ASAccessorySession` method `finishPickerDiscovery(completionHandler:)`. This process shows a timeout message if your filtering added no accessories to the picker, or returns silently if you updated the picker.

## See Also

### Determining discovery timeout

``class var `default`: ASPickerDisplaySettings``

An empty settings object.

`static let short: ASPickerDisplaySettings.DiscoveryTimeout`

A picker discovery timeout value that times out after about about 60 seconds.

`static let medium: ASPickerDisplaySettings.DiscoveryTimeout`

A picker discovery timeout value that times out after about two minutes.

`static let long: ASPickerDisplaySettings.DiscoveryTimeout`

A picker discovery timeout value that times out after about five minutes.

---

# https://developer.apple.com/documentation/accessorysetupkit/asaccessoryeventtype/accessorydiscovered

- AccessorySetupKit
- ASAccessoryEventType
- ASAccessoryEventType.accessoryDiscovered

Case

# ASAccessoryEventType.accessoryDiscovered

The session discovered an accessory.

Mac Catalyst

case accessoryDiscovered

## Mentioned in

Discovering and configuring accessories

## Discussion

Your app only receives this event if your picker uses the `filterDiscoveryResults` option.

---

# https://developer.apple.com/documentation/accessorysetupkit/asaccessorysession/updatepicker(showing:completionhandler:)

#app-main)

- AccessorySetupKit
- ASAccessorySession
- updatePicker(showing:completionHandler:)

Instance Method

# updatePicker(showing:completionHandler:)

Updates the picker with app-filtered accessories.

func updatePicker(
showing displayItems: [ASDiscoveredDisplayItem],

)
func updatePicker(showing displayItems: [ASDiscoveredDisplayItem]) async throws

## Parameters

`displayItems`

The app-filtered accessories to show in the picker.

`completionHandler`

A block or closure that executes after the updatePicker operation completes. The completion handler receives an `NSError` instance if the operation encounters an error.

## Mentioned in

Discovering and configuring accessories

## Discussion

You use this method when your picker uses the `filterDiscoveryResults` option to enable manual filtering of discovered accessories. After creating customized `ASDiscoveredDisplayItem` instances for included accessories, call this method to update the picker to show your app-filtered accessories with updated assets.

---

# https://developer.apple.com/documentation/accessorysetupkit/asaccessoryeventtype/accessoryadded

- AccessorySetupKit
- ASAccessoryEventType
- ASAccessoryEventType.accessoryAdded

Case

# ASAccessoryEventType.accessoryAdded

The session added an accessory.

Mac Catalyst

case accessoryAdded

## Mentioned in

Discovering and configuring accessories

## See Also

### Accessory events

`case accessoryChanged`

The properties of an accessory changed.

`case accessoryRemoved`

The session removed an accessory.

---

# https://developer.apple.com/documentation/accessorysetupkit/asaccessoryeventtype/pickerdiddismiss

- AccessorySetupKit
- ASAccessoryEventType
- ASAccessoryEventType.pickerDidDismiss

Case

# ASAccessoryEventType.pickerDidDismiss

The discovery session picker dismissed.

Mac Catalyst

case pickerDidDismiss

## Mentioned in

Discovering and configuring accessories

## See Also

### Picker events

`case pickerDidPresent`

The discovery session picker appeared.

`case pickerSetupBridging`

The discovery session picker started bridging with an accessory.

`case pickerSetupPairing`

The discovery session picker started pairing with a Bluetooth accessory.

`case pickerSetupFailed`

The discovery session picker setup failed.

`case pickerSetupRename`

The discovery session picker started renaming an accessory.

---

# https://developer.apple.com/documentation/accessorysetupkit/asaccessoryevent/accessory

- AccessorySetupKit
- ASAccessoryEvent
- accessory

Instance Property

# accessory

The accessory involved in the event, if any.

@NSCopying
var accessory: ASAccessory? { get }

## Mentioned in

Discovering and configuring accessories

## Discussion

The session populates this member for event types like `ASAccessoryEventType.accessoryAdded` and `ASAccessoryEventType.accessoryChanged`, but not for life cycle or picker events like `ASAccessoryEventType.activated` or `ASAccessoryEventType.pickerDidPresent`.

## See Also

### Inspecting the event

`class ASAccessory`

An accessory discovered by the accessory session.

`var eventType: ASAccessoryEventType`

The type of event, such as accessory addition or removal, or picker presentation or removal.

`enum ASAccessoryEventType`

An enumeration of the types of events encountered during accessory discovery

---

# https://developer.apple.com/documentation/accessorysetupkit/asaccessorysession).



---

# https://developer.apple.com/documentation/accessorysetupkit/asaccessoryevent),



---

# https://developer.apple.com/documentation/accessorysetupkit/asaccessoryevent/eventtype)

# The page you're looking for can't be found.

Search developer.apple.comSearch Icon

---

# https://developer.apple.com/documentation/accessorysetupkit/asaccessoryeventtype/activated)

# The page you're looking for can't be found.

Search developer.apple.comSearch Icon

---

# https://developer.apple.com/documentation/accessorysetupkit/asdiscoverydescriptor),



---

# https://developer.apple.com/documentation/accessorysetupkit/asdiscoverydescriptor/bluetoothserviceuuid),

,#app-main)

# The page you're looking for can't be found.

Search developer.apple.comSearch Icon

---

# https://developer.apple.com/documentation/accessorysetupkit/asdiscoverydescriptor/ssidprefix),

,#app-main)

# The page you're looking for can't be found.

Search developer.apple.comSearch Icon

---

# https://developer.apple.com/documentation/accessorysetupkit/aspickerdisplayitem/setupoptions-swift.property).

.#app-main)

# The page you're looking for can't be found.

Search developer.apple.comSearch Icon

---

# https://developer.apple.com/documentation/accessorysetupkit/asaccessorysession/showpicker(for:completionhandler:)).

).#app-main)

# The page you're looking for can't be found.

Search developer.apple.comSearch Icon

---

# https://developer.apple.com/documentation/accessorysetupkit/asmigrationdisplayitem/hotspotssid),

,#app-main)

# The page you're looking for can't be found.

Search developer.apple.comSearch Icon

---

# https://developer.apple.com/documentation/accessorysetupkit/asmigrationdisplayitem/peripheralidentifier),

,#app-main)

# The page you're looking for can't be found.

Search developer.apple.comSearch Icon

---

# https://developer.apple.com/documentation/accessorysetupkit/aspickerdisplaysettings/options-swift.struct/filterdiscoveryresults)

# The page you're looking for can't be found.

Search developer.apple.comSearch Icon

---

# https://developer.apple.com/documentation/accessorysetupkit/aspickerdisplaysettings/discoverytimeout-swift.property)

# The page you're looking for can't be found.

Search developer.apple.comSearch Icon

---

# https://developer.apple.com/documentation/accessorysetupkit/aspickerdisplaysettings/discoverytimeout-swift.struct/unbounded).

.#app-main)

# The page you're looking for can't be found.

Search developer.apple.comSearch Icon

---

# https://developer.apple.com/documentation/accessorysetupkit/asaccessoryeventtype/accessorydiscovered)



---

# https://developer.apple.com/documentation/accessorysetupkit/asdiscovereddisplayitem).



---

# https://developer.apple.com/documentation/accessorysetupkit/asaccessorysession/finishpickerdiscovery(completionhandler:)).

).#app-main)

# The page you're looking for can't be found.

Search developer.apple.comSearch Icon

---

# https://developer.apple.com/documentation/accessorysetupkit/asaccessoryeventtype/accessoryadded),

,#app-main)

# The page you're looking for can't be found.

Search developer.apple.comSearch Icon

---

# https://developer.apple.com/documentation/accessorysetupkit/asaccessoryeventtype/pickerdiddismiss)

# The page you're looking for can't be found.

Search developer.apple.comSearch Icon

---

# https://developer.apple.com/documentation/accessorysetupkit/asaccessoryevent/accessory)

# The page you're looking for can't be found.

Search developer.apple.comSearch Icon

---

# https://developer.apple.com/documentation/accessorysetupkit/asdiscoveredaccessory/bluetoothrssi-5a2gp

- AccessorySetupKit
- ASDiscoveredAccessory
- bluetoothRSSI

Instance Property

# bluetoothRSSI

The Bluetooth RSSI (Received Signal Strength Indicator) value from the discovered accessory.

var bluetoothRSSI: Int? { get }

## Discussion

This value represents the signal strength in dBm when the session discovered the accessory.

## See Also

### Working with accessory properties

[`var bluetoothAdvertisementData: [AnyHashable : Any]?`](https://developer.apple.com/documentation/accessorysetupkit/asdiscoveredaccessory/bluetoothadvertisementdata)

The Bluetooth advertisement data from the discovered accessory.

---

# https://developer.apple.com/documentation/accessorysetupkit/asdiscovereddisplayitem),



---

# https://developer.apple.com/documentation/accessorysetupkit/asdiscoveredaccessory/bluetoothadvertisementdata)

# The page you're looking for can't be found.

Search developer.apple.comSearch Icon

---

# https://developer.apple.com/documentation/accessorysetupkit/asdiscoveredaccessory/bluetoothrssi-5a2gp)

# The page you're looking for can't be found.

Search developer.apple.comSearch Icon

---

# https://developer.apple.com/documentation/accessorysetupkit/asaccessoryevent/error

- AccessorySetupKit
- ASAccessoryEvent
- error

Instance Property

# error

The error associated with the event, if any.

var error: (any Error)? { get }

---

# https://developer.apple.com/documentation/accessorysetupkit/asaccessoryevent/error)



---

# https://developer.apple.com/documentation/accessorysetupkit/asaccessoryeventtype/init(rawvalue:)

#app-main)

- AccessorySetupKit
- ASAccessoryEventType
- init(rawValue:)

Initializer

# init(rawValue:)

Mac Catalyst

init?(rawValue: Int)

---

# https://developer.apple.com/documentation/accessorysetupkit/asaccessory/renameoptions/ssid

- AccessorySetupKit
- ASAccessory
- ASAccessory.RenameOptions
- ssid

Type Property

# ssid

An option to change an accessory’s SSID along with its display name.

static var ssid: ASAccessory.RenameOptions { get }

---

# https://developer.apple.com/documentation/accessorysetupkit/asaccessory/renameoptions/ssid).

.#app-main)

# The page you're looking for can't be found.

Search developer.apple.comSearch Icon

---

