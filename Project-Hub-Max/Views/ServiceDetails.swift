//
//  ServideDetails.swift
//  Project-Hub-Max
//
//  Created by Raphael Labourel on 27/04/2023.
//

import SwiftUI
import CoreBluetooth

struct ServiceDetails: View {
	@Binding var selectServ: CBService?
	@Binding var peripheralSelected: Peripheral?

    var body: some View {
		if let serv = selectServ, let characteristics = serv.characteristics {
			Text("Characteristics of \(serv.uuid.uuidString)")
			List(characteristics, id: \.self, selection: $selectServ) { characteristic in
				CharacteristicsDetail(characteristic: characteristic, peripheralSelected: $peripheralSelected)
			}
		} else {
			Text("Select a service")
		}
    }
}

struct CharacteristicsDetail: View {
	let characteristic: CBCharacteristic
	@Binding var peripheralSelected: Peripheral?
	@EnvironmentObject var ble: Ble
	@State private var message: String = ""

	var body: some View {
		if let peripheral = peripheralSelected {
			VStack {
				Text(characteristic.uuid.uuidString)
				if characteristic.properties.contains(.write) {
					TextField("Enter your data to write here", text: $message)
				}
				HStack(spacing: 12) {
					Spacer()
					if characteristic.properties.contains(.read) {
						Button(ble.readContent.contains(where: {$0.key == characteristic}) ? "Read value: \(ble.readContent[characteristic] ?? "")" : "Read value", action: {
							ble.readCharacteristic(with: characteristic.uuid, from: peripheral)
						})
						.buttonStyle(MyButtonStyle())
					}
					if characteristic.properties.contains(.write) {
						Button("Write", action: {
							ble.writeToCharacteristic(data: message, characteristic: characteristic, type: .withResponse, from: peripheral)
						})
							.buttonStyle(MyButtonStyle())
					}
					if characteristic.properties.contains(.notify) {
						Button(ble.mySubscribedList.contains(where: {$0 == characteristic}) ? "Unsubscribe" : "Subscribe", action: {
							if ble.mySubscribedList.contains(where: {$0 == characteristic}) {
								ble.unsubscribeFromCharacteristic(from: peripheral, characteristic: characteristic)
								return
							}
							ble.subscribeToCharacteristic(from: peripheral, characteristic: characteristic)
						})
							.buttonStyle(MyButtonStyle())
					}
					Spacer()
				}
			}
		} else {
			VStack {
				Text(characteristic.uuid.uuidString)
				if characteristic.properties.contains(.write) {
					TextField("Enter your data to write here", text: $message)
				}
				HStack(spacing: 12) {
					Spacer()
					if characteristic.properties.contains(.read) {
						Button(ble.myCharactersticsValues.contains(where: {$0.key == characteristic}) ? "Value: \(ble.myCharactersticsValues[characteristic] ?? "")" : "No value set", action: {
							print(self.ble.myCharactersticsValues)
						})
						.buttonStyle(MyButtonStyle())
					}
					if characteristic.properties.contains(.write) {
						Button("Update value", action: {
							ble.updateCharacteristic(characteristic: characteristic, with: message)
						})
						.buttonStyle(MyButtonStyle())
					}
					Spacer()
				}
			}
		}
	}
}

public struct MyButtonStyle: ButtonStyle {
	public func makeBody(configuration: Configuration) -> some View {
		configuration.label
			.padding()
			.background(.regularMaterial, in: Capsule())
			.buttonStyle(.borderedProminent)
	}

}
