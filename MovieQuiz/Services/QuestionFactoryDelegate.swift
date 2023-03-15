//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Anka on 11.03.2023.
//

import UIKit

protocol QuestionFactoryDelegate: AnyObject {
    func didReceiveNextQuestion(question: QuizQuestion?)
    func didLoadDataFromServer()
    func didFailToLoadData(with error: Error)
}
