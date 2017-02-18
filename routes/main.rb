require_relative 'accounts'
require_relative 'messages'

class App
  def verifyAccount(params, &action)
    user = User.where(username: params[:username]).first
    if not user.nil? && user.password == params[:password]
      action.call user
    else
      {:status => "Error", :message => "Incorrect username or password"}
    end
  end

  get '/' do
    "ListenIn API Version 1.0"
  end
end
