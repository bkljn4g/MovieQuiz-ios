//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Anka on 17.03.2023.
//

import UIKit


final class MovieQuizPresenter: QuestionFactoryDelegate {
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
            return
        }
        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.hideLoadingIndicator()
            self?.viewController?.show(quiz: viewModel)
            self?.viewController?.switchButtons(isEnabled: true)
        }
    }
    
    
    private weak var viewController: MovieQuizViewControllerProtocol?
    private var questionFactory: QuestionFactoryProtocol?
    private var statisticService: StatisticService?
    private var currentQuestion: QuizQuestion?
    private var alertPresenter: AlertPresenter?
    
    init(viewController: MovieQuizViewControllerProtocol, alertPresenter: AlertPresenter) {
            self.viewController = viewController
            self.alertPresenter = alertPresenter
            statisticService = StatisticServiceImplementation()
            questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
            questionFactory?.loadData()
            //viewController.showLoadingIndicator()
        }
    
    
        private let questionsAmount: Int = 10
        private var currentQuestionIndex: Int = 0
        private var correctAnswers: Int = 0
        
        // MARK: - QuestionFactoryDelegate
        func didLoadDataFromServer() {
            viewController?.hideLoadingIndicator()
            questionFactory?.requestNextQuestion()
        }
        
        func didFailToLoadData(with error: Error) {
            viewController?.showNetworkError(message: error.localizedDescription)
        }
        
        
        func yesButtonClicked() {
            didAnswer(isYes: true)
        }
    
    
        func noButtonClicked() {
            didAnswer(isYes: false)
        }
        
    
        private func didAnswer(isCorrect: Bool) {
            if isCorrect {
                correctAnswers += 1
            }
        }
        
    
        private func didAnswer(isYes: Bool) {
            guard let currentQuestion = currentQuestion else {
                return
            }
            
            let givenAnswer = isYes
            
            showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
        }
        
    
        private func isLastQuestion() -> Bool {
            currentQuestionIndex == questionsAmount - 1
        }
        
        
        func switchToNextQuestion() {
            currentQuestionIndex += 1
        }
    
    
        func restartGame() {
            currentQuestionIndex = 0
            correctAnswers = 0
            questionFactory?.requestNextQuestion()
        }
        
    
        func convert(model: QuizQuestion) -> QuizStepViewModel {
            QuizStepViewModel(
                image: UIImage(data: model.image) ?? UIImage(),
                question: model.text,
                questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
        }
        
        private func showNextQuestionOrResults() {
            if isLastQuestion() {
                guard let statisticService = statisticService else { return }
                statisticService.store(correct: correctAnswers, total: questionsAmount)
                let totalAccuracyPercentage = (String(format: "%.2f", statisticService.totalAccuracy) + "%")
                let bestGameDate = statisticService.bestGame.date.dateTimeString
                let totalGamesCount = statisticService.gamesCount
                let currentCorrectRecord = statisticService.bestGame.correct
                let currentTotalRecord = statisticService.bestGame.total
                let text = """
                               Ваш результат: \(correctAnswers)/\(questionsAmount)
                               Количество сыгранных квизов: \(totalGamesCount)
                               Рекорд: \(currentCorrectRecord)/\(currentTotalRecord) (\(bestGameDate))
                               Средняя точность: \(totalAccuracyPercentage)
                               """
                
                let viewModel = AlertModel(
                    title: "Этот раунд окончен!",
                    message: text,
                    buttonText: "Сыграть еще раз",
                    completion: { [weak self] in
                        guard let self = self else {return}
                        self.restartGame()
                        print("end")
                    })
                alertPresenter?.showAlert(model: viewModel)
            } else {
                //viewController?.showLoadingIndicator()
                self.switchToNextQuestion()
                questionFactory?.requestNextQuestion()
            }
        }
        
        private func showAnswerResult(isCorrect: Bool) {
            didAnswer(isCorrect: isCorrect)
            self.viewController?.switchButtons(isEnabled: false)
            viewController?.highLightImageBorder(isCorrect: isCorrect)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
                guard let self = self else { return }
                self.showNextQuestionOrResults()
            }
        }
    }
