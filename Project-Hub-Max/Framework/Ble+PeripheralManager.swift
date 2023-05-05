//
//  Ble+Peripheral.swift
//  Project-Hub-Max
//


import Foundation
import CoreBluetooth

extension Ble: CBPeripheralManagerDelegate {
	public func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
		if peripheral.state == .poweredOn {
			let advertData = [CBAdvertisementDataLocalNameKey: self.config.myPeripheral.name]

			self.peripheralManager?.startAdvertising(advertData)
            initService()
		}
	}

    /// This method init all the services detailed in the config file
	private func initService() {
		self.peripheralManager?.removeAllServices()
		for service in self.config.myPeripheral.services {
			let remoteService = CBUUID(nsuuid: service.id)

			self.myServices.append(CBMutableService(type: remoteService, primary: service.primary))
			self.createCharacteristics(for: self.myServices.last!, using: service)
		}
	}

    /// This method create all the characteritics detaileed in the config file for one service
    /// - Parameters:
    ///   - service: the service to create the characteristic of
    ///   - cfService: the config service containing the information needed to create the characteristic
	private func createCharacteristics(for service: CBMutableService, using cfService: CFService) {
		let permissions: CBAttributePermissions = [.readable, .writeable]
		var cbCharacteristics: [CBCharacteristic] = []

		for characteristic in cfService.characteristics {
			var properties: CBCharacteristicProperties = []

			for property in characteristic.properties {
				guard let propertyValue = CharacteristicProperty(rawValue: property.value) else {
					print("Characteristic type not found")
					return
				}

				switch propertyValue {
					case .notify: properties.insert(.notify)
					case .read: properties.insert(.read)
					case .write: properties.insert(.write)
					case .writeWithoutResponse: properties.insert(.writeWithoutResponse)
				}
				properties.remove(.extendedProperties)
			}
            let cbCharacteristic = CBMutableCharacteristic(type: CBUUID(nsuuid: characteristic.id), properties: properties, value: nil, permissions: permissions)
            cbCharacteristics.append(cbCharacteristic)
		}
		service.characteristics = cbCharacteristics
		self.peripheralManager?.add(service)
	}

	public func peripheralManagerDidStartAdvertising(_ peripheral: CBPeripheralManager, error: Error?) {
		self.delegate?.didStartAdvertising(peripheral: peripheral)
	}

	public func peripheralManager(_ peripheral: CBPeripheralManager, didReceiveWrite requests: [CBATTRequest]) {
        guard (requests.first != nil) else { return }
		for request in requests {
            if let value = request.value {
                (request.characteristic as? CBMutableCharacteristic)?.value = value
                self.myCharactersticsValues[request.characteristic] = String(data: value, encoding: .utf8)
            }
            self.delegate?.didReceiveWrite(on: request.characteristic)
		}
        peripheral.respond(to: requests.first!, withResult: .success)
	}

	public func peripheralManager(_ peripheral: CBPeripheralManager, didReceiveRead request: CBATTRequest) {
		request.value = request.characteristic.value
        self.delegate?.didReceiveRead(on: request.characteristic)
		peripheral.respond(to: request, withResult: .success)
	}

    public func peripheralManager(_ peripheral: CBPeripheralManager, central: CBCentral, didSubscribeTo characteristic: CBCharacteristic) {
        self.delegate?.didSubscribeTo(characteristic: characteristic)
    }

    public func peripheralManager(_ peripheral: CBPeripheralManager, central: CBCentral, didUnsubscribeFrom characteristic: CBCharacteristic) {
        self.delegate?.didUnsubscribeFrom(characteristic: characteristic)
    }
}
