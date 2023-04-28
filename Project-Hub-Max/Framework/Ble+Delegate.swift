//
//  Ble+Delegate.swift
//  Project-Hub-Max
//
//  Created by Raphael Labourel on 27/04/2023.
//

import Foundation

public protocol BleDelegate {
	func didConnectToPeripheral(peripheral: Peripheral)
	func didDiscoverPeripheral(discovered peripheral: Peripheral)
	func didFailedToConnect(to peripheral: Peripheral)
}
