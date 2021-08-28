class TokensCreator
  def initialize(user)
    @payload = {
      user_id: user.id,
      email: user.email,
      username: user.name,
      salt: generate_salt,
      expired_in: Time.current + 20.minutes
    }
  end

  def call
    encodet_token = JWT.encode @payload, nil, 'HS256'
    token = Token.create(
      user_id: @payload[:user_id],
      token: encodet_token,
      expired_in: @payload[:expired_in]
    )

    return token
  end

  private

  def generate_salt
    values_arr = [ '1', '2', 'a', 'z', 'A', 'Z' ]
    salt = ''

    10.times do
      salt += values_arr.sample
    end

    salt
  end
end