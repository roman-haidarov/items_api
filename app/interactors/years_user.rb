class YearsUser
  def initialize(user)
    born_years = user.born_years
    @years = DateTime.now.year - born_years
  end

  def calculate
    @years
  end
end