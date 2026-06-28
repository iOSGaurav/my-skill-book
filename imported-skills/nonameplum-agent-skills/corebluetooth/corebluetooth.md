# Core Bluetooth Reference

This is a concise, task-focused reference for Apple's Core Bluetooth framework. Use it to plan workflows and locate the right API quickly.

Source: https://developer.apple.com/documentation/corebluetooth

## Key concepts

- Core Bluetooth supports Bluetooth Low Energy (LE) and Bluetooth Classic (BR/EDR).
- Apps act as a central, a peripheral, or both.
- Do not subclass Core Bluetooth classes.
- Most operations are asynchronous and delivered through delegate callbacks.

## Roles and primary types

### Central role

- `CBCentralManager`: scan for, discover, and connect to peripherals.
- `CBCentralManagerDelegate`: handle state, discovery, connection events.
- `CBPeripheral`: represent a remote peripheral; discover services and characteristics.
- `CBPeripheralDelegate`: handle service and characteristic discovery, reads, writes, and notifications.

### Peripheral role

- `CBPeripheralManager`: advertise and expose services.
- `CBPeripheralManagerDelegate`: handle state changes and read/write requests.
- `CBMutableService`: define services offered by the peripheral.
- `CBMutableCharacteristic`: define characteristics and permissions.
- `CBATTRequest`: represent read/write requests from centrals.

## Central flow (summary)

1. Create `CBCentralManager` with a delegate and queue.
2. Wait for `centralManagerDidUpdateState(_:)` to report `.poweredOn`.
3. Call `scanForPeripherals(withServices:options:)`.
4. Stop scanning once the target peripheral is found.
5. Call `connect(_:options:)`.
6. Set `CBPeripheral` delegate; call `discoverServices(_:)`.
7. Discover characteristics and descriptors as needed.
8. Read, write, or subscribe to notifications.

## Peripheral flow (summary)

1. Create `CBPeripheralManager` with a delegate and queue.
2. Wait for the state to become `.poweredOn`.
3. Create `CBMutableService` and `CBMutableCharacteristic` instances.
4. Add services with `add(_:)`.
5. Start advertising with `startAdvertising(_:)`.
6. Respond to read/write requests in delegate callbacks.
7. Update characteristic values for subscribed centrals.

## Data transfer patterns

- Discover services before discovering characteristics.
- Use `readValue(for:)` to read characteristic or descriptor values.
- Use `writeValue(_:for:type:)` for writes; choose `.withResponse` when reliability matters.
- Use `setNotifyValue(_:for:)` to enable notifications or indications.
- Check `canSendWriteWithoutResponse` before writing without response.

## Background and lifecycle notes

- Gate all BLE work on the manager state being `.poweredOn`.
- Use state restoration only when you need the OS to relaunch your app to continue BLE work.
- Enable the appropriate background modes when you need BLE activity while backgrounded.

## Common pitfalls

- Scanning before the manager reaches `.poweredOn`.
- Losing the `CBPeripheral` reference, which cancels delegate callbacks.
- Forgetting to set the `CBPeripheral` delegate before discovery.
- Attempting to read or write before services and characteristics are discovered.
- Scanning without service filters longer than necessary.

## API quick map

### Central manager

- Init: `CBCentralManager(delegate:queue:options:)`
- Scan: `scanForPeripherals(withServices:options:)`, `stopScan()`
- Connect: `connect(_:options:)`, `cancelPeripheralConnection(_:)`
- State: `centralManagerDidUpdateState(_:)`

### Peripheral

- Services: `discoverServices(_:)`, `services`
- Characteristics: `discoverCharacteristics(_:for:)`
- Read/Write: `readValue(for:)`, `writeValue(_:for:type:)`
- Notify: `setNotifyValue(_:for:)`
- RSSI: `readRSSI()`

### Peripheral manager

- Init: `CBPeripheralManager(delegate:queue:options:)`
- Add services: `add(_:)`
- Advertise: `startAdvertising(_:)`, `stopAdvertising()`
- Respond to requests: `respond(to:withResult:)`
- Update subscribers: `updateValue(_:for:onSubscribedCentrals:)`

### Services and characteristics

- `CBService`, `CBMutableService`
- `CBCharacteristic`, `CBMutableCharacteristic`
- `CBDescriptor`, `CBMutableDescriptor`

### Errors

- `CBError`, `CBATTError`
