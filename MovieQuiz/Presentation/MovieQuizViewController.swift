import UIKit


final class MovieQuizViewController: UIViewController {
    /// MARK: - Lifecycle


    ///добавляем переменные отображения элементов
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet private var yesButton: UIButton!
    @IBOutlet private var noButton: UIButton!
    
    ///общее кол-во вопросов для квиза
    private let questionsAmount: Int = 10
    ///фабрика вопросов. Контроллер будет обращаться за вопросами сюда
    private let questionFactory: QuestionFactoryProtocol = QuestionFactory()
    ///текущий вопрос, который видит пользователь
    private var currentQuestion: QuizQuestion?
    ///переменная индекс текущего вопроса
    private var currentQuestionIndex: Int = 0
    ///переменная индекс количества правильных ответов
    private var correctAnswers: Int = 0

    
    ///функция переопределения. Добавляем константу вью модели
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //показ первого экрана
        if let firstQuestion = questionFactory.requestNextQuestion() {
            currentQuestion = firstQuestion
            let viewModel = convert(model: firstQuestion)
            show(quiz: viewModel)
        }
    }
    
    
    ///в этой функции заполняем картинку, текст и счетчик данными
    private func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
        yesButton.isEnabled = true
        noButton.isEnabled = true
    }
    

    ///делаем рамку картинки красной или зеленой в зависимости от ответа
    private func showAnswerResult(isCorrect: Bool) {
        yesButton.isEnabled = false
        noButton.isEnabled = false
        if isCorrect {
            correctAnswers += 1
        }
        
        imageView.layer.masksToBounds = true /// отрисовка рамки
        imageView.layer.borderWidth = 8 /// толщина рамки
        imageView.layer.cornerRadius = 20
        imageView.layer.borderColor = isCorrect ? UIColor.green.cgColor : UIColor.red.cgColor ///проверка Да или Нет
        
        ///запуск задачи через 1 секунду
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            self.yesButton.isEnabled = true
            self.noButton.isEnabled = true
            self.showNextQuestionOrResults()
            self.imageView.layer.borderWidth = 0 ///после перехода на следующий вопрос убираем рамку
        }
    }
    
    
    ///функция конвертации
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(
            image: UIImage(named: model.image) ?? UIImage(), ///распаковка картинки
            question: model.text, ///берется текст вопроса
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
    }
    
    ///показываем вопрос, или результаты всего квиза
    private func showNextQuestionOrResults() {
        if currentQuestionIndex == questionsAmount - 1 {
            let text = correctAnswers == questionsAmount ?
            "Поздравляем, Вы ответили на 10 из 10!" : "Вы ответили на \(correctAnswers) из 10, попробуйте еще раз!"
            let viewModel = QuizResultsViewModel(
                title: "Этот раунд окончен!",
                text: text,
                buttonText: "Сыграть ещё раз")
            show(quiz: viewModel)
        } else {
            currentQuestionIndex += 1
            if let nextQuestions = questionFactory.requestNextQuestion() {
                currentQuestion = nextQuestions
                let viewModel = convert(model: nextQuestions)
                
                show(quiz: viewModel)
            }
        }
    }
    
    
    ///в этой функции показываем результат прохождения квиза
    private func show(quiz result: QuizResultsViewModel) {
        let alert = UIAlertController(
            title: result.title,
            message: result.text,
            preferredStyle: .alert)
        
        let action = UIAlertAction(title: result.buttonText, style: .default) { [weak self]
                _ in guard let self else { return }
                
                self.currentQuestionIndex = 0
                ///сброс счетчика ответов
                self.correctAnswers = 0
                
                ///заново показываю первый вопрос
            if let firstQuestion = self.questionFactory.requestNextQuestion() {
                self.currentQuestion = firstQuestion
                let viewModel = self.convert(model: firstQuestion)
                
                self.show(quiz: viewModel)
                }
            }
        
        alert.addAction(action)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    ///экшн для кнопки Да
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        let givenAnswer = true
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    ///экшн для кнопки Нет
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        let givenAnswer = false
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
}
