//
//  Created by Tapash Majumder on 6/17/20.
//  Copyright © 2020 Iterable. All rights reserved.
//

import Foundation

@testable import IterableSDK

@objc(ReactE2E)
class ReactE2E: RCTEventEmitter {
    @objc(sendCommand:)
    func sendCommand(command: String) {
        ITBInfo("sendCommand: \(command)")
        execute(command: Command.parse(str: command))
        
    }
    
    override var methodQueue: DispatchQueue! {
        _methodQueue
    }
    
    @objc override static func requiresMainQueueSetup() -> Bool {
        false
    }

    enum EventName: String, CaseIterable {
        case handleUrlCalled
        case handleCustomActionCalled
        case handleInAppCalled
    }

    override func supportedEvents() -> [String]! {
        var result = [String]()
        EventName.allCases.forEach {
            result.append($0.rawValue)
        }
        return result
    }
    
    override func startObserving() {
        ITBInfo()
        shouldEmit = true
    }
    
    override func stopObserving() {
        ITBInfo()
        shouldEmit = false
    }
    
    enum Command: String {
        case initialize
        case unknown
        
        static func parse(str: String) -> Command {
            return Command(rawValue: str.lowercased()) ?? .unknown
        }
    }

    // MARK: Private
    private var shouldEmit = false
    private let _methodQueue = DispatchQueue(label: String(describing: ReactE2E.self))
    
    private func execute(command: Command) {
        switch command {
        case .initialize:
            IterableAPISupport.sharedInstance.sendInApp(toEmail: IterableAPI.email!, withCampaignId: 1157554)
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                _ = IterableAPI.internalImplementation?.inAppManager.scheduleSync()
            }
            break
        default:
            ITBError("unknown command")
        }
    }

}
