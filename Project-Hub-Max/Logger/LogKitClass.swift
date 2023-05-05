//
//  LogKitClass.swift
//  Logger
//

import Foundation
import SwiftUI
import os

// MARK: - LogKit
/// Init a new instance of the LogKit
/// Logs will be placed in a place handled by Logger and will be saved in another personal file
open class LogKit: ObservableObject {
    // MARK: - LogKit properties
    /// A logger instance used to display the logs in the console
    internal let logger: Logger
    /// The URL where the log file is stored
    internal var logFileURL: URL
    /// The URL where the data file is stored
    internal var dataFileURL: URL
    /// Date formatter used to create the date as a parsable string
    internal var dateFormatter: DateFormatter
	/// This bool is used to refresh a view, it's toggled everytime a log or a data is added
	@Published public var isUpdating: Bool = false

    // MARK: - LogKit init
    /// Init a new instance of the LogKit
    /// Logs will be placed in a place handled by Logger and will be saved in another personal file
    public init() {
        let subsystem = Bundle.main.bundleIdentifier ?? "fr.logger.logkit"

        self.logger = Logger(subsystem: subsystem, category: "main")
        self.logFileURL = LogKit.getLogFileURL()
        self.dataFileURL = LogKit.getDataFileURL()
        self.dateFormatter = DateFormatter()
        self.dateFormatter.dateFormat = "d MMM yyyy, hh:mm:ss"
    }

    // MARK: - Class Get Directory URL
    /// This function returns the URL of the directory where the files are stored
    /// - Returns: The `URL` of the directory
    public class func getDirectoryURL() -> URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }

    // MARK: - Class Get Log File URL
    /// This function returns the URL to the log file, a txt file containing pure log
    /// - Returns: The `URL` of the log file
    public class func getLogFileURL() -> URL {
        let directoryURL = LogKit.getDirectoryURL()
        return URL(fileURLWithPath: "log", relativeTo: directoryURL).appendingPathExtension("txt")
    }

    // MARK: - Class Get Data File URL
    /// This function returns the URL to the data file, a json file containing the dats that were stored
    /// - Returns: The `URL` of the data file
    public class func getDataFileURL() -> URL {
        let directoryURL = LogKit.getDirectoryURL()
        return URL(fileURLWithPath: "data", relativeTo: directoryURL).appendingPathExtension("json")
    }

    // MARK: - Class Get Data File Content
    /// This function is used to retreive the content of the data file
    ///  - Returns: A `dictionary` containing the JSON data if **succeed** or `nil` if **failed**
    public class func getDataFileContent() -> [String : Any]? {
        let dataURL = LogKit.getDataFileURL()
        do {
            let data = try Data(contentsOf: dataURL)
            let dictionary: [String : Any] = try JSONSerialization.jsonObject(with: data) as! [String : Any]

            return dictionary
        } catch {
            print("Unable to open the data file")
            return nil
        }
    }

    // MARK: - Class Get Data File Content
    /// This function is used to retreive the content of the data file
    ///  - Returns: A `String` containing the JSON data if **succeed** or `nil` if **failed**
    public class func getDataFileContentString() -> String? {
        let dataURL = LogKit.getDataFileURL()
        do {
            let data = try Data(contentsOf: dataURL)
            let stringResult = String(bytes: data, encoding: .utf8)

            return stringResult
        } catch {
            print("Unable to open the data file")
            return nil
        }
    }

    // MARK: - Class Get Log File URL
    /// This function is used to retreive the content of the log file
    ///  - Returns: A `String` containing the log text if **succeed** or `nil` if **failed**
    public class func getLogFileContent() -> String? {
        let logURL = LogKit.getLogFileURL()
        do {
            let savedData = try Data(contentsOf: logURL)
            if let savedString = String(data: savedData, encoding: .utf8) {
                return savedString
            }
            return nil
        } catch {
            print("Unable to open the log file")
            return nil
        }
    }

    // MARK: - Class Delete File
    /// This function is used to delete files when they are synchronized with Internet
    /// - Parameters:
    ///   - path: The `URL` to the file to be **deleted**
    public func deleteFile(at path: URL) {
        do {
            try FileManager.default.removeItem(at: path)
        } catch {
            print(error)
        }
    }
}
