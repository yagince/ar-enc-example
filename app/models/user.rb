class User < ApplicationRecord
  encrypts :name
  encrypts :address, deterministic: true
end
