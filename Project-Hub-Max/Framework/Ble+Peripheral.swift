//
//  Ble+Peripheral.swift
//  Project-Hub-Max
//


import Foundation
import CoreBluetooth

extension Ble: CBPeripheralDelegate {
	public func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
		if let error = error {
			print("errro \(error)")
			return
		}
		guard (peripheral.services != nil) else { return }
		for service in peripheral.services! {
			peripheral.discoverCharacteristics(nil, for: service)
		}
	}

	public func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
		guard let characteristics = service.characteristics else { return }

		guard let peri = self.peripherals.first(where: {$0.cbPeripheral == peripheral}) else { return }

		if peri.cfPeripheral != nil {
			for characteristic in characteristics {
				if characteristic.properties.contains(.notify) {
					peripheral.setNotifyValue(true, for: characteristic)
				}
			}
		}
		self.connectionStatus[peri] = .Connected
	}

	public func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
		if let error = error {
			print(error)
			return
		}

		guard let data = characteristic.value else { return }

		guard let message = String(data: data, encoding: .utf8) else { return }

		self.readContent[characteristic] = message
		self.delegate?.didReceiveUpdate(content: message, for: characteristic)
	}

	public func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
		guard let value = characteristic.value, let message: String = String(data: value, encoding: .utf8) else { return }

		self.delegate?.didWriteValue(on: characteristic, content: message)
	}

	public func readCharacteristic(with id: CBUUID, from peripheral: Peripheral) {
		guard let services = peripheral.cbPeripheral.services else { return }

		var characteristic: CBCharacteristic? = nil
		for service in services {
			guard let char = service.characteristics?.first(where: {$0.uuid == id}) else { continue }

			characteristic = char
			break
		}
		guard (characteristic != nil) else { return }
		peripheral.cbPeripheral.readValue(for: characteristic!)
	}

	public func writeToCharacteristic(data: String, characteristic: CBCharacteristic, type: CBCharacteristicWriteType, from peripheral: Peripheral) {
		guard let dataD = data.data(using: .utf8) else { return }

		peripheral.cbPeripheral.writeValue(dataD, for: characteristic, type: type)
	}

	public func updateCharacteristic(characteristic: CBCharacteristic, with value: String) {
		guard let data = value.data(using: .utf8) else { return }
		guard let characteristicMut = characteristic as? CBMutableCharacteristic else { return }

		self.peripheralManager?.updateValue(data, for: characteristicMut, onSubscribedCentrals: nil)
		self.myCharactersticsValues[characteristic] = value
	}

	public func subscribeToCharacteristic(from peripheral: Peripheral, characteristic: CBCharacteristic) {
		peripheral.cbPeripheral.setNotifyValue(true, for: characteristic)
	}
}
