//
//  TimerService.swift
//  TVTuneDetective
//
//  Created by Kenneth Riendeau on 9/26/25.
//
//import SwiftUI
import Foundation

protocol TimerServing {
  func startCountdown(seconds: Int, tick: @MainActor @escaping (Int)->Void, completion: @MainActor @escaping ()->Void)
  func cancel()
}
