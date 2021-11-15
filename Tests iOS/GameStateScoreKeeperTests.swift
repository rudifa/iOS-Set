//
//  GameStateScoreKeeperTests.swift
//  SetTests
//
//  Created by Rudolf Farkas on 26.10.21.
//

import XCTest

class GameStateScoreKeeperTests: XCTestCase {
    override func setUpWithError() throws {}

    override func tearDownWithError() throws {}

    func test_GameState_ScoreKeeper() throws {
        do {
            let scoreKeeper = GameState.ScoreKeeper()
            XCTAssertEqual(scoreKeeper.score, 0)
            XCTAssertEqual(scoreKeeper.elapsedSecondsThisRound, 0)
            XCTAssertEqual(scoreKeeper.maxBounty, 30)
            XCTAssertEqual(scoreKeeper.bounty, 30)
            XCTAssertEqual(scoreKeeper.bountyDouble, 30)
        }
        do {
            // after one minute the bounty falls to ~ 2/3 of maxBounty
            var scoreKeeper = GameState.ScoreKeeper()
            for _ in 0 ..< 60 { scoreKeeper.oneSecondTick() }
            XCTAssertEqual(scoreKeeper.score, 0)
            XCTAssertEqual(scoreKeeper.elapsedSecondsThisRound, 60)
            XCTAssertEqual(scoreKeeper.bounty, 22)
        }
        do {
            var scoreKeeper = GameState.ScoreKeeper()
            scoreKeeper.update(.deal)
            XCTAssertEqual(scoreKeeper.score, -10)
            do {
                var scoreKeeper = GameState.ScoreKeeper()
                scoreKeeper.update(.cheat)
                XCTAssertEqual(scoreKeeper.score, -30)
            }
            do {
                var scoreKeeper = GameState.ScoreKeeper()
                scoreKeeper.update(.match)
                XCTAssertEqual(scoreKeeper.score, 30)
            }
            do {
                var scoreKeeper = GameState.ScoreKeeper()
                scoreKeeper.update(.nomatch)
                XCTAssertEqual(scoreKeeper.score, -10)
            }
        }
    }
}
