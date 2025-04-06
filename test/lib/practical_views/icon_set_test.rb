# frozen_string_literal: true

require "test_helper"

class PracticalViews::IconSetTest < ActiveSupport::TestCase
  class TestIconSet < PracticalViews::IconSet
    def self.presets
      super.merge(
        duotone: Preset.new(family: "testing", variant: :custom),
        test: Preset.new(family: "new-values", variant: nil)
      )
    end

    define_icons(icon_definitions: [
      IconDefinition.new(method_name: :waffle_icon, icon_name: :waffle, preset: :solid),
    ])
  end

  test "presets can be overridden to change the set of available presets for easy reference" do
    expected = PracticalViews::IconSet.presets.merge(
      duotone: TestIconSet::Preset.new(family: "testing", variant: :custom),
      test: TestIconSet::Preset.new(family: "new-values", variant: nil)
    )

    assert_equal expected, TestIconSet.presets
  end

  test "icon: generates a PracticalViews::IconComponent instance for the given family & name" do
    family = "fa-kit"
    name = "user"

    generated_icon = TestIconSet.icon(name: name, family: family)
    assert_equal family, generated_icon.family
    assert_equal name, generated_icon.name
  end

  test "defines helper methods around icon for each family in the original PracticalViews::IconSet" do
    name = "user"

    solid_icon = TestIconSet.solid_icon(name: name)
    assert_equal :solid, solid_icon.family
    assert_equal name, solid_icon.name
    assert_equal true, solid_icon.fixed_width

    duotone_icon = TestIconSet.duotone_icon(name: name)
    assert_equal "testing", duotone_icon.family
    assert_equal name, duotone_icon.name
    assert_equal true, solid_icon.fixed_width
  end

  test "define_icons: uses metaprogramming to setup the icon definitions from the class definition" do
    family = :solid
    name = :waffle

    result = TestIconSet.waffle_icon

    assert_kind_of PracticalViews::IconComponent, result
    assert_equal family, result.family
    assert_equal name, result.name
  end
end