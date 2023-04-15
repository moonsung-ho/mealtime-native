//
//  MealListView.swift
//  mealtime
//
//  Created by 문성호 on 2022/08/27.
//

import SwiftUI

struct MealListView: View {
    let meal: Meal
    var body: some View {
        Text("\(meal.menu[0])")
    }
}

struct MealListView_Previews: PreviewProvider {
    static var meal = Meal.sampleMeal[0]
    static var previews: some View {
        MealListView(meal: meal)
    }
}
