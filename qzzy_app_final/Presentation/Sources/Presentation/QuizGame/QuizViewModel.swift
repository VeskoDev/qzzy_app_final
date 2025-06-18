//
//  QuizViewModel.swift
//  Presentation
//
//  Created by Veselin Lazarevic on 16. 6. 2025..
//


import Foundation
import Combine
import Domain


public class QuizViewModel: ObservableObject {
  
  private let fetchQuestionsUseCase: FetchQuestionsUseCase
  private let checkAnswerUseCase: CheckAnswerUseCase
  
  @Published public var questions: [QuestionUIModel] = []
  @Published public var isLoading: Bool = false
  @Published public var errorMessage: String?
  @Published public var currentQuestionIndex: Int = 0
  
  private var cancellables = Set<AnyCancellable>()
  
  public init(
    fetchQuestionsUseCase: FetchQuestionsUseCase,
    checkAnswerUseCase: CheckAnswerUseCase
  ) {
    self.fetchQuestionsUseCase = fetchQuestionsUseCase
    self.checkAnswerUseCase = checkAnswerUseCase
  }
  
  
  public var totalQuestions: Int {
    questions.count
  }
  
  public var answeredCount: Int {
    questions.filter { $0.status != .unanswered }.count
  }
  
  public var correctCount: Int {
    questions.filter { $0.status == .correct }.count
  }
  
  public var incorrectCount: Int {
    questions.filter { $0.status == .incorrect }.count
  }
  
  public var isAnswered: Bool {
    let hasResponse = correctCount > 0 || incorrectCount > 0
    return answeredCount > 0 && hasResponse
  }
  
  public var displayScoreText: String {
    isAnswered
    ? "\(correctCount)/\(incorrectCount)"
    : "\(answeredCount)/\(totalQuestions)"
  }
  
  public var correctRatio: CGFloat {
    let total = CGFloat(correctCount + incorrectCount)
    return total == 0 ? 0 : CGFloat(correctCount) / total
  }
  
  public var incorrectRatio: CGFloat {
    let total = CGFloat(correctCount + incorrectCount)
    return total == 0 ? 0 : CGFloat(incorrectCount) / total
  }
  
  public func loadQuestions() {
    isLoading = true
    errorMessage = nil
    
    fetchQuestionsUseCase.execute()
      .receive(on: DispatchQueue.main)
      .sink(receiveCompletion: { [weak self] completion in
        self?.isLoading = false
        if case let .failure(error) = completion {
          self?.errorMessage = error.localizedDescription
        }
      }, receiveValue: { [weak self] questions in
        self?.questions = questions.map { QuestionUIModel(question: $0) }
        self?.currentQuestionIndex = 0
      })
      .store(in: &cancellables)
  }
  
  public func selectAnswer(for questionId: Int, answerId: Int) {
    guard let index = questions.firstIndex(where: { $0.id == questionId }) else {
      return
    }
    
    questions[index].selectedAnswerId = answerId
    questions[index].status = .answered
    
    checkAnswerUseCase.execute(questionId: questionId, answerId: answerId)
      .receive(on: DispatchQueue.main)
      .sink(receiveCompletion: { _ in },
            receiveValue: { [weak self] isCorrect in
        guard let self = self else { return }
        self.questions[index].status = isCorrect ? .correct : .incorrect
      })
      .store(in: &cancellables)
  }
  
  
}
