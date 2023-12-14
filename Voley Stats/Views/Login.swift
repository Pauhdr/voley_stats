import SwiftUI
import FirebaseAuth

struct Login: View {
    @ObservedObject var viewModel: LoginModel
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var body: some View {
        VStack{
//            Text("player.new".trad()).font(.title)
            VStack{
                Section{
                    VStack{
                        VStack(alignment: .leading){
                            Text("email".trad()).font(.caption)
                            TextField("email".trad(), text: $viewModel.email).textFieldStyle(TextFieldDark()).border(viewModel.errorCode == .emailError ? .red : .clear)
                            if viewModel.errorCode == .emailError{
                                Text(viewModel.errorMsg!).font(.caption).foregroundStyle(.red)
                            }
                        }.padding(.bottom).padding(.horizontal)
                        if !viewModel.login{
                            VStack(alignment: .leading){
                                Text("username".trad()).font(.caption)
                                TextField("username".trad(), text: $viewModel.userName).textFieldStyle(TextFieldDark())
                            }.padding(.bottom).padding(.horizontal)
                        }
                        VStack(alignment: .leading){
                            Text("password".trad()).font(.caption)
                            ZStack{
                                if viewModel.secured {
                                    SecureField("password".trad(), text: $viewModel.password).textFieldStyle(TextFieldDark()).border(viewModel.errorCode == .passwordError ? .red : .clear)
                                }else{
                                    TextField("password".trad(), text: $viewModel.password).textFieldStyle(TextFieldDark()).border(viewModel.errorCode == .passwordError ? .red : .clear)
                                }
                                Image(systemName: viewModel.secured ? "eye.slash" : "eye").padding().frame(maxWidth: .infinity, alignment: .trailing).onTapGesture{
                                    viewModel.secured.toggle()
                                }
                            }
                            if viewModel.errorCode == .passwordError{
                                Text(viewModel.errorMsg!).font(.caption).foregroundStyle(.red)
                            }
                        }.padding(.horizontal)
                        if !viewModel.login {
                            VStack(alignment: .leading){
                                Text("verify.password".trad()).font(.caption)
                                ZStack{
                                    if viewModel.securedRepeat {
                                        SecureField("verify.password".trad(), text: $viewModel.passwordRepeat).textFieldStyle(TextFieldDark()).border(viewModel.password != viewModel.passwordRepeat ? .red : .clear)
                                    }else{
                                        TextField("verify.password".trad(), text: $viewModel.passwordRepeat).textFieldStyle(TextFieldDark()).border(viewModel.password != viewModel.passwordRepeat ? .red : .clear)
                                    }
                                    Image(systemName: viewModel.securedRepeat ? "eye.slash" : "eye").padding().frame(maxWidth: .infinity, alignment: .trailing).onTapGesture{
                                        viewModel.securedRepeat.toggle()
                                    }
                                }
                                if viewModel.password != viewModel.passwordRepeat{
                                    Text("password.match".trad()).font(.caption).foregroundStyle(.red)
                                }
                            }.padding(.top).padding(.horizontal)
                        }
                        
                    }.padding().background(.white.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 8))
                }
                Button(action:{
                    viewModel.saving.toggle()
                    if viewModel.login{
                        Auth.auth().signIn(withEmail: viewModel.email, password: viewModel.password){ res, err in
                            if err != nil {
                                let errorCode = AuthErrorCode(_nsError: err! as NSError).code
                                viewModel.checkError(code: errorCode)
                            }
                            if res != nil {
                                
                                self.presentationMode.wrappedValue.dismiss()
                            }
                        }
                    }else{
                        if viewModel.password == viewModel.passwordRepeat{
                            Auth.auth().createUser(withEmail: viewModel.email, password: viewModel.password){ res, err in
                                if err != nil {
                                    let errorCode = AuthErrorCode(_nsError: err! as NSError).code
                                    viewModel.checkError(code: errorCode)
                                }
                                if res != nil {
                                    let changereq = Auth.auth().currentUser?.createProfileChangeRequest()
                                    changereq?.displayName = viewModel.userName
                                    changereq?.commitChanges{error in
                                        if error != nil{
                                            let errorCode = AuthErrorCode(_nsError: err! as NSError).code
                                            viewModel.checkError(code: errorCode)
                                        }else {
                                            self.presentationMode.wrappedValue.dismiss()
                                        }
                                    }
                                    
                                }
                            }
                        }else{
                            viewModel.errorCode = .matchError
                            viewModel.errorMsg = "password.match".trad()
                        }
                    }
                }){
                    if viewModel.saving{
                        ProgressView().progressViewStyle(CircularProgressViewStyle()).tint(.cyan).frame(maxWidth: .infinity, alignment: .center)
                    }else{
                        Text(viewModel.login ? "login".trad() : "sign.up".trad()).frame(maxWidth: .infinity, alignment: .center)
                    }
                }.disabled(!viewModel.verify()).padding().background(.white.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 8)).foregroundColor(!viewModel.verify() ? .gray : .cyan)
                
            }
            .padding()
            .frame(maxHeight: .infinity, alignment: .top)
            
        
        }.background(Color.swatch.dark.high)
            .navigationTitle(viewModel.login ? "login".trad() : "sign.up".trad()).foregroundColor(.white)
    }
}

class LoginModel: ObservableObject{
    @Published var password: String = ""
    @Published var passwordRepeat: String = ""
    @Published var email: String = ""
    @Published var errorCode : UserForm?
    @Published var errorMsg : String?
    @Published var secured: Bool = true
    @Published var securedRepeat: Bool = true
    @Published var userName: String = ""
    @Published var saving: Bool = false
    var login:Bool
    init(login:Bool){
        self.login = login
    }
    func verify() -> Bool {
        if login{
            return !password.isEmpty && !email.isEmpty
        }else{
            return !password.isEmpty && !email.isEmpty && password == passwordRepeat
        }
    }
    func checkError(code: AuthErrorCode.Code){
        switch code {
        case AuthErrorCode.emailAlreadyInUse:
            self.errorCode = .emailError
            self.errorMsg = "email.in.use".trad()
        case AuthErrorCode.wrongPassword:
            self.errorCode = .passwordError
            self.errorMsg = "wrong.password".trad()
        case AuthErrorCode.invalidEmail:
            self.errorCode = .emailError
            self.errorMsg = "email.format".trad()
        default:
            self.errorCode = .unknownError
            self.errorMsg = "unknown.error".trad()
        }
    }
}

enum UserForm {
    case passwordError
    case emailError
    case matchError
    case unknownError
}


