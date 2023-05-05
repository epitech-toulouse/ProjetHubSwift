//
//  BleConfig.swift
//  Project-Hub-Max
//


import Foundation

/// This struct is the  object of the json file
public struct Config: Decodable {
	/// Representing my peripheral
	public let myPeripheral: CFPeripheral
	/// Representing the peropheral I would like to connect to automatically
	public let toFindPeripherals: [CFPeripheral]?

	public init(from configFile: URL?) throws {
		guard (configFile != nil) else {
			throw URLError(.badURL)
		}
		do {
			let data = try Data(contentsOf: configFile!, options: .mappedIfSafe)
			let decoder = JSONDecoder()

			self = try decoder.decode(Config.self, from: data)
		} catch {
			throw error
		}
	}

	public init() {
		self.toFindPeripherals = nil
		self.myPeripheral = CFPeripheral(name: "Error", services: [])
	}

	public func findPeripheral(with name: String) -> CFPeripheral? {
		guard (toFindPeripherals != nil) else {
			return nil
		}
		return toFindPeripherals!.first(where: {$0.name == name})
	}
}

public struct CFPeripheral: Decodable, Hashable {
	/// The name of the peripheral that will be used to adverstise
	public let name: String
	/// The list of all the services it will use and create
	public let services: [CFService]

	private enum CodingKeys: CodingKey {
		case name
		case services
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)

		self.name = try container.decode(String.self, forKey: .name)
		self.services = try container.decodeIfPresent([CFService].self, forKey: .services) ?? []
	}

	public init(name: String, services: [CFService]) {
		self.name = name
		self.services = services
	}

	public static func == (lhs: CFPeripheral, rhs: CFPeripheral) -> Bool {
		return lhs.name == rhs.name && lhs.services == lhs.services
	}

	public func hash(into hasher: inout Hasher) {
		hasher.combine(name)
		hasher.combine(services)
	}
}

public struct CFService: Decodable, Hashable {
	/// The id of the service
	public let id: UUID
	//// The characteristics list of the service
	public let characteristics: [CFCharacteristic]
	/// Is the service primary ?
	public let primary: Bool

	private enum CodingKeys: CodingKey {
		case id
		case characteristics
		case primary
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)

		self.id = try container.decode(UUID.self, forKey: .id)
		self.characteristics = try container.decodeIfPresent([CFCharacteristic].self, forKey: .characteristics) ?? []
		self.primary = try container.decodeIfPresent(Bool.self, forKey: .primary) ?? false
	}

	public static func == (lhs: CFService, rhs: CFService) -> Bool {
		return lhs.id == rhs.id
	}

	public func hash(into hasher: inout Hasher) {
		hasher.combine(id)
		hasher.combine(characteristics)
	}
}

public struct CFCharacteristic: Decodable, Hashable {
	/// The id of the characteristic to create
	public let id: UUID
	/// A list of propery defining the usage of the characteristic
	public let properties: [CFProperty]

	private enum CodingKeys: CodingKey {
		case id
		case properties
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)

		self.id = try container.decode(UUID.self, forKey: .id)
		self.properties = try container.decodeIfPresent([CFProperty].self, forKey: .properties) ?? []
	}

	public static func == (lhs: CFCharacteristic, rhs: CFCharacteristic) -> Bool {
		return lhs.id == rhs.id
	}

	public func hash(into hasher: inout Hasher) {
		hasher.combine(id)
		hasher.combine(properties)
	}
}

public struct CFProperty: Decodable, Hashable {
	public let value: String
}
