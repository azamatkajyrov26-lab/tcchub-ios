import SwiftUI

struct DemoCertificate: Identifiable {
    let id = UUID()
    let courseTitle: String
    let issuedOn: String
}

private let demoCertificates: [DemoCertificate] = [
    .init(courseTitle: "Logistics from Scratch", issuedOn: "2026-03-12"),
    .init(courseTitle: "Customs & Compliance",   issuedOn: "2026-02-04"),
]

struct CertificateGalleryView: View {
    var body: some View {
        ScrollView {
            if demoCertificates.isEmpty {
                EmptyState(image: "success-certificate",
                           title: "certificate.empty",
                           subtitle: "certificate.emptyHint")
                    .frame(minHeight: 400)
            } else {
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: Theme.Spacing.m) {
                    ForEach(demoCertificates) { cert in
                        NavigationLink { CertificateDetailView(certificate: cert) } label: {
                            CertificateCard(certificate: cert)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(Theme.Spacing.m)
            }
        }
        .background(Theme.Color.background)
        .navigationTitle("certificate.title")
        .navigationBarTitleDisplayMode(.inline)
    }
}

private struct CertificateCard: View {
    let certificate: DemoCertificate

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ZStack {
                LinearGradient(colors: [Theme.Color.navy, Theme.Color.primary],
                               startPoint: .topLeading, endPoint: .bottomTrailing)
                Image(systemName: "rosette")
                    .font(.system(size: 36))
                    .foregroundStyle(.white.opacity(0.95))
            }
            .frame(height: 110)
            .clipShape(RoundedRectangle(cornerRadius: Theme.Radius.md))

            Text(certificate.courseTitle)
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(Theme.Color.navy)
                .lineLimit(2)
            Text(certificate.issuedOn)
                .font(.system(size: 11))
                .foregroundStyle(Theme.Color.textLight)
        }
        .padding(Theme.Spacing.s)
        .background(
            RoundedRectangle(cornerRadius: Theme.Radius.card)
                .fill(Theme.Color.card)
                .shadow(color: Theme.Color.navy.opacity(0.05), radius: 6, y: 2)
        )
    }
}

struct CertificateDetailView: View {
    let certificate: DemoCertificate

    var body: some View {
        ScrollView {
            VStack(spacing: Theme.Spacing.l) {
                Image("certificate-template")
                    .resizable()
                    .scaledToFit()
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: Theme.Radius.card))
                    .shadow(color: Theme.Color.navy.opacity(0.1), radius: 8, y: 4)
                    .padding(.horizontal, Theme.Spacing.m)

                VStack(spacing: 4) {
                    Text(certificate.courseTitle)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundStyle(Theme.Color.navy)
                    HStack(spacing: 4) {
                        Text("certificate.issuedOn")
                        Text(certificate.issuedOn)
                    }
                    .font(.system(size: 13))
                    .foregroundStyle(Theme.Color.textMid)
                }

                HStack(spacing: Theme.Spacing.m) {
                    ShareLink(item: certificate.courseTitle) {
                        Label("certificate.share", systemImage: "square.and.arrow.up")
                            .frame(maxWidth: .infinity, minHeight: 48)
                            .background(Theme.Color.surfaceAlt)
                            .clipShape(RoundedRectangle(cornerRadius: Theme.Radius.pill))
                            .foregroundStyle(Theme.Color.navy)
                    }
                    Button {
                        // TODO: PDF download
                    } label: {
                        Label("certificate.download", systemImage: "arrow.down.circle")
                            .frame(maxWidth: .infinity, minHeight: 48)
                            .background(Theme.Color.primary)
                            .clipShape(RoundedRectangle(cornerRadius: Theme.Radius.pill))
                            .foregroundStyle(.white)
                    }
                }
                .padding(.horizontal, Theme.Spacing.m)
            }
            .padding(.vertical, Theme.Spacing.l)
        }
        .background(Theme.Color.background)
        .navigationTitle("certificate.title")
        .navigationBarTitleDisplayMode(.inline)
    }
}
