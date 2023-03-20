# frozen_string_literal: true

# Identities represent how a User was able to authenticate
class Identity < ApplicationRecord
  belongs_to :user
end
