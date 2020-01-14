//
//  ContentView.swift
//  capit
//
//  Created by yk on 1/13/20.
//  Copyright © 2020 Thoams Yang. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State var redraw = false
    var body: some View {
    LinkPreviewView(url: "https://medium.com/flawless-app-stories/context-menu-alert-and-actionsheet-in-swiftui-b6ff0d1f8493", redraw: $redraw)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .frame(height: 100)
            .previewLayout(.sizeThatFits)
    }
}
