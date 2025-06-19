//
//  Gemini.swift
//  Gym-app-ioss
//
//  Created by Daniel Pinilla on 5/13/24.
//

import Foundation

import GoogleGenerativeAI


enum APIKey {
  /// Retrieve the API key from an environment variable.
  /// Set `GENERATIVEAI_API_KEY` in your environment at runtime.
  static var `default`: String {
    if let key = ProcessInfo.processInfo.environment["GENERATIVEAI_API_KEY"], !key.isEmpty {
      return key
    }
    fatalError("Environment variable 'GENERATIVEAI_API_KEY' not set.")
  }
}
