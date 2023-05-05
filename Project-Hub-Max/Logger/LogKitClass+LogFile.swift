//
//  LogKitClass+logFile.swift
//  Logger
//


import Foundation

// MARK: - Extension About The Log File
extension LogKit {
    // MARK: - Get Log File Content
    /// This function is used to retreive the content of the log file
    ///  - Returns: A `String` containing the log text if **succeed** or `nil` if **failed**
    public func getLogFileContent() -> String {
        do {
            let savedData = try Data(contentsOf: self.logFileURL)
            if let savedString = String(data: savedData, encoding: .utf8) {
                return savedString
            }
            return ""
        } catch {
            print("Unable to open the log file")
            return ""
        }
    }

    // MARK: - Write To Log File
    /// This function append to a log file the `log` parameter
    /// - Parameters:
    ///    - log:  A `String`that will be **appended** to the log file
    private func writeToFile(log: String) {
		defer {
			self.isUpdating = false
		}
        DispatchQueue.main.async {
            guard let data = log.data(using: .utf8) else {
                self.critical(message: "Unable to convert string to data")
                return
            }
            if FileManager.default.fileExists(atPath: self.logFileURL.path) {
                do {
                    let fileHandle = try FileHandle(forWritingTo: self.logFileURL)
                    try fileHandle.seekToEnd()
                    try fileHandle.write(contentsOf: data)
                    try fileHandle.close()
                } catch {
                    return
                }
            } else {
                FileManager.default.createFile(atPath: self.logFileURL.path, contents: data)
            }
        }
        
    }

    // MARK: - createMessage
    /// This function handles the creation of the logMessage
    /// - Parameters:
    ///    - log: A string beung the log
    public func appendLog(log: String) {
        self.writeToFile(log: log)
    }

    // MARK: - createMessage
    /// This function handles the creation of the logMessage with a proper date and formatting
    /// - Parameters:
    ///    - typeOf: A string explaining the type of the log
    ///    - message: The **main** `String` of the log, use it to **describe**
    ///    - value: The value you want to add, if there is any, I recommend logging the line and the file with it
    private func createMessage(typeOf: String, message: String, value: Any?) -> String {
		self.isUpdating = true
        return value == nil ? "[\(self.dateFormatter.string(from: Date()))] `\(typeOf)` : \(message)\n" :
        "[\(self.dateFormatter.string(from: Date()))] `\(typeOf)` : \(message) ==> \(value!)\n"
    }

    // MARK: - Log
    /// Create a log, refer to the Logger documentation for more details between the different type of logs
    ///  - Parameters:
    ///     - message: The **main** `String` of the log, use it to **describe**
    ///     - value: The value you want to add, if there is any, I recommend logging the line and the file with it
    public func log(message: String, value: Any? = nil) {
        let message = createMessage(typeOf: "LOG", message: message, value: value)

        self.logger.log("\(message)")
        self.writeToFile(log: message)
    }

    // MARK: - Debug
    /// Create a log, refer to the Logger documentation for more details between the different type of logs
    ///  - Parameters:
    ///     - message: The **main** `String` of the log, use it to **describe**
    ///     - value: The value you want to add, if there is any, I recommend logging the line and the file with it
    public func debug(message: String, value: Any? = nil) {
        let message = createMessage(typeOf: "DEBUG", message: message, value: value)

        self.logger.debug("\(message)")
        self.writeToFile(log: message)
    }

    // MARK: - Error
    /// Create a log, refer to the Logger documentation for more details between the different type of logs
    ///  - Parameters:
    ///     - message: The **main** `String` of the log, use it to **describe**
    ///     - value: The value you want to add, if there is any, I recommend logging the line and the file with it
    public func error(message: String, value: Any? = nil) {
        let message = createMessage(typeOf: "ERROR", message: message, value: value)

        self.logger.error("\(message)")
        self.writeToFile(log: message)
    }

    // MARK: - Critical
    /// Create a log, refer to the Logger documentation for more details between the different type of logs
    ///  - Parameters:
    ///     - message: The **main** `String` of the log, use it to **describe**
    ///     - value: The value you want to add, if there is any, I recommend logging the line and the file with it
    public func critical(message: String, value: Any? = nil) {
        let message = createMessage(typeOf: "CRITICAL ERROR", message: message, value: value)

        self.logger.critical("\(message)")
        self.writeToFile(log: message)
    }

    // MARK: - Fault
    /// Create a log, refer to the Logger documentation for more details between the different type of logs
    ///  - Parameters:
    ///     - message: The **main** `String` of the log, use it to **describe**
    ///     - value: The value you want to add, if there is any, I recommend logging the line and the file with it
    public func fault(message: String, value: Any? = nil) {
        let message = createMessage(typeOf: "BUG", message: message, value: value)

        self.logger.fault("\(message)")
        self.writeToFile(log: message)
    }

    // MARK: - Info
    /// Create a log, refer to the Logger documentation for more details between the different type of logs
    ///  - Parameters:
    ///     - message: The **main** `String` of the log, use it to **describe**
    ///     - value: The value you want to add, if there is any, I recommend logging the line and the file with it
    public func info(message: String, value: Any? = nil) {
        let message = createMessage(typeOf: "INFO", message: message, value: value)

        self.logger.info("\(message)")
        self.writeToFile(log: message)
    }

    // MARK: - Notice
    /// Create a log, refer to the Logger documentation for more details between the different type of logs
    ///  - Parameters:
    ///     - message: The **main** `String` of the log, use it to **describe**
    ///     - value: The value you want to add, if there is any, I recommend logging the line and the file with it
    public func notice(message: String, value: Any? = nil) {
        let message = createMessage(typeOf: "NOTICE", message: message, value: value)

        self.logger.notice("\(message)")
        self.writeToFile(log: message)
    }

    // MARK: - Trace
    /// Create a log, refer to the Logger documentation for more details between the different type of logs
    ///  - Parameters:
    ///     - message: The **main** `String` of the log, use it to **describe**
    ///     - value: The value you want to add, if there is any, I recommend logging the line and the file with it
    public func trace(message: String, value: Any? = nil) {
        let message = createMessage(typeOf: "TRACE MESSAGE", message: message, value: value)

        self.logger.trace("\(message)")
        self.writeToFile(log: message)
    }

    // MARK: - Warning
    /// Create a log, refer to the Logger documentation for more details between the different type of logs
    ///  - Parameters:
    ///     - message: The **main** `String` of the log, use it to **describe**
    ///     - value: The value you want to add, if there is any, I recommend logging the line and the file with it
    public func warning(message: String, value: Any? = nil) {
        let message = createMessage(typeOf: "WARNING", message: message, value: value)

        self.logger.warning("\(message)")
        self.writeToFile(log: message)
    }
}
