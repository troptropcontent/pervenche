class Service < ApplicationRecord
  encrypts :username
  encrypts :password
end
