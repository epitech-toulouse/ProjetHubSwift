//
//  Project_Hub_MaxApp.swift
//  Project-Hub-Max
//
//  Created by Raphael Labourel on 27/04/2023.
//

import SwiftUI
import CoreBluetooth

enum BleError: Error {
	case noMyPeripheral
}

@main
struct Project_Hub_MaxApp: App {
	@ObservedObject var ble: Ble

	init() {
		let url = Bundle.main.url(forResource: "bleConfig", withExtension: "json")

		ble = Ble(from: url)
		ble.delegate = self
	}

    var body: some Scene {
        WindowGroup {
			ContentView()
				.environmentObject(ble)
        }
    }
}

extension Project_Hub_MaxApp: BleDelegate {
	func didConnectToPeripheral(peripheral: Peripheral) {
		print("did connect to peripheral \(String(describing: peripheral.cbPeripheral.name))")
	}

	func didGotDisconnected(from peripheral: Peripheral) {
		print("Did got disconected from \(String(describing: peripheral.cbPeripheral.name))")
	}

	func didDiscoverPeripheral(discovered peripheral: Peripheral) {
		print("did discover peripheral \(String(describing: peripheral.cbPeripheral.name))")
	}

	func didFailedToConnect(to peripheral: Peripheral) {

	}

	func didStartAdvertising(peripheral: CBPeripheralManager) {
		print("did start adv")
	}

	func didSubscribeTo(characteristic: CBCharacteristic) {
		print("did sub to")
	}

	func didUnsubscribeFrom(characteristic: CBCharacteristic) {
		print("did unsub to")
	}

	func didReceiveWrite(on characteristic: CBCharacteristic) {
		print("did receive write")
	}

	func didReceiveRead(on characteristic: CBCharacteristic) {
		print("did receive read")
	}

	func didWriteValue(on characteristic: CBCharacteristic) {
		print("did write")
	}

	func didReceiveUpdate(content: String) {
		print("received update \(content)")
	}
}
