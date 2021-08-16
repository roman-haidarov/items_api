class TokensCreator
  def initialize(user)
    @payload = {
      user_id: user.id,
      email: user.email,
      username: user.name,
      salt: generate_salt
    }
  end

  def call
    JWT.encode @payload, nil, 'none'
  end

  def generate_salt
    values_arr = [ '1', '2', 'a', 'z', 'A', 'Z' ]
    salt = ''

    10.times do
      salt += values_arr.sample
    end

    salt
  end
end