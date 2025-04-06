# frozen_string_literal: true

class Organization::Onsite::TableComponent < ApplicationComponent
  attr_accessor :onsites

  def initialize(onsites:)
    @onsites = onsites
  end
end
