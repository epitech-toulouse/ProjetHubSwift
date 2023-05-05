//
//  Ble+Delegate.swift
//  Project-Hub-Max
//
//  Created by Raphael Labourel on 27/04/2023.
//

import Foundation
import CoreBluetooth

public protocol BleDelegate {
	/// Callled when a connection is established with a peripheral
	func didConnectToPeripheral(peripheral: Peripheral)
	/// Callled when a peripheral is discovered
	func didDiscoverPeripheral(discovered peripheral: Peripheral)
	/// Callled when a connection is failed with a peripheral
	func didFailedToConnect(to peripheral: Peripheral)
	/// Callled when a diconnection occured with a peripheral
	func didGotDisconnected(from peripheral: Peripheral)

	/// Callled when amy peripheral is all set up and started to adverstise its name
	func didStartAdvertising(peripheral: CBPeripheralManager)
	/// Callled when my peripheral subscribed to a characteristic
	func didSubscribeTo(characteristic: CBCharacteristic)
	/// Callled when my peripheral unsubscribed to a characteristic
	func didUnsubscribeFrom(characteristic: CBCharacteristic)
	/// Callled when my peripheral received a write on a characteristic
	func didReceiveWrite(on characteristic: CBCharacteristic)
	/// Callled when my peripheral received a read on a characteristic
	func didReceiveRead(on characteristic: CBCharacteristic)

	/// Callled when my peripheral has successfully wrote in a characteristic
	func didWriteValue(on characteristic: CBCharacteristic, content: String)

	/// Called when a value of a sub characteristic has been updated
	func didReceiveUpdate(content: String, for characteristic: CBCharacteristic)
}
