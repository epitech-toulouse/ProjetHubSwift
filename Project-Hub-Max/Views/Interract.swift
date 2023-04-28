//
//  Interract.swift
//  Project-Hub-Max
//
//  Created by Raphael Labourel on 27/04/2023.
//

import SwiftUI

struct Interract: View {
    var body: some View {
		HStack {
			Button("Send", action: {
				print("send")
			})
		}
    }
}

struct Interract_Previews: PreviewProvider {
    static var previews: some View {
        Interract()
    }
}
