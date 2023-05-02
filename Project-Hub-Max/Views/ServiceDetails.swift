//
//  ServideDetails.swift
//  Project-Hub-Max
//
//  Created by Raphael Labourel on 27/04/2023.
//

import SwiftUI
import CoreBluetooth

struct MyServiceDetails: View {
	@Binding var selectServ: CFService?

	var body: some View {
		if let serv = selectServ {
			Text("Characteristics of \(serv.id.uuidString)")
			List(serv.characteristics, id: \.self) { charac in
				Text(charac.id.uuidString)
				ForEach(charac.properties.indices, id: \.self, content: { indice in
					Button(charac.properties[indice].value, action: {
						print(charac.properties[indice].value)
					})
				})
			}
		} else {
			Text("Select a service")
		}
	}
}

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
						Button("Subscribe", action: {
							ble.subscribeToCharacteristic(from: peripheral, characteristic: characteristic)
						})
							.buttonStyle(MyButtonStyle())
					}
					Spacer()
				}
			}
		}
	}
}

struct MyButtonStyle: ButtonStyle {
	func makeBody(configuration: Configuration) -> some View {
		configuration.label
			.padding()
			.background(.regularMaterial, in: Capsule())
			.buttonStyle(.borderedProminent)
	}

}
