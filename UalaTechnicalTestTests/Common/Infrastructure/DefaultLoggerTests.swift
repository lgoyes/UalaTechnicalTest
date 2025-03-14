//
//  DefaultLoggerTests.swift
//  UalaTechnicalTestTests
//
//  Created by Luis David Goyes Garces on 14/3/25.
//

import Testing
@testable import UalaTechnicalTest

class DefaultLoggerTests {
    
    private var printedMessages: [String] = []
    private var sut = DefaultLogger()

    
    @Test func basicFunctionality() {
        GIVEN_setupLoggers()
        WHEN_logMessages()
        THEN_itShouldPrintMessagesToConsole()
    }
    
    func GIVEN_setupLoggers() {
        sut.registerHandler(for: .info) { [weak self] message in
            guard let self else { return }
            print("INFO: \(message)")
        }
        sut.registerHandler(for: .warning) { [weak self] message in
            guard let self else { return }
            print("WARNING: \(message)")
        }
        sut.registerHandler(for: .error) { [weak self] message in
            guard let self else { return }
            print("ERROR: \(message)")
        }
    }
    
    func print(_ message: String) {
        printedMessages.append(message)
    }
    
    func WHEN_logMessages() {
        sut.log("Infomational Message", level: .info)
        sut.log("Warning message", level: .warning)
        sut.log("We have an error", level: .error)
    }
    
    func THEN_itShouldPrintMessagesToConsole() {
        #expect(printedMessages == ["INFO: Infomational Message", "WARNING: Warning message", "ERROR: We have an error"])
    }
}
