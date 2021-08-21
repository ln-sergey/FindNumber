//
//  Game.swift
//  FindNumber
//
//  Created by Sergey Lobanov on 20.08.2021.
//

import Foundation

enum StatusGame {
    case start
    case win
    case lose
}

class Game {
    
    struct Item {
        var title: String
        var isFound = false
        var isError = false
    }
    
    var status: StatusGame = .start {
        didSet {
            if status != .start {
                stopGame()
            }
        }
    }
    
    private let data = Array(1...99)
    
    var items: [Item] = []
    
    private var countItems: Int
    
    private var timeForGame: Int
    
    private var secondsForGame: Int {
        didSet {
            if secondsForGame <= 0 {
                status = .lose
            }
            self.updateTimer(status, secondsForGame)
        }
    }
    
    private var timer: Timer?
    
    private var updateTimer: (StatusGame, Int) -> Void
    
    var nextItem: Item?
    
    init(countItems: Int, time: Int, updateTimer: @escaping (_ status: StatusGame, _ seconds: Int) -> Void) {
        self.countItems = countItems
        self.timeForGame = time
        self.secondsForGame = time
        self.updateTimer = updateTimer
        setupGame()
    }
    
    func newGame() {
        status = .start
        self.secondsForGame = timeForGame
        setupGame()
    }
    
    private func setupGame() {
        items = []
        var digits = data.shuffled()
        
        while items.count < countItems {
            items.append(Item(title: String(digits.removeFirst())))
        }
        
        nextItem = items.shuffled().first
        
        updateTimer(status, secondsForGame)
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [weak self] (_) in
            self?.secondsForGame -= 1
        })
    }
    
    func check(index: Int) {
        guard status == .start else {
            return
        }
        if (items[index].title == nextItem?.title) {
            items[index].isFound = true
            nextItem = items.shuffled().first(where: {(item) -> Bool in !item.isFound})
        } else {
            items[index].isError = true
        }
        
        if nextItem == nil {
            status = .win
        }
    }
    
    private func stopGame() {
        timer?.invalidate()
    }
}

extension Int {
    func secondsToString() -> String {
        let mins = self / 60
        let secs = self % 60
        return String(format: "%d:%02d", mins, secs)
    }
}
