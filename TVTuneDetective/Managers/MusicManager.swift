//
//  MusicManager.swift
//  TVTuneDetective
//

import Foundation
import MusicKit
import AVFoundation


@MainActor
final class MusicManager: ObservableObject {
    private var previewPlayer: AVPlayer?   // AVPlayer for preview clips only
    private var playedSongIDs: Set<MusicItemID> = []  // 👈 cache of played songs
    // 👇 Replace with your real Apple Music developer token
    private let developerToken = "eyJhbGciOiJFUzI1NiIsInR5cCI6IkpXVCIsImtpZCI6Ijg1RENVQTM3VDUifQ.eyJpYXQiOjE3NTg5Mjg5OTAsImV4cCI6MTc3NDQ4MDk5MCwiaXNzIjoiUzU2UlEzQVJYQyJ9.YCYCv2kkf2BisXssTArMxxUCP4Ns0XcbHGO2ATwroD56JSK6LlogpVeFXpzOSVNDbOdfa7-A9JVeLT_dRHiLaA"
    private var userToken: String?
    
    enum MusicError: LocalizedError {
        case notAuthorized(MusicAuthorization.Status)
        case noResults
        case noPreviewURL
        var errorDescription: String? {
            switch self {
            case .notAuthorized(let s): return "Music authorization failed: \(s)"
            case .noResults: return "No Apple Music results found."
            case .noPreviewURL: return "No preview URL available for this track."
            }
        }
    }
    
    // MARK: - Auth
    
    func authorizeIfNeeded() async throws {
        switch MusicAuthorization.currentStatus {
        case .authorized:
            break
        case .restricted, .denied:
            throw MusicError.notAuthorized(MusicAuthorization.currentStatus)
        case .notDetermined:
            let status = await MusicAuthorization.request()
            guard status == .authorized else {
                throw MusicError.notAuthorized(status)
            }
        @unknown default:
            throw MusicError.notAuthorized(MusicAuthorization.currentStatus)
        }
        print("✅ Music authorization succeeded")
    }
    
    // MARK: - Catalog / Playlists
    
    func fetchRandomCatalogSong(criteria: MusicCriteria) async throws -> MusicKit.Song? {
        try await authorizeIfNeeded()
        
        var parts: [String] = []
        if let kws = criteria.keywords, !kws.isEmpty {
            parts.append(contentsOf: kws)
        } else {
            if let decade = criteria.decade, !decade.isEmpty { parts.append(decade) }
            if let genre  = criteria.genre,  !genre.isEmpty  { parts.append(genre) }
            parts.append("hits")
        }
        let term = parts.joined(separator: " ")
        print("🔎 Catalog search term:", term)
        
        var request = MusicCatalogSearchRequest(
            term: term,
            types: [MusicKit.Song.self] as [any MusicCatalogSearchable.Type]
        )
        request.limit = max(criteria.limit, 25)
        let response = try await request.response()
        
        var songs = Array(response.songs)
        
        if let allowed = criteria.allowedArtistKeywords, !allowed.isEmpty {
            let needles = allowed.map { $0.lowercased() }
            songs = songs.filter { song in
                let artist = song.artistName.lowercased()
                return needles.contains { artist.contains($0) }
            }
            if songs.isEmpty {
                print("⚠️ No matches after artist filter; falling back.")
                songs = Array(response.songs)
            }
        }
        return songs.randomElement()
    }
    
    func fetchRandomSongFromPlaylist(named playlistName: String) async throws -> MusicKit.Song? {
        try await authorizeIfNeeded()
        print("🔎 Searching for playlist:", playlistName)
        
        var request = MusicCatalogSearchRequest(
            term: playlistName,
            types: [MusicKit.Playlist.self] as [any MusicCatalogSearchable.Type]
        )
        request.limit = 1
        let response = try await request.response()
        
        guard let playlist = response.playlists.first else {
            print("❌ Playlist not found:", playlistName)
            return nil
        }
        
        let detailed = try await playlist.with([.tracks])
        guard let tracks = detailed.tracks else { return nil }
        
        let songs: [MusicKit.Song] = tracks.compactMap {
            if case let .song(song) = $0 { return song }
            return nil
        }
        
        guard !songs.isEmpty else { return nil }
        print("✅ Playlist \(playlistName) has \(songs.count) songs")
       // return songs.randomElement()
        let unplayedSongs = songs.filter { !playedSongIDs.contains($0.id) }
        let selectionPool = unplayedSongs.isEmpty ? songs : unplayedSongs
        if let song = selectionPool.randomElement() {
            playedSongIDs.insert(song.id)
            return song
        }
        return nil
    }
    func resetPlayedSongs() { playedSongIDs.removeAll() }
    
