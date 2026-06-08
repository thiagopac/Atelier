//
//  ProductCardView.swift
//  Atelier
//
//  Created by Thiago Pires on 07/06/26.
//

import SwiftUI

struct ProductCardView: View {
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
                            .padding(20)
                    case .failure:
                        Image(systemName: "photo")
                            .font(.system(size: 32))
                            .foregroundStyle(Color.gray.opacity(0.35))
                    default:
                        ProgressView()
                            .tint(.gray)
                    }
                }
            }
            .frame(width: 180, height: 210)

            VStack(alignment: .leading, spacing: 5) {
                Text(product.title)
                    .font(.system(size: 11))
                    .foregroundStyle(Color.atelierSecondary)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)

                Text("$\(String(format: "%.2f", product.price))")
                    .font(.system(size: 15, weight: .bold))
                    .foregroundStyle(.white)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 14)
            .padding(.vertical, 14)
            .frame(maxWidth: .infinity, minHeight: 80, alignment: .topLeading)
        }
        .frame(width: 180)
        .background(Color.atelierSurface)
    }
}
