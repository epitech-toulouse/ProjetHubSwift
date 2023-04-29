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

		for characteristic in characteristics {
			if characteristic.properties.contains(.notify) {
				peripheral.setNotifyValue(true, for: characteristic)
			}
		}
		guard let peri = self.peripherals.first(where: {$0.cbPeripheral == peripheral}) else { return }

		self.connectionStatus[peri] = .Connected
	}

	public func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
		if let error = error {
			print(error)
			return
		}

		guard let data = characteristic.value else { return }

		guard let message = String(data: data, encoding: .utf8) else { return }

		self.delegate?.didReceiveUpdate(content: message)
	}

	public func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
		self.delegate?.didWriteValue(on: characteristic)
	}
}
