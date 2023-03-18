import UIKit


final class MovieQuizViewController: UIViewController, MovieQuizViewControllerProtocol {
    

    // MARK: - @IBOutlet
    
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet private var yesButton: UIButton!
    @IBOutlet private var noButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    private var presenter: MovieQuizPresenter!
    private var alertPresenter: AlertPresenter?
    private var statisticService: StatisticService?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        activityIndicator.hidesWhenStopped = true
        presenter = MovieQuizPresenter(viewController: self, alertPresenter: AlertPresenter(viewController: self))
        alertPresenter = AlertPresenter(viewController: self)
        //showLoadingIndicator() // заменила на hidesWhenStopped
        imageView.layer.cornerRadius = 20
    }
    
    /*
    func showLoadingIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    */
    
    func hideLoadingIndicator() {
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
    }

    
    func show(quiz step: QuizStepViewModel) {
        imageView.layer.cornerRadius = 20
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
        imageView.layer.borderWidth = 0
        
    }
    
    
    func showNetworkError(message: String) {
        let model = AlertModel(
            title: "Ошибка",
            message: message,
            buttonText: "Попробовать ещё раз") { [weak self] in
                guard let self = self else { return }
                
                self.presenter.restartGame()
            }
        
        alertPresenter?.showAlert(model: model)
    }

    
    func switchButtons(isEnabled: Bool) {
        yesButton.isEnabled = isEnabled
        noButton.isEnabled = isEnabled
    }
    
    
    func highLightImageBorder(isCorrect: Bool) {
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        drawBorder(color: isCorrect ? UIColor.green.cgColor : UIColor.red.cgColor)
    }
    
    
    private func drawBorder(color: CGColor) {
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = color
    }
    

    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        presenter.yesButtonClicked()
    }
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        presenter.noButtonClicked()
    }
}
