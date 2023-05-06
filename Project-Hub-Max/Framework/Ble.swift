//
//  Ble.swift
//  Project-Hub-Max
//


import Foundation
import CoreBluetooth

public class Ble: NSObject, ObservableObject {
	/// The manager of other devices
	internal var centralManager: CBCentralManager? = nil

	/// Manager of my device
	internal var peripheralManager: CBPeripheralManager? = nil

	/// The config
	public let config: Config

	/// List of peripherals detected
	@Published public var peripherals: [Peripheral] = []

	/// List of peripheral that used to be connected, are connected or disconnected from us
	@Published public var connectionStatus: [Peripheral : ConnectionStatus] = [:]

	/// The list of all the characterstics values
	@Published public var readContent: [CBCharacteristic : String] = [:]

	/// The lsit of all my own charactertics values
	@Published public var myCharactersticsValues: [CBCharacteristic : String] = [:]

	@Published public var mySubscribedList: [CBCharacteristic] = []

	/// List of my services
	internal var myServices: [CBMutableService] = []

	internal var advertisedName: String

	/// Delegate to handle events outside of the cle
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

		self.advertisedName = self.config.myPeripheral.name

		super.init()

		self.centralManager = CBCentralManager(delegate: self, queue: self.centralDispatchQueue)
		self.peripheralManager = CBPeripheralManager(delegate: self, queue: self.peripheralManagerDispatchQueue)
	}

	/// refresh the list of peripherals detected and connected
	public func refreshPeripheralList() {
		for (peripheral, status) in self.connectionStatus {
			if status == .Connected {
				self.disconnectFromPeripheral(peripheral: peripheral)
			}
		}
		self.peripherals = []
		self.connectionStatus = [:]
		self.readContent = [:]
		self.mySubscribedList = []
		self.centralManager?.stopScan()
		self.centralManager?.scanForPeripherals(withServices: nil)
	}

	public func updateAdvertisedName(new name: String) {
		self.advertisedName = name

		let advertData = [CBAdvertisementDataLocalNameKey: self.advertisedName]

		self.peripheralManager?.startAdvertising(advertData)
		
	}
}
