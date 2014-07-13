class UserError < StandardError
  def initialize(msg = "UserError: user input is incorrect")
    super
  end
end