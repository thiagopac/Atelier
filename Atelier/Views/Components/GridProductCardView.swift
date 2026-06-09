//
//  GridProductCardView.swift
//  Atelier
//
//  Created by Thiago Pires on 09/06/26.
//

import SwiftUI

struct GridProductCardView: View {
    let product: Product

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ZStack {
                Color(red: 0.97, green: 0.96, blue: 0.94)

                AsyncImage(url: URL(string: product.image)) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .padding(16)
                    case .failure:
                        Image(systemName: "photo")
                            .font(.system(size: 24))
                            .foregroundStyle(.gray.opacity(0.4))
                    default:
                        ProgressView()
                            .tint(.gray)
                    }
                }
            }
            .aspectRatio(1, contentMode: .fit)

            VStack(alignment: .leading, spacing: 4) {
                Text(product.title)
                    .font(.system(size: 11))
                    .foregroundStyle(Color.atelierSecondary)
                    .lineLimit(2)

                Text("$\(String(format: "%.2f", product.price))")
                    .font(.system(size: 13, weight: .bold))
                    .foregroundStyle(.white)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 12)
            .frame(maxWidth: .infinity, alignment: .leading)
            .frame(minHeight: 68, alignment: .topLeading)
            .background(Color.atelierSurface)
        }
    }
}
