import SwiftUI

struct ShareResults: View {
    let quizTitle: String
    let correctCount: Double
    let totalCount: Double
    var body: some View {
        VStack {
            ZStack {
                RoundedRectangle(cornerRadius: 30)
                    .fill(.white)
                    .frame(width: 200 * 1.618, height: 200)
                RoundedRectangle(cornerRadius: 30)
                    .fill(
                        LinearGradient(
                            colors: [
                                .brown.opacity(0.2), .brown.opacity(0.3), .brown.opacity(0.4),
                                .brown.opacity(0.5), .brown.opacity(0.6), .brown.opacity(0.7),
                                .brown.opacity(0.8), .brown.opacity(0.9), .brown.opacity(1), .brown,
                            ], startPoint: .topLeading, endPoint: .bottomTrailing)
                    )
                    .frame(width: 200 * 1.618, height: 200)
                    .overlay {
                        HStack {
                            VStack {
                                HStack {
                                    Text("\(Int(correctCount / totalCount * 100))%")
                                        .font(.largeTitle)
                                        .bold()
                                    Spacer()
                                }
                                HStack {
                                    Text(quizTitle)
                                        .foregroundStyle(.secondary)
                                    Spacer()
                                }
                            }
                            Divider()
                            VStack {
                                HStack {
                                    VStack {
                                        HStack {
                                            Text("Correct")
                                                .foregroundStyle(.secondary)
                                                .font(.caption)
                                            Spacer()
                                        }
                                        HStack {
                                            Text(String(Int(correctCount)))
                                            //.multilineTextAlignment(.leading)
                                            Spacer()
                                        }
                                    }
                                    Spacer()
                                }
                                Divider()
                                HStack {
                                    Text("Total Questions")
                                        .foregroundStyle(.secondary)
                                        .font(.caption)
                                    Spacer()
                                }
                                HStack {
                                    Text(String(Int(totalCount)))
                                    //.multilineTextAlignment(.leading)
                                    Spacer()
                                }
                            }
                        }
                        .foregroundStyle(.white)
                        .padding()
                    }
                //.padding()

            }
            .padding([.leading, .trailing, .top])

            Label {
                Text("Download Recap Today!")
                    .font(.caption)
                    .bold()
                    .foregroundStyle(.secondary)
            } icon: {
                Image(uiImage: #imageLiteral(resourceName: "RecapTransparent"))

                    .resizable()
                    .frame(width: 20, height: 20)
                    .clipShape(RoundedRectangle(cornerRadius: 6))
            }
            .padding([.leading, .trailing, .bottom], 4)

        }
        .background(
            LinearGradient(
                colors: [
                    .blue.opacity(0.2), .blue.opacity(0.3), .blue.opacity(0.4), .blue.opacity(0.5),
                    .blue.opacity(0.6), .blue.opacity(0.7), .blue.opacity(0.8), .blue.opacity(0.9),
                    .blue.opacity(1), .blue,
                ], startPoint: .topLeading, endPoint: .bottomTrailing))

    }
}

#Preview {
    ShareResults(quizTitle: "Spanish Quiz", correctCount: 5, totalCount: 10)
}
