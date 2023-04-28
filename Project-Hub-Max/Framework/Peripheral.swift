//
//  Peripheral.swift
//  Project-Hub-Max
//
//  Created by Raphael Labourel on 28/04/2023.
//

import Foundation
import CoreBluetooth

public struct Color {
	public let r: Double
	public let g: Double
	public let b: Double
	public let a: Double
}

public class Peripheral: Hashable {
	public let cfPeripheral: CFPeripheral?
	public let cbPeripheral: CBPeripheral

	public let textColor: Color

	public init(cfPeripheral: CFPeripheral?, cbPeripheral: CBPeripheral) {
		self.cfPeripheral = cfPeripheral
		self.cbPeripheral = cbPeripheral

		textColor = cfPeripheral == nil ? Color(r: 255, g: 0, b: 0, a: 255) : Color(r: 0, g: 0, b: 255, a: 255)
	}
	public static func == (lhs: Peripheral, rhs: Peripheral) -> Bool {
		return lhs.cfPeripheral == rhs.cfPeripheral && lhs.cbPeripheral == rhs.cbPeripheral
	}

	public func hash(into hasher: inout Hasher) {
		hasher.combine(cbPeripheral)
		hasher.combine(cfPeripheral)
	}

}
