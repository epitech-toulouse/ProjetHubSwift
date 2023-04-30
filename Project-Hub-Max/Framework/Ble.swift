//
//  Ble.swift
//  Project-Hub-Max
//
//  Created by Raphael Labourel on 27/04/2023.
//

import Foundation
import CoreBluetooth

public class Ble: NSObject, ObservableObject {
	internal var centralManager: CBCentralManager? = nil
	internal var peripheralManager: CBPeripheralManager? = nil

	public let config: Config

	@Published public var peripherals: [Peripheral] = []

	@Published public var connectionStatus: [Peripheral : ConnectionStatus] = [:]

	@Published public var readContent: [CBCharacteristic : String] = [:]

	public var connectedPeripherals: [Peripheral] {
		return self.peripherals.filter({$0.cbPeripheral.state == .connected})
	}

	internal var myServices: [CBMutableService] = []

	public var delegate: BleDelegate?

	internal let bleDispatchQueue: DispatchQueue
	private let centralDispatchQueue: DispatchQueue
	private let peripheralManagerDispatchQueue: DispatchQueue

	public init(from configFile: URL?) {
		do {
			self.config = try Config(from: configFile)
		} catch {
			self.config = Config()
		}

		self.centralDispatchQueue = DispatchQueue(label: "Central", qos: .background, attributes: .concurrent, autoreleaseFrequency: .workItem, target: .main)
		self.peripheralManagerDispatchQueue = DispatchQueue(label: "PeripheralManager", qos: .background, attributes: .concurrent, autoreleaseFrequency: .workItem, target: .main)
		self.bleDispatchQueue = DispatchQueue(label: "Ble", qos: .default, attributes: .concurrent, autoreleaseFrequency: .workItem, target: .main)

		super.init()

		self.centralManager = CBCentralManager(delegate: self, queue: self.centralDispatchQueue)
		self.peripheralManager = CBPeripheralManager(delegate: self, queue: self.peripheralManagerDispatchQueue)
	}
}
