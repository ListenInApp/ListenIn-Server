require_relative 'accounts'
require_relative 'messages'

class App
  def verifyAccount(params, &action)
    user = User.where(username: params[:username]).first
    if User.exists?(username: params[:username]) && user.password == params[:password]
      action.call user
    else
      {:status => "Error", :message => "Incorrect username or password"}.to_json
    end
  end

  get '/' do
    "ListenIn API Version 1.0"
  end
end
