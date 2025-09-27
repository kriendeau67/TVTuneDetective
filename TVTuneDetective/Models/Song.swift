//
//  Song.swift
//  TVTuneDetective
//
//  Created by Kenneth Riendeau on 9/26/25.
//
//import SwiftUI
import Foundation

struct Song: Codable, Equatable, Identifiable {
  let id: String          // Apple Music ID or ISRC
  let title: String
  let artist: String
  let duration: Double    // seconds
  let artworkURL: URL?
  let previewURL: URL?
}
