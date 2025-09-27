//
//  ServerManager.swift
//  TVTuneDetective
//
//  Created by Kenneth Riendeau on 9/26/25.
//
import SwiftUI

typealias ConnectionID = UUID

protocol ServerManaging: AnyObject {
  var onEvent: ((ClientEvent) -> Void)? { get set }
  var onConnect: ((ConnectionID) -> Void)? { get set }
  var onDisconnect: ((ConnectionID) -> Void)? { get set }

  func startServing(staticAssets: WebAssetsDescriptor, port: UInt16) throws
  func stopServing()

  func send(to connection: ConnectionID, _ message: HostMessage)
  func broadcast(_ message: HostMessage)
}

protocol Transport { /* internal to ServerManager impl */ }

struct WebAssetsDescriptor {
    let rootFolder: URL
    
    init(rootFolder: URL) {
        self.rootFolder = rootFolder
    }
}
