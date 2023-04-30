//
//  Ble+Central.swift
//  Project-Hub-Max
//
//  Created by Raphael Labourel on 27/04/2023.
//

import Foundation
import CoreBluetooth

extension Ble: CBCentralManagerDelegate {
	public func centralManagerDidUpdateState(_ central: CBCentralManager) {
		if central.state == .poweredOn {
			central.scanForPeripherals(withServices: nil)
		}
	}

	public func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
		guard let name = peripheral.name, !self.peripherals.contains(where: {$0.cbPeripheral.name == name}) else {
			return
		}
		let isToFind: CFPeripheral? = self.config.findPeripheral(with: name)

		self.peripherals.append(Peripheral(cfPeripheral: isToFind, cbPeripheral: peripheral))
		self.delegate?.didDiscoverPeripheral(discovered: self.peripherals.last!)
		self.bleDispatchQueue.async {
			if peripheral.state != .disconnected {
				return
			}
			if self.peripherals.last?.cfPeripheral != nil {
				self.connectToPeripheral(peripheral: self.peripherals.last!)
			}
		}
	}

	public func connectToPeripheral(peripheral: Peripheral) {
		let options = [CBConnectPeripheralOptionNotifyOnConnectionKey : true,
					 CBConnectPeripheralOptionNotifyOnNotificationKey : true,
					CBConnectPeripheralOptionNotifyOnDisconnectionKey : true]

		self.connectionStatus[peripheral] = .Connecting

		self.centralManager?.connect(peripheral.cbPeripheral, options: options)
	}

	public func disconnectFromPeripheral(peripheral: Peripheral) {
		self.removeServices(of: peripheral)
		self.centralManager?.cancelPeripheralConnection(peripheral.cbPeripheral)

		self.connectionStatus[peripheral] = .Disconnected
	}

	public func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
		peripheral.delegate = self

		guard let myPeripheral = self.peripherals.first(where: {$0.cbPeripheral == peripheral}) else { return }

		self.delegate?.didConnectToPeripheral(peripheral: myPeripheral)

		peripheral.discoverServices(nil)
	}

	public func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
		print("Failed to connect to peripheral : \(peripheral.name ?? peripheral.identifier.uuidString), error : \(String(describing: error?.localizedDescription))")

		guard let myPeripheral = self.peripherals.first(where: {$0.cbPeripheral == peripheral}) else {
			return
		}
		self.connectionStatus[myPeripheral] = .Aborted
		self.delegate?.didFailedToConnect(to: myPeripheral)
	}

	public func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
		guard let myPeripheral = self.peripherals.first(where: {$0.cbPeripheral == peripheral}) else {
			return
		}
		self.removeServices(of: myPeripheral)
		self.connectionStatus[myPeripheral] = .Aborted
		self.delegate?.didGotDisconnected(from: myPeripheral)
	}

	private func removeServices(of peripheral: Peripheral) {
		if let services = peripheral.cbPeripheral.services {
			for service in services {
				if let characteristics = service.characteristics {
					for characteristic in characteristics {
						self.readContent.removeValue(forKey: characteristic)
					}
				}
			}
		}
	}
}
