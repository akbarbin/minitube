require 'bcrypt'

class User < ApplicationRecord
  attr_accessor :password, :password_confirmation
  # encrypt password
  # users.password_hash in the database is a :string
  include BCrypt

  def password
    @password ||= Password.new(password_hash)
  end

  def password=(new_password)
    @password = Password.create(new_password)
    self.password_hash = @password
  end

  # model associations
  has_many :todos, dependent: :destroy

  # Validations
  validates_presence_of :name, :email, :password_hash
end
