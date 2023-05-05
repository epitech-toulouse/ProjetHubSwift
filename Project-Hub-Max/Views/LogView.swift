//
//  Interract.swift
//  Project-Hub-Max
//

import SwiftUI

struct LogView: View {
	@EnvironmentObject var logger: LogKit
	@State private var isAlertShowing: Bool = false

    var body: some View {
		ScrollView {
			if logger.isUpdating == false {
				Text(logger.getLogFileContent())
					.padding()
			}
		}
		.refreshable {
			logger.isUpdating = true
			logger.isUpdating = false
		}
		.onAppear {
			logger.isUpdating = true
			logger.isUpdating = false
		}
		.alert("Would you like to clear the log file", isPresented: $isAlertShowing) {
			Button("Yes", role: .destructive, action: {
				logger.deleteFile(at: logger.logFileURL)
			})
			Button("No", role: .cancel, action: {})
		}
		.onLongPressGesture(perform: {
			isAlertShowing.toggle()
		})
    }
}
