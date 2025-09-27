// Messages.swift
// TVTuneDetective
//
// Defines the JSON messages exchanged between phone clients and the TV host.

import Foundation

// MARK: - Wire "public" projections (safe to send to clients)

struct PublicPlayer: Codable, Equatable, Hashable {
    let id: UUID
    let name: String
    let score: Int
}

struct PublicBid: Codable, Equatable, Hashable {
    let playerID: UUID
    let seconds: Int
}

struct PublicAnswer: Codable, Equatable, Hashable {
    let title: String
    let artist: String
}

struct PublicScore: Codable, Equatable, Hashable {
    let playerID: UUID
    let name: String
    let score: Int
}

// MARK: - Client -> Host

enum ClientEvent: Codable, Equatable {
    case join(name: String, room: String)
    case bid(seconds: Int)
    case guess(text: String)
    case ping
    case leave

    private enum CodingKeys: String, CodingKey { case type, name, room, seconds, text }
    private enum Kind: String, Codable { case join, bid, guess, ping, leave }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        switch try container.decode(Kind.self, forKey: .type) {
        case .join:
            self = .join(
                name: try container.decode(String.self, forKey: .name),
                room: try container.decode(String.self, forKey: .room)
            )
        case .bid:
            self = .bid(seconds: try container.decode(Int.self, forKey: .seconds))
        case .guess:
            self = .guess(text: try container.decode(String.self, forKey: .text))
        case .ping:
            self = .ping
        case .leave:
            self = .leave
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case let .join(name, room):
            try container.encode(Kind.join, forKey: .type)
            try container.encode(name, forKey: .name)
            try container.encode(room, forKey: .room)
        case let .bid(seconds):
            try container.encode(Kind.bid, forKey: .type)
            try container.encode(seconds, forKey: .seconds)
        case let .guess(text):
            try container.encode(Kind.guess, forKey: .type)
            try container.encode(text, forKey: .text)
        case .ping:
            try container.encode(Kind.ping, forKey: .type)
        case .leave:
            try container.encode(Kind.leave, forKey: .type)
        }
    }
}

// MARK: - Host -> Client

enum HostMessage: Codable, Equatable {
    case lobby(players: [PublicPlayer])
    case bidUpdate(currentLeader: PublicBid?)
    case startPlayback(seconds: Int, offset: Double)
    case requestGuess(playerID: UUID, maxSeconds: Int)
    case result(correct: Bool, answer: PublicAnswer)
    case scoreboard(entries: [PublicScore])
    case error(message: String)
    case pong

    private enum CodingKeys: String, CodingKey {
        case type, players, currentLeader, seconds, offset, playerID, maxSeconds, correct, answer, entries, message
    }
    private enum Kind: String, Codable {
        case lobby, bidUpdate, startPlayback, requestGuess, result, scoreboard, error, pong
    }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        switch try c.decode(Kind.self, forKey: .type) {
        case .lobby:
            self = .lobby(players: try c.decode([PublicPlayer].self, forKey: .players))
        case .bidUpdate:
            self = .bidUpdate(currentLeader: try c.decodeIfPresent(PublicBid.self, forKey: .currentLeader))
        case .startPlayback:
            self = .startPlayback(
                seconds: try c.decode(Int.self, forKey: .seconds),
                offset: try c.decode(Double.self, forKey: .offset)
            )
        case .requestGuess:
            self = .requestGuess(
                playerID: try c.decode(UUID.self, forKey: .playerID),
                maxSeconds: try c.decode(Int.self, forKey: .maxSeconds)
            )
        case .result:
            self = .result(
                correct: try c.decode(Bool.self, forKey: .correct),
                answer: try c.decode(PublicAnswer.self, forKey: .answer)
            )
        case .scoreboard:
            self = .scoreboard(entries: try c.decode([PublicScore].self, forKey: .entries))
        case .error:
            self = .error(message: try c.decode(String.self, forKey: .message))
        case .pong:
            self = .pong
        }
    }

    func encode(to encoder: Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case let .lobby(players):
            try c.encode(Kind.lobby, forKey: .type)
            try c.encode(players, forKey: .players)
        case let .bidUpdate(currentLeader):
            try c.encode(Kind.bidUpdate, forKey: .type)
            try c.encodeIfPresent(currentLeader, forKey: .currentLeader)
        case let .startPlayback(seconds, offset):
            try c.encode(Kind.startPlayback, forKey: .type)
            try c.encode(seconds, forKey: .seconds)
            try c.encode(offset, forKey: .offset)
        case let .requestGuess(playerID, maxSeconds):
            try c.encode(Kind.requestGuess, forKey: .type)
            try c.encode(playerID, forKey: .playerID)
            try c.encode(maxSeconds, forKey: .maxSeconds)
        case let .result(correct, answer):
            try c.encode(Kind.result, forKey: .type)
            try c.encode(correct, forKey: .correct)
            try c.encode(answer, forKey: .answer)
        case let .scoreboard(entries):
            try c.encode(Kind.scoreboard, forKey: .type)
            try c.encode(entries, forKey: .entries)
        case let .error(message):
            try c.encode(Kind.error, forKey: .type)
            try c.encode(message, forKey: .message)
        case .pong:
            try c.encode(Kind.pong, forKey: .type)
        }
    }
}
