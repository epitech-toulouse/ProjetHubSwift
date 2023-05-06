//
//  Peripheral.swift
//  Project-Hub-Max
//

import Foundation
import CoreBluetooth

public enum ConnectionStatus: String {
	case Disconnected
	case Connected
	case Aborted
	case Connecting
}

/// Wrapper of cbPeripheral and cfPeripheral
public class Peripheral: Hashable {
	public let cfPeripheral: CFPeripheral?
	public let cbPeripheral: CBPeripheral

	public init(cfPeripheral: CFPeripheral?, cbPeripheral: CBPeripheral) {
		self.cfPeripheral = cfPeripheral
		self.cbPeripheral = cbPeripheral
	}

	public static func == (lhs: Peripheral, rhs: Peripheral) -> Bool {
		return lhs.cfPeripheral == rhs.cfPeripheral && lhs.cbPeripheral == rhs.cbPeripheral
	}

	public func hash(into hasher: inout Hasher) {
		hasher.combine(cbPeripheral)
		hasher.combine(cfPeripheral)
	}

}
