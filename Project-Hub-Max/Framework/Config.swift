//
//  BleConfig.swift
//  Project-Hub-Max
//
//  Created by Raphael Labourel on 27/04/2023.
//

import Foundation

public struct Config: Decodable {
	public let myPeripheral: CFPeripheral
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
	public let name: String
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
	public let id: UUID
	public let characteristics: [CFCharacteristic]

	private enum CodingKeys: CodingKey {
		case id
		case characteristics
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)

		self.id = try container.decode(UUID.self, forKey: .id)
		self.characteristics = try container.decodeIfPresent([CFCharacteristic].self, forKey: .characteristics) ?? []
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
	public let id: UUID
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
