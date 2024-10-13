//
//  WorkoutWidgetBundle.swift
//  WorkoutWidget
//
//  Created by Monessha Vetrivelan on 13/10/2024.
//

import WidgetKit
import SwiftUI


struct WorkoutWidgetBundle: WidgetBundle {
    @WidgetBundleBuilder
    var body: some Widget {
        WorkoutWidget()
    }
}

