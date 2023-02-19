# frozen_string_literal: true

# Base application model
class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
end
