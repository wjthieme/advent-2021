//
//  Main.swift
//  Advent
//
//  Created by Wilhelm Thieme on 30/11/2021.
//

import Cocoa
import Combine

@main
class Main: NSObject, NSApplicationDelegate {

    private var cancellable: AnyCancellable?

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        if unitTesting { return }
        let puzzle = Puzzle.day14b
        cancellable = puzzle.getInput().sink { completion in
            guard case let .failure(error) = completion else { return }
            print(error.localizedDescription)
            exit(EXIT_FAILURE)
        } receiveValue: { input in
            let result = puzzle.solve(input)
            print(result)
            exit(EXIT_SUCCESS)
        }
    }

    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }

    
    private var unitTesting: Bool {
        return ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil
    }

}
