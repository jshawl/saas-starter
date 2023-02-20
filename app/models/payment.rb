# frozen_string_literal: true

# Payment Model
class Payment < ApplicationRecord
  belongs_to :user
end
