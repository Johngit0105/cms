Rails.configuration.middleware.use RailsWarden::Manager do |manager|
  manager.default_strategies :password

  manager.failure_app = lambda { |env|
    SessionsController.action(:new).call(env)
  }
end

# Setup Session Serialization
class Warden::SessionSerializer
  def serialize(account)
    account.id
  end

  def deserialize(id)
    account = Account.find_by_id(id)
    return unless account

    request = Rack::Request.new(env)

    if account.sites.map(&:host).include? request.host
      return account
    else
      return nil
    end
  end
end

# Strategies
Warden::Strategies.add(:password) do
  def authenticate!
    email = params['account']['email']
    password = params['account']['password']

    account = Account.find_and_authenticate(email, password, request.host)

    if account
      success! account
    else
      fail! 'sessions.new.flash.invalid_login'
    end
  end
end
