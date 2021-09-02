class TokensCleaner
  include Interactor

  def call
    Token.where("expired_in < ?", Time.current).each do |token|
      token.destroy
    end
  end
end