//
//  Ble+Delegate.swift
//  Project-Hub-Max
//
//  Created by Raphael Labourel on 27/04/2023.
//

import Foundation
import CoreBluetooth

public protocol BleDelegate {
	func didConnectToPeripheral(peripheral: Peripheral)
	func didDiscoverPeripheral(discovered peripheral: Peripheral)
	func didFailedToConnect(to peripheral: Peripheral)
	func didGotDisconnected(from peripheral: Peripheral)

	func didStartAdvertising(peripheral: CBPeripheralManager)
	func didSubscribeTo(characteristic: CBCharacteristic)
	func didUnsubscribeFrom(characteristic: CBCharacteristic)
	func didReceiveWrite(on characteristic: CBCharacteristic)
	func didReceiveRead(on characteristic: CBCharacteristic)

	func didWriteValue(on characteristic: CBCharacteristic, content: String)

	func didReceiveUpdate(content: String, for characteristic: CBCharacteristic)
}
