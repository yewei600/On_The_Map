//
//  GCDBlackBox.swift
//  OnTheMap
//
//  Created by Eric Wei on 2017-03-04.
//  Copyright © 2017 EricWei. All rights reserved.
//

import Foundation

func performUIUpdatesOnMain(_ updates: @escaping () -> Void) {
    DispatchQueue.main.async {
        updates()
    }
}
