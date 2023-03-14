//
//  StatisticServiceProtocol.swift
//  MovieQuiz
//
//  Created by Anka on 14.03.2023.
//

import Foundation

protocol StatisticService {
    var totalAccuracy: Double { get }
    var bestGame: GameRecord { get }
    var gamesCount : Int { get }
    
    func store(correct count: Int, total amount: Int)
}
