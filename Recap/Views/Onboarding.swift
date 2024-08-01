//
//  Onboarding.swift
//  Recap
//
//  Created by Aaron Ma on 7/25/24.
//
// https://github.com/aaronhma/HackerNews/blob/master/HackerNews/Views/Onboarding.swift

import SwiftUI

struct OnboardingItem: View {
    var title: String
    var description: String
    var icon: String
    var color: Color
    var style: Color = .white
    
    @State private var userTapped = false
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .resizable()
                .scaledToFit()
                .frame(width: 20, height: 20)
                .padding()
                .background(color)
                .foregroundStyle(style)
                .frame(width: 30, height: 30)
                .clipShape(RoundedRectangle(cornerRadius: 32))
            
            VStack(alignment: .leading) {
                Text(title)
                    .bold()
                    .foregroundStyle(.black.opacity(0.9))
                
                Text(description)
                    .foregroundStyle(.gray)
            }
            
            Spacer()
        }
        .padding(.leading)
        .padding(.vertical)
        .frame(maxWidth: .infinity)
        .background(.white.opacity(0.6))
        .clipShape(RoundedRectangle(cornerRadius: 22))
        .padding(.horizontal)
        .symbolEffect(.bounce, value: userTapped)
        .sensoryFeedback(.impact, trigger: userTapped)
        .onTapGesture {
            userTapped.toggle()
        }
    }
}

struct OnboardingPage1: View {
    @State private var animate = false
    
    @AppStorage("showOnboarding") private var showOnboarding = AppSettings.showOnboarding
    
    @Binding var termsAgreed: Bool
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.green, .red]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
            
            GeometryReader { geometry in
                VStack {
                    Spacer()
                    
                    Image(uiImage: Bundle.main.icon ?? UIImage())
                        .resizable()
                        .frame(width: 150, height: 150)
                        .clipShape(RoundedRectangle(cornerRadius: 32))
                        .shadow(color: .accentColor, radius: 5)
                        .offset(x: animate ? 0 : geometry.size.width - 64, y: animate ? 0 : geometry.size.height - 64)
                        .animation(.easeInOut(duration: 1.5), value: animate)
                    
                    Text("Recap")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .offset(y: animate ? 0 : 20)
                        .opacity(animate ? 1 : 0)
                        .foregroundStyle(.white)
                        .animation(.easeInOut(duration: 1.5), value: animate)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    
                    Text("AI-powered learning that's personalized for you.")
                        .multilineTextAlignment(.center)
                        .font(.headline)
                        .foregroundStyle(.white)
                        .fontWeight(.bold)
                        .offset(y: animate ? 0 : 20)
                        .opacity(animate ? 1 : 0)
                        .animation(.easeInOut(duration: 1.5), value: animate)
                        .padding(.horizontal)
                    
                    Spacer()
                    
                    Button {
                        withAnimation(.easeInOut(duration: 1.0)) {
                            termsAgreed.toggle()
                        }
                    } label: {
                        Text("Continue")
                            .bold()
                            .frame(maxWidth: .infinity)
                    }
                    .padding(.vertical)
                    .foregroundStyle(.white)
                    .background(.blue.opacity(0.6))
                    .clipShape(RoundedRectangle(cornerRadius: 22))
                    .padding(.horizontal)
                    .sensoryFeedback(.success, trigger: termsAgreed)
                }
                .opacity(animate ? 1 : 0)
                .animation(.easeInOut(duration: 1.5), value: animate)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .offset(x: geometry.size.width / 2, y: geometry.size.height / 2)
                .offset(x: animate ? -geometry.size.width / 2 : 0, y: animate ? -geometry.size.height / 2 : 0)
            }
        }
        .onAppear {
            withAnimation {
                animate = true
            }
        }
    }
}

struct OnboardingPage2: View {
    var titles = ["Research-backed active learning", "Attachments", "Privacy", "Summarize videos and articles", "Customizable models", "Every platform supported", "Free & open-source"]
    var descriptions = ["Interactive learning with quizzes", "Add images, YouTube videos, articles, and more!", "We don't collect any of your data", "AI-powered summaries", "Fine-tune models", "Learn on all your devices", "Welcome to the community!"]
    var icons = ["newspaper.fill", "paperclip", "hand.raised.fill", "hand.raised.fill", "slider.vertical.3", "desktopcomputer", "hand.wave.fill"]
    var colors = [Color.orange, .indigo, .pink, .teal, .purple, .black, .green]
    
    @Binding var showOnboarding: Bool
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.green, .red]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
            
            VStack {
                Text("The _best_ way to learn anything...")
                    .multilineTextAlignment(.center)
                    .font(.largeTitle)
                    .foregroundStyle(.white)
                    .bold()
                    .padding(.top, 15)
                
                ScrollView {
                    ForEach((0..<titles.count), id: \.self) { i in
                        OnboardingItem(title: titles[i], description: descriptions[i], icon: icons[i], color: colors[i])
                    }
                }
                
                Spacer()
                
                Button {
                    withAnimation(.easeInOut(duration: 3.0)) {
                        showOnboarding.toggle()
                    }
                } label: {
                    Text("Start learning!")
                        .bold()
                        .frame(maxWidth: .infinity)
                }
                .padding(.vertical)
                .foregroundStyle(.white)
                .background(.blue.opacity(0.6))
                .clipShape(RoundedRectangle(cornerRadius: 22))
                .padding(.horizontal)
                .sensoryFeedback(.success, trigger: showOnboarding)
            }
        }
    }
}

struct Onboarding: View {
    @State private var termsAgreed = false
    
    @Binding var showOnboarding: Bool
    
    var body: some View {
        if termsAgreed {
            OnboardingPage2(showOnboarding: $showOnboarding)
        } else {
            OnboardingPage1(termsAgreed: $termsAgreed)
        }
    }
}

#Preview {
    Onboarding(showOnboarding: .constant(true))
}
