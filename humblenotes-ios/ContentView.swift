//
//  ContentView.swift
//  humblenotes-ios
//
//  Created by Frank Chiarulli Jr. on 8/29/20.
//  Copyright © 2020 Left Shift Logical, LLC. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        Webview(url: URL(string: "https://github.com")!)
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
