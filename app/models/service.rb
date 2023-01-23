class Service < ApplicationRecord
  encrypts :username, :password
end
