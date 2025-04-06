# frozen_string_literal: true

ordered_organization = organizations.create(:ordered_organization, name: "Ordered")
owner = users.buffy
ordered_organization.memberships.create!(user: owner, state: :active, membership_type: :organization_manager)

organization_jobs.create_labeled(:active_a,
                                 name: "Job A",
                                 organization: ordered_organization,
                                 status: :active,
                                 original_creator: owner
)

organization_jobs.create_labeled(:archived_b,
                                 name: "Job B",
                                 organization: ordered_organization,
                                 status: :archived,
                                 original_creator: owner
)

organization_jobs.create_labeled(:active_c,
                                 name: "Job C",
                                 organization: ordered_organization,
                                 status: :active,
                                 original_creator: owner
)

organization_jobs.create_labeled(:archived_d,
                                 name: "Job D",
                                 organization: ordered_organization,
                                 status: :archived,
                                 original_creator: owner
)