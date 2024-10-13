//
//  QuoteWidgetBundle.swift
//  QuoteWidget
//
//  Created by Rami Khalil on 13/10/2024.
//

import WidgetKit
import SwiftUI

@main
struct QuoteWidgetBundle: WidgetBundle {
    var body: some Widget {
        QuoteWidget()
        QuoteWidgetControl()
        QuoteWidgetLiveActivity()
    }
}
