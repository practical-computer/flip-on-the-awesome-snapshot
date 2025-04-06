# frozen_string_literal: true

organization = organizations.create(:koepp_inc,
                                    unique_by: :name,
                                    name: "Koepp Inc",
                                    timezone: "Eastern Time (US & Canada)"
                                  )

lorene = users.create_labeled(:lorene, email: "lorene@example.com", name: "Lorene Mckee")
lucinda = users.create_labeled(:lucinda, email: "lucinda@example.com", name: "Lucinda Pineda")
lowell = users.create_labeled(:lowell, email: "lowell@example.com", name: "Lowell Booker")
desiree = users.create_labeled(:desiree, email: "desiree@example.com", name: "Desiree Faulkner")

lorene.memberships.find_or_create_by!(organization: organization, membership_type: :organization_manager, state: :active)
lucinda.memberships.find_or_create_by!(organization: organization, membership_type: :organization_manager, state: :active)
lowell.memberships.find_or_create_by!(organization: organization, membership_type: :staff, state: :active)
desiree.memberships.find_or_create_by!(organization: organization, membership_type: :staff, state: :active)
