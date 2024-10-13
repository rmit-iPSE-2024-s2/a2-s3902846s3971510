//
//  WorkoutWidgetBundle.swift
//  WorkoutWidget
//
//  Created by Monessha Vetrivelan on 13/10/2024.
//

import WidgetKit
import SwiftUI

@main
struct WorkoutWidgetBundle: WidgetBundle {
    var body: some Widget {
        WorkoutWidget()
        WorkoutWidgetLiveActivity()
    }
}
