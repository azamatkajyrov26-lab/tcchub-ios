import SwiftUI
import Pow

struct DemoQuestion: Identifiable {
    let id = UUID()
    let prompt: String
    let options: [String]
    let correctIndex: Int
}

private let demoQuestions: [DemoQuestion] = [
    .init(prompt: "Which Incoterm shifts the cost of main carriage to the seller?",
          options: ["EXW", "FOB", "CIF", "DDP"], correctIndex: 2),
    .init(prompt: "What does TEU stand for in container shipping?",
          options: ["Twenty-foot Equivalent Unit", "Total Export Unit",
                    "Transit Entry Unit", "Trans-European Unit"], correctIndex: 0),
    .init(prompt: "Which document is required to clear customs in Kazakhstan?",
          options: ["Bill of lading", "Commercial invoice",
                    "Customs declaration (DT-1)", "Packing list"], correctIndex: 2),
]

struct QuizPlayerView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var index = 0
    @State private var answers: [Int?] = Array(repeating: nil, count: demoQuestions.count)
    @State private var showResults = false

    var body: some View {
        ZStack {
            Theme.Color.background.ignoresSafeArea()
            if showResults {
                results
            } else {
                question
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }

    private var question: some View {
        let q = demoQuestions[index]
        return VStack(alignment: .leading, spacing: Theme.Spacing.l) {
            ProgressView(value: Double(index + 1), total: Double(demoQuestions.count))
                .tint(Theme.Color.primary)
            Text("\(String(localized: "quiz.question")) \(index + 1) / \(demoQuestions.count)")
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(Theme.Color.textLight)
                .textCase(.uppercase)
            Text(q.prompt)
                .font(.system(size: 20, weight: .semibold))
                .foregroundStyle(Theme.Color.navy)

            VStack(spacing: 10) {
                ForEach(Array(q.options.enumerated()), id: \.offset) { i, option in
                    Button {
                        answers[index] = i
                    } label: {
                        HStack {
                            Image(systemName: answers[index] == i
                                  ? "largecircle.fill.circle"
                                  : "circle")
                                .foregroundStyle(answers[index] == i ? Theme.Color.primary : Theme.Color.textLight)
                            Text(option).foregroundStyle(Theme.Color.navy)
                            Spacer()
                        }
                        .padding(Theme.Spacing.m)
                        .background(
                            RoundedRectangle(cornerRadius: Theme.Radius.md)
                                .fill(Theme.Color.card)
                                .overlay(
                                    RoundedRectangle(cornerRadius: Theme.Radius.md)
                                        .stroke(answers[index] == i ? Theme.Color.primary : Theme.Color.divider,
                                                lineWidth: 1.5)
                                )
                        )
                    }
                    .buttonStyle(.plain)
                }
            }

            Spacer()

            PrimaryButton(title: index == demoQuestions.count - 1
                          ? String(localized: "quiz.submit")
                          : String(localized: "quiz.next")) {
                if index == demoQuestions.count - 1 {
                    showResults = true
                } else {
                    withAnimation { index += 1 }
                }
            }
            .disabled(answers[index] == nil)
            .opacity(answers[index] == nil ? 0.5 : 1)
        }
        .padding(Theme.Spacing.l)
    }

    private var correctCount: Int {
        zip(answers, demoQuestions).filter { $0.0 == $0.1.correctIndex }.count
    }

    private var passed: Bool { Double(correctCount) / Double(demoQuestions.count) >= 0.6 }

    @State private var celebrationTrigger = 0

    private var results: some View {
        VStack(spacing: Theme.Spacing.l) {
            Spacer()
            Image(passed ? "success-certificate" : "error-404")
                .resizable().scaledToFit().frame(maxHeight: 220)
                .changeEffect(
                    .spray(origin: UnitPoint(x: 0.5, y: 0.3)) {
                        Group {
                            Image(systemName: "star.fill").foregroundStyle(Theme.Color.primary)
                            Image(systemName: "sparkle").foregroundStyle(Theme.Color.warning)
                            Image(systemName: "rosette").foregroundStyle(Theme.Color.success)
                        }
                    },
                    value: celebrationTrigger
                )
                .onAppear {
                    if passed { celebrationTrigger += 1 }
                }
            Text(passed ? "quiz.passed" : "quiz.failed")
                .font(.system(size: 24, weight: .bold))
                .foregroundStyle(passed ? Theme.Color.success : Theme.Color.error)
            Text("\(String(localized: "quiz.score")): \(correctCount) / \(demoQuestions.count)")
                .font(.system(size: 17))
                .foregroundStyle(Theme.Color.textMid)
            Spacer()
            PrimaryButton(title: String(localized: "quiz.finish")) { dismiss() }
                .padding(.horizontal, Theme.Spacing.l)
            if !passed {
                Button(String(localized: "quiz.tryAgain")) {
                    answers = Array(repeating: nil, count: demoQuestions.count)
                    index = 0
                    showResults = false
                }
                .foregroundStyle(Theme.Color.primary)
                .padding(.bottom, Theme.Spacing.l)
            }
        }
    }
}
