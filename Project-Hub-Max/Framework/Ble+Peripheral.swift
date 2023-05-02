//
//  Ble+Peripheral.swift
//  Project-Hub-Max
//
//  Created by Raphael Labourel on 28/04/2023.
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
		self.delegate?.didReceiveUpdate(content: message)
	}

	public func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
		self.delegate?.didWriteValue(on: characteristic)
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

	public func subscribeToCharacteristic(from peripheral: Peripheral, characteristic: CBCharacteristic) {
		peripheral.cbPeripheral.setNotifyValue(true, for: characteristic)
	}
}
