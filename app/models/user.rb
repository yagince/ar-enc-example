class User < ApplicationRecord
  encrypts :address, deterministic: { fixed: false }, previous: { deterministic: false }
end
