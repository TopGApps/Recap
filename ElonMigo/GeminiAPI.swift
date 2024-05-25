//
//  GeminiAPI.swift
//  ElonMigo
//
//  Created by Aaron Ma on 5/25/24.
//

import GoogleGenerativeAI
import UIKit

class GeminiAPI {
    static var shared: GeminiAPI?
    
    private var model: GenerativeModel?
    private var chat: Chat?
    private var apiKey: String
    
    @Published var geminiResponse = ""
    
    private init(model: GenerativeModel? = nil, chat: Chat? = nil, apiKey: String, geminiResponse: String = "") {
        self.model = model
        self.chat = chat
        self.apiKey = apiKey
        self.geminiResponse = geminiResponse
        initGemini()
    }
    
    static func `init`(with apiKey: String) {
        shared = GeminiAPI(apiKey: apiKey)
    }
    
    private func initGemini() {
        let config = GenerationConfig(temperature: 1, topP: 0.95, topK: 64, maxOutputTokens: 8192, responseMIMEType: "application/json")
        
        // TODO: more strict safety
        // https://ai.google.dev/gemini-api/docs/safety-settings
        model = GenerativeModel(name: "gemini-1.5-pro-latest", apiKey: apiKey, generationConfig: config, safetySettings: [SafetySetting(harmCategory: .harassment, threshold: .blockNone), SafetySetting(harmCategory: .hateSpeech, threshold: .blockNone), SafetySetting(harmCategory: .sexuallyExplicit, threshold: .blockNone), SafetySetting(harmCategory: .dangerousContent, threshold: .blockNone)], systemInstruction: "You are my teacher. Determine the subject of the notes and provide a json with possible questions relating to the notes BASED ON THE EXAMPLE JSON I GIVE YOU. You may be asked to provide an explanation for a question or be asked to generate an entire quiz (more likely). For Multiple choice questions, you can mark as many answers as true, but if all answers are true and you decide to use \"all of the above\", PLEASE MAKE THE OTHER ANSWERS FALSE. Also, make sure to use the exact same property names, but just change the contents/values of each property based on the notes provided. Also make sure that all the information is true and taken purely from the notes.")
        
        if let model = model {
            chat = model.startChat(history: [])
        }
    }
    
    func sendMessage(userInput: String, selectedPhotosData: [Data]?, streamContent: Bool, generateQuiz: Bool, completion: @escaping (String) -> Void) {
        guard let chat = chat else { return }
        
        let quizPrompt: String = {
            if generateQuiz {
                return String("\n\nUse this JSON schema to generate the questions:\n\n{\n  \"quiz_title\": \"Sample Quiz\",\n  \"questions\": [\n    {\n      \"type\": \"multiple_choice\",\n      \"question\": \"What is the capital of France?\",\n      \"options\": [\n        {\"text\": \"Paris\", \"correct\": true},\n        {\"text\": \"London\",  \"correct\": false},\n        {\"text\": \"Berlin\", \"correct\": false},\n        {\"text\": \"Rome\", \"correct\": false}\n      ]\n    },\n    {\n      \"type\": \"multiple_choice\",\n      \"question\": \"What is the largest planet in our solar system?\",\n      \"options\": [\n        {\"text\": \"Earth\", \"correct\": false},\n        {\"text\": \"Saturn\", \"correct\": false},\n        {\"text\": \"Jupiter\", \"correct\": true},\n        {\"text\": \"Uranus\", \"correct\": false}\n      ]\n    },\n    {\n      \"type\": \"free_answer\",\n      \"question\": \"What is the meaning of life?\",\n      \"answer\": \"\" // user input will be stored here\n    },\n    {\n      \"type\": \"multiple_choice\",\n      \"question\": \"Which of the following is not a primary color?\",\n      \"options\": [\n        {\"text\": \"Red\", \"correct\": false},\n        {\"text\": \"Blue\", \"correct\": false},\n        {\"text\": \"Yellow\", \"correct\": false},\n        {\"text\": \"Green\", \"correct\": true}\n      ]\n    },\n    {\n      \"type\": \"free_answer\",\n      \"question\": \"Describe the concept of artificial intelligence.\",\n      \"answer\": \"\" // user input will be stored here\n    }\n  ]\n}\n")
            }
            
            return "Please follow the example JSON EXACTLY"
        }()
        
        if streamContent {
            Task {
                do {
                    if let imagesData = selectedPhotosData {
                        let response = try await chat.sendMessageStream("Notes: ", userInput, imagesData.compactMap { data in UIImage(data: data) })
                        
                        print("Gemini Interaction Log:")
                        
                        for try await chunk in response {
                            if let text = chunk.text {
                                self.geminiResponse += text
                            }
                            
                            DispatchQueue.main.async {
                                completion(self.geminiResponse)
                            }
                        }
                    } else {
                        let response = chat.sendMessageStream("Notes: ", userInput, quizPrompt)
                        
                        print("Gemini Interaction Log:")
                        
                        for try await chunk in response {
                            if let text = chunk.text {
                                self.geminiResponse += text
                            }
                            
                            DispatchQueue.main.async {
                                completion(self.geminiResponse)
                            }
                        }
                    }
                } catch {
                    print(error)
                    
                    DispatchQueue.main.async {
                        completion("Error: \(error)")
                    }
                }
            }
        } else {
            Task {
                do {
                    if let imagesData = selectedPhotosData {
                        let response = try await chat.sendMessage("Notes: ", userInput, imagesData.compactMap { data in UIImage(data: data) })
                        
                        print("Gemini Interaction Log:")
                        
                        DispatchQueue.main.async {
                            self.geminiResponse = response.text ?? "No response received"
                            completion(self.geminiResponse)
                        }
                    } else {
                        let response = try await chat.sendMessage("Notes: ", userInput, quizPrompt)
                        
                        print("Gemini Interaction Log:")
                        
                        DispatchQueue.main.async {
                            self.geminiResponse = response.text ?? "No response received"
                            completion(self.geminiResponse)
                        }
                    }
                } catch {
                    print(error)
                    
                    DispatchQueue.main.async {
                        completion("Error: \(error)")
                    }
                }
            }
        }
    }
}
