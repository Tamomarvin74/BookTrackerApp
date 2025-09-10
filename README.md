# 📚 BookTrackerApp  

BookTrackerApp is a SwiftUI iOS application that allows users to **register, log in, view posts, create posts, and interact with comments**.  
It demonstrates a full-stack flow with authentication, data fetching, and UI updates using **MVVM architecture** and async/await networking in Swift.  

---

## 🚀 Features  

### 🔐 Authentication  
- **Login** with username & password.  
- **Registration form** to create a new user directly in the login screen.  
- Secure session management with `AuthManager`.  
- Sign out functionality.  

### 📝 Posts  
- Fetch posts from a remote API (`https://dummyjson.com/posts`).  
- Create a new post with title, body, and userId.  
- Posts are automatically assigned a random image.  
- Each post displays:  
  - Title  
  - Body  
  - Image  
  - Reactions (likes, dislikes)  

### 💬 Comments  
- Fetch comments for a specific post.  
- Display comment text, author name, and avatar.  

### 👤 Profile  
- Profile view to display user details.  

---

## 🛠️ Tech Stack  
- **SwiftUI** for UI components.  
- **MVVM (Model-View-ViewModel)** architecture.  
- **Async/Await** for networking calls.  
- **URLSession** for API requests.  
- **Git + GitHub** for version control.  


