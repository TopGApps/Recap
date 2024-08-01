//
//  APIKey.swift
//  Recap
//
//  Created by Aaron Ma on 7/25/24.
//

import SwiftUI

struct APIKey: View {
    @State private var aiPlatform = ""
    
    @AppStorage("ready") var ready: Bool = UserPreferences.shared.ready
    @AppStorage("preferredModel") var preferredModel: String = UserPreferences.shared.preferredModel
    
    @AppStorage("apiKey") var key: String = UserPreferences.shared.apiKey
    @AppStorage("chatGPTAPIKey") var chatGPTAPIKey: String = UserPreferences.shared.chatGPTAPIKey
    
    var body: some View {
        VStack {
            if aiPlatform.isEmpty {
                Text("Choose an AI platform:")
                
                HStack {
                    Button {
                        withAnimation {
                            aiPlatform = "G"
                        }
                    } label: {
                        HStack {
                            Spacer()
                            Text("Gemini")
                            Spacer()
                        }
                    }
                    .padding(.vertical)
                    .foregroundStyle(.white)
                    .background(Color.accentColor)
                    .clipShape(RoundedRectangle(cornerRadius: 22))
                    .padding(.horizontal)
                    .sensoryFeedback(.success, trigger: aiPlatform)
                    
                    Button {
                        withAnimation {
                            aiPlatform = "C"
                        }
                    } label: {
                        HStack {
                            Spacer()
                            Text("ChatGPT")
                            Spacer()
                        }
                    }
                    .padding(.vertical)
                    .foregroundStyle(.white)
                    .background(Color.accentColor)
                    .clipShape(RoundedRectangle(cornerRadius: 22))
                    .padding(.horizontal)
                    .sensoryFeedback(.success, trigger: aiPlatform)
                }
            } else if aiPlatform == "G" {
                VStack {
                    HStack {
                        Button {
                            withAnimation {
                                aiPlatform = ""
                            }
                        } label: {
                            Image(systemName: "arrow.backward")
                        }
                        .sensoryFeedback(.success, trigger: aiPlatform)
                        
                        Text("Gemini")
                            .bold()
                    }
                    
                    SecureField("Top Secret Gemini API Key", text: $key)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                    
                    Button {
                        withAnimation {
                            preferredModel = "Gemini"
                            ready = true
                        }
                    } label: {
                        HStack {
                            Spacer()
                            Text("Done")
                            Spacer()
                        }
                    }
                    .padding(.vertical)
                    .foregroundStyle(.white)
                    .background(Color.accentColor)
                    .clipShape(RoundedRectangle(cornerRadius: 22))
                    .padding(.horizontal)
                    .sensoryFeedback(.success, trigger: ready)
                    .disabled(key.isEmpty)
                }
            } else {
                VStack {
                    HStack {
                        Button {
                            withAnimation {
                                aiPlatform = ""
                            }
                        } label: {
                            Image(systemName: "arrow.backward")
                        }
                        .sensoryFeedback(.success, trigger: aiPlatform)
                        
                        Text("ChatGPT")
                            .bold()
                    }
                    
                    SecureField("Top Secret ChatGPT API Key", text: $chatGPTAPIKey)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                    
                    Button {
                        withAnimation {
                            preferredModel = "ChatGPT"
                            ready = true
                        }
                    } label: {
                        HStack {
                            Spacer()
                            Text("Done")
                            Spacer()
                        }
                    }
                    .padding(.vertical)
                    .foregroundStyle(.white)
                    .background(Color.accentColor)
                    .clipShape(RoundedRectangle(cornerRadius: 22))
                    .padding(.horizontal)
                    .sensoryFeedback(.success, trigger: ready)
                    .disabled(chatGPTAPIKey.isEmpty)
                }
            }
        }
    }
}

#Preview {
    APIKey()
}
