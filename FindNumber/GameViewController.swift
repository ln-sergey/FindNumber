//
//  ViewController.swift
//  FindNumber
//
//  Created by Sergey Lobanov on 19.08.2021.
//

import UIKit

class GameViewController: UIViewController {
    
    @IBOutlet weak var statusLabel: UILabel!
    
    @IBOutlet var buttons: [UIButton]!
    
    @IBOutlet weak var nextDigit: UILabel!
    
    @IBOutlet weak var timerLabel: UILabel!
    
    @IBOutlet weak var newGameButton: UIButton!
    
    lazy var game = Game(countItems: buttons.count, time: 39) { [weak self] (status, time) in
        guard let self = self else { return }
        self.timerLabel.text = time.secondsToString()
        self.updateInfoGame(with: status)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupScreen()
    }
    
    @IBAction func newGame(_ sender: UIButton) {
        game.newGame()
        sender.isHidden = true
        setupScreen()
    }
    
    @IBAction func pressFirstButton(_ sender: UIButton) {
        guard let buttonIndex = buttons.firstIndex(of: sender) else { return }
        game.check(index: buttonIndex)
        
        updateUI()
    }
    
    private func setupScreen() {
        for index in game.items.indices {
            buttons[index].setTitle(game.items[index].title, for: .normal)
            buttons[index].alpha = 1
            buttons[index].isEnabled = true
            buttons[index].layer.cornerRadius = 10
            
        }
        
        nextDigit.text = game.nextItem?.title
    }
    
    private func updateUI() {
        for index in game.items.indices {
            buttons[index].isEnabled = !game.items[index].isFound
            buttons[index].alpha = game.items[index].isFound ? 0 : 1
            if game.items[index].isError {
                UIView.animate(withDuration: 0.3) { [weak self] in
                    self?.buttons[index].backgroundColor = #colorLiteral(red: 0.4392156899, green: 0.01176470611, blue: 0.1921568662, alpha: 1)
                } completion: { [weak self] (_) in
                    self?.buttons[index].backgroundColor = #colorLiteral(red: 0.9787273526, green: 0.7872440484, blue: 1, alpha: 1)
                    self?.game.items[index].isError = false
                }

            }
        }
        
        nextDigit.text = game.nextItem?.title
        
        updateInfoGame(with: game.status)
    }
    
    private func updateInfoGame(with status: StatusGame) {
        switch status {
        case .start:
            statusLabel.text = "Game has started"
            statusLabel.textColor = #colorLiteral(red: 0.9787273526, green: 0.7872440484, blue: 1, alpha: 1)
            newGameButton.isHidden = true
        case .win:
            statusLabel.text = "You Won!"
            statusLabel.textColor = .purple
            newGameButton.isHidden = false
        case .lose:
            statusLabel.text = "You Lost!"
            statusLabel.textColor = #colorLiteral(red: 0.4392156899, green: 0.01176470611, blue: 0.1921568662, alpha: 1)
            newGameButton.isHidden = false
        }
    }
    
}

