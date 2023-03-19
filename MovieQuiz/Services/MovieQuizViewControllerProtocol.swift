//
//  MovieQuizViewControllerProtocol.swift
//  MovieQuiz
//
//  Created by Anka on 17.03.2023.
//

import Foundation

protocol MovieQuizViewControllerProtocol: AnyObject {
    func show(quiz step: QuizStepViewModel)
    func highLightImageBorder(isCorrect: Bool)
    func hideLoadingIndicator()
    func showNetworkError(message: String)
    func switchButtons(isEnabled: Bool)
}
