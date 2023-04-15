//
//  test.swift
//  mealtime
//
//  Created by 문성호 on 2022/08/27.
//

import Foundation

struct Meal {
    var date: Date
    var menu: [String]
}

extension Meal {
    static let sampleMeal: [Meal] =
    [
        Meal(date: Date(), menu: ["발아현미밥", "우동전골", "건파래멸치볶음", "생선가스", "깍두기", "타르타르소스", "오트요거트"])
    ]
}
