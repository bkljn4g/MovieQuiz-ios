//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Anka on 11.03.2023.
//

import Foundation

protocol QuestionFactoryDelegate: AnyObject {
    func didReceiveNextQuestion(question: QuizQuestion?)
}
