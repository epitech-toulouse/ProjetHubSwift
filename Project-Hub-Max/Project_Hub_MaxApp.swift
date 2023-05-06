//
//  Project_Hub_MaxApp.swift
//  Project-Hub-Max
//


import SwiftUI
import CoreBluetooth

enum BleError: Error {
	case noMyPeripheral
}

@main
struct Project_Hub_MaxApp: App {
	@ObservedObject var ble: Ble
	@ObservedObject var logger: LogKit = LogKit()

	init() {
		let url = Bundle.main.url(forResource: "bleConfig", withExtension: "json")

		ble = Ble(from: url)
		ble.delegate = self
	}

    var body: some Scene {
        WindowGroup {
			ContentView()
				.environmentObject(ble)
				.environmentObject(logger)
        }
    }
}

extension Project_Hub_MaxApp: BleDelegate {
	func didConnectToPeripheral(peripheral: Peripheral) {
		self.logger.log(message: "Successfully connected to \(String(describing: peripheral.cbPeripheral.name))")
	}

	func didGotDisconnected(from peripheral: Peripheral) {
		if ble.connectionStatus[peripheral] == .Aborted {
			self.logger.error(message: "The peripheral \(String(describing: peripheral.cbPeripheral.name)) disconnected from us")
		} else {
			self.logger.log(message: "The peripheral \(String(describing: peripheral.cbPeripheral.name)) disconnected from us")
		}

	}

	func didDiscoverPeripheral(discovered peripheral: Peripheral) {
		print("did discover peripheral \(String(describing: peripheral.cbPeripheral.name))")
	}

	func didFailedToConnect(to peripheral: Peripheral) {
		self.logger.error(message: "Failed to establish a connection with \(String(describing: peripheral.cbPeripheral.name))")
	}

	func didStartAdvertising(peripheral: CBPeripheralManager) {
		self.logger.info(message: "Did start advertising as \(ble.config.myPeripheral.name)")
	}

	func didGotSubscribedTo(characteristic: CBCharacteristic) {
		self.logger.log(message: "Successfully got subscribed to \(String(describing: characteristic.uuid.uuidString))")
	}

	func didGotUnsubscribedFrom(characteristic: CBCharacteristic) {
		self.logger.log(message: "Successfully got unsubscribed from \(String(describing: characteristic.uuid.uuidString))")
	}

	func didReceiveWrite(on characteristic: CBCharacteristic) {
		guard let value = characteristic.value else { return }
		guard let message = String(data: value, encoding: .utf8) else { return }

		self.logger.log(message: "Did receive write \(message) on characteristic \(characteristic.uuid.uuidString)")
	}

	func didReceiveRead(on characteristic: CBCharacteristic) {
		self.logger.log(message: "Characteristic \(characteristic.uuid.uuidString) got read")
	}

	func didWriteValue(on characteristic: CBCharacteristic, content: String) {
		self.logger.log(message: "Successfully write \(content) into \(characteristic.uuid.uuidString))")
	}

	func didReceiveUpdate(content: String, for characteristic: CBCharacteristic) {
		self.logger.log(message: "Value updated to \(content) for characteristic \(characteristic.uuid.uuidString)")
	}
}
