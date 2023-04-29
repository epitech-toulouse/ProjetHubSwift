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
	@EnvironmentObject var ble: Ble

    var body: some View {
		if let serv = selectServ, let characteristics = serv.characteristics {
			Text("Characteristics of \(serv.uuid.uuidString)")
			List(characteristics, id: \.self) { charac in
				Text(charac.uuid.uuidString)
				if charac.properties.contains(.read) {
					Button("Read value", action: {
						ble.readCharacteristic(with: charac.uuid, from: peripheralSelected!)
					})
				}
			}
		} else {
			Text("Select a service")
		}
    }
}