    func fetchSong(for criteria: MusicCriteria) async throws -> MusicKit.Song? {
        try await authorizeIfNeeded()
        
        // 👇 Step 1: Handle direct Apple Music playlist ID first
        if let playlistID = criteria.playlistID {
            print("🔎 Loading custom playlist ID: \(playlistID)")
            let request = MusicCatalogResourceRequest<Playlist>(
                matching: \.id, equalTo: MusicItemID(playlistID)
            )
            let response = try await request.response()
            guard let playlist = response.items.first else {
                print("❌ Playlist not found for ID \(playlistID)")
                return nil
            }

            let detailed = try await playlist.with([.tracks])
            guard let tracks = detailed.tracks else {
                print("⚠️ Playlist found but no tracks.")
                return nil
            }

            let songs: [MusicKit.Song] = tracks.compactMap {
                if case let .song(song) = $0 { return song }
                return nil
            }

            guard !songs.isEmpty else {
                print("⚠️ Playlist is empty.")
                return nil
            }
            // Filter out already-played songs
            let unplayedSongs = songs.filter { !playedSongIDs.contains($0.id) }
            let selectionPool = unplayedSongs.isEmpty ? songs : unplayedSongs

            if let song = selectionPool.randomElement() {
                playedSongIDs.insert(song.id)  // 👈 remember it
                print("✅ Playlist → \(song.title) by \(song.artistName)")
                return song
            }
        }

        // 👇 Step 2: Handle single-keyword playlist lookup (legacy support)
        if let kws = criteria.keywords, kws.count == 1 {
            if let playlistSong = try await fetchRandomSongFromPlaylist(named: kws[0]) {
                print("🎶 Playlist [\(kws[0])] → \(playlistSong.title) by \(playlistSong.artistName)")
                return playlistSong
            } else {
                print("⚠️ Playlist fallback triggered")
            }
        }

        // 👇 Step 3: Normal catalog search fallback
        if let catalogSong = try await fetchRandomCatalogSong(criteria: criteria) {
            print("🎶 Catalog → \(catalogSong.title) by \(catalogSong.artistName)")
            return catalogSong
        }

        return nil
    }
    
    // MARK: - Preview playback (AVPlayer, no tvOS banner)
    
    private struct AMPreviewResponse: Decodable { let data: [AMSong] }
    private struct AMSong: Decodable { let attributes: AMSongAttributes? }
    private struct AMSongAttributes: Decodable { let previews: [AMPreview]? }
    private struct AMPreview: Decodable { let url: URL }
    
    func previewURL(for song: MusicKit.Song) async throws -> URL {
        let storefront = Locale.current.regionCode?.lowercased() ?? "us"
        let songID = song.id.rawValue
        guard let url = URL(string: "https://api.music.apple.com/v1/catalog/\(storefront)/songs/\(songID)") else {
            throw MusicError.noPreviewURL
        }
        
        var req = URLRequest(url: url)
        req.httpMethod = "GET"
        req.setValue("Bearer \(developerToken)", forHTTPHeaderField: "Authorization")
        req.setValue("application/json", forHTTPHeaderField: "Accept")
        
        let (data, resp) = try await URLSession.shared.data(for: req)
        guard let http = resp as? HTTPURLResponse, (200..<300).contains(http.statusCode) else {
            throw MusicError.noPreviewURL
        }
        
        let decoded = try JSONDecoder().decode(AMPreviewResponse.self, from: data)
        if let preview = decoded.data.first?.attributes?.previews?.first?.url {
            return preview
        }
        throw MusicError.noPreviewURL
    }
    
    func playPreviewSnippet(_ song: MusicKit.Song, seconds: Double) async throws {
        let url = try await previewURL(for: song)
        
        stopPreview()
        
        let item = AVPlayerItem(url: url)
        let player = AVPlayer(playerItem: item)
        previewPlayer = player
        player.play()
        
        try? await Task.sleep(nanoseconds: UInt64(seconds * 1_000_000_000))
        stopPreview()
    }
    
    func stopPreview() {
        previewPlayer?.pause()
        previewPlayer = nil
    }
}
