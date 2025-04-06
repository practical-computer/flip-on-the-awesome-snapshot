# frozen_string_literal: true

if Rails.env.local?
  original_on_lookup = I18n::Debug.on_lookup
  I18n::Debug.on_lookup do |key, value|
    next if key.start_with?("en.faker")
    original_on_lookup.call(key, value)
  end
end
