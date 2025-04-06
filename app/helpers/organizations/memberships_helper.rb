# frozen_string_literal: true

module Organizations::MembershipsHelper
  def membership_type_options
    [
      PracticalFramework::Forms::CollectionOption.new(
        value: "staff",
        title: t('membership_types.staff.human'),
        description: t('membership_types.staff.description'),
        icon: membership_type_icon(membership_type: :staff)
      ),
      PracticalFramework::Forms::CollectionOption.new(
        value: "organization_manager",
        title: t('membership_types.organization_manager.human'),
        description: t('membership_types.organization_manager.description'),
        icon: membership_type_icon(membership_type: :organization_manager)
      ),
    ]
  end

  def v2_membership_type_options
    [
      PracticalFramework::Forms::CollectionOption.new(
        value: "staff",
        title: t('membership_types.staff.human'),
        description: t('membership_types.staff.description'),
        icon: icon_set.membership_type_icon(membership_type: :staff)
      ),
      PracticalFramework::Forms::CollectionOption.new(
        value: "organization_manager",
        title: t('membership_types.organization_manager.human'),
        description: t('membership_types.organization_manager.description'),
        icon: icon_set.membership_type_icon(membership_type: :organization_manager)
      ),
    ]
  end
end
