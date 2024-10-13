//
//  AppIntent.swift
//  QuoteWidget
//
//  Created by Rami Khalil on 13/10/2024.
//

import WidgetKit
import AppIntents

struct ConfigurationAppIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource { "Select Mood" }
    static var description: IntentDescription { "Choose your mood to generate an inspirational quote." }

    @Parameter(title: "Mood", default: "happiness")
    var mood: String
}
