import SwiftUI
import PhotosUI

struct ProfileView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: ProfileViewModel
    
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var uiImage: UIImage? = nil
    
    init(userId: Int) {
        _viewModel = StateObject(wrappedValue: ProfileViewModel(userId: userId))
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            headerBackground
            
            ScrollView {
                VStack(alignment: .center, spacing: 20) {
                    profileImage
                    userInfoSection
                    actionButton
                    detailInfoSection
                }
                .padding(.top, 20)
            }
        }
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.fetchUserProfile()
        }
    }
}

private extension ProfileView {
    var headerBackground: some View {
        LinearGradient(
            gradient: Gradient(colors: [Color.pink.opacity(0.8), Color.orange.opacity(0.8)]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .edgesIgnoringSafeArea(.all)
        .frame(height: 250)
    }
    
    var profileImage: some View {
        Group {
            if let uiImage = uiImage {
                Image(uiImage: uiImage).resizable()
            } else {
                AsyncImage(url: URL(string: viewModel.user?.image ?? "")) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                    case .success(let image):
                        image.resizable()
                    case .failure:
                        Image(systemName: "person.circle.fill").resizable()
                    @unknown default:
                        EmptyView()
                    }
                }
            }
        }
        .aspectRatio(contentMode: .fill)
        .frame(width: 150, height: 150)
        .clipShape(Circle())
        .overlay(Circle().stroke(Color.white, lineWidth: 6))
        .shadow(radius: 10)
        .padding(.top, 100)
    }
    
    var userInfoSection: some View {
        VStack(spacing: 8) {
            Text("\((viewModel.user?.firstName ?? "") + " " + (viewModel.user?.lastName ?? ""))")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.black)
            
            Text("\((viewModel.user?.address?.city ?? "")), \((viewModel.user?.address?.country ?? ""))")
                .font(.subheadline)
                .foregroundColor(.gray)
            
            Text("\((viewModel.user?.company?.title ?? "") + " - " + (viewModel.user?.university ?? ""))")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(.horizontal)
    }
    
    var actionButton: some View {
        Button(action: {}) {
            Text("Show more")
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [Color.pink.opacity(0.8), Color.purple.opacity(0.8)]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .cornerRadius(12)
        }
        .padding(.horizontal, 40)
    }
    
    var detailInfoSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            DetailRow(label: "Age", value: "\(viewModel.user?.age ?? 0)")
            DetailRow(label: "Gender", value: viewModel.user?.gender ?? "")
            DetailRow(label: "Email", value: viewModel.user?.email ?? "")
            DetailRow(label: "Phone", value: viewModel.user?.phone ?? "")
            DetailRow(label: "Birth Date", value: viewModel.user?.birthDate ?? "")
            DetailRow(label: "Blood Group", value: viewModel.user?.bloodGroup ?? "")
            DetailRow(label: "Height", value: String(format: "%.2f cm", viewModel.user?.height ?? 0.0))
            DetailRow(label: "Weight", value: String(format: "%.2f kg", viewModel.user?.weight ?? 0.0))
            DetailRow(label: "Eye Color", value: viewModel.user?.eyeColor ?? "")
            DetailRow(label: "Hair Color", value: viewModel.user?.hair?.color ?? "")
            DetailRow(label: "Hair Type", value: viewModel.user?.hair?.type ?? "")
            DetailRow(label: "IP Address", value: viewModel.user?.ip ?? "")
            DetailRow(label: "MAC Address", value: viewModel.user?.macAddress ?? "")
            DetailRow(label: "University", value: viewModel.user?.university ?? "")
            DetailRow(label: "Company", value: viewModel.user?.company?.name ?? "")
            DetailRow(label: "Company Title", value: viewModel.user?.company?.title ?? "")
            DetailRow(label: "Crypto Coin", value: viewModel.user?.crypto?.coin ?? "")
            DetailRow(label: "Crypto Wallet", value: viewModel.user?.crypto?.wallet ?? "")
            DetailRow(label: "Role", value: viewModel.user?.role ?? "")
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white)
        .cornerRadius(25)
        .padding(.horizontal)
        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 10)
    }
}

struct DetailRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack(alignment: .top) {
            Text(label + ":")
                .fontWeight(.bold)
                .frame(width: 120, alignment: .leading)
            
            Text(value)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.leading)
            
            Spacer()
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ProfileView(userId: 1)
        }
    }
}

