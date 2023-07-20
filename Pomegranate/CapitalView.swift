//
//  CapitalView.swift
//  Pomegranate
//
//  Created by Etienne Martin on 2023-07-20.
//

import SwiftUI

struct CapitalView: View {
    let capital: Capital
    
    var body: some View {
        VStack {
            if let flag = Flags.unicodeFlag(countryName: capital.country) {
                Text(flag)
                    .font(.system(size: 150))
                    .accessibilityIdentifier("CapitalView.Flag")
            }
            Text(capital.name)
                .font(.largeTitle)
                .bold()
                .accessibilityIdentifier("CapitalView.Name")
            Text(capital.country)
                .font(.title)
                .accessibilityIdentifier("CapitalView.Country")
            VStack(alignment: .leading) {
                Text("Population: \(capital.population)")
                    .padding(.top)
                    .accessibilityIdentifier("CapitalView.Population")
                Text("Percentage of Country's pop: \(String(format: "%.2f", capital.countryPercentage))%")
                    .accessibilityIdentifier("CapitalView.Percentage")
            }
            .accessibilityElement(children: .contain)
            .accessibilityIdentifier("CapitalView.PopulationStack")
        }
        .accessibilityElement(children: .contain)
        .accessibilityIdentifier("CapitalView")
    }
}

struct CapitalView_Previews: PreviewProvider {
    static var previews: some View {
        CapitalView(capital: Capital.all.first!)
    }
}

