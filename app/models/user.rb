class User < ApplicationRecord
    attr_encrypted :genius_token, key: ENV['DB_SECRET']
end
