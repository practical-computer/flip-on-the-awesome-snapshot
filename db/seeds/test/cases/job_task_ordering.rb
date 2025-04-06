# frozen_string_literal: true

ordered_organization = organizations.create(:ordered_organization, name: "Ordered")
owner = users.buffy
ordered_organization.memberships.create!(user: owner, state: :active, membership_type: :organization_manager)

job = organization_jobs.create_labeled(:active_a,
                                       name: "Job A",
                                       organization: ordered_organization,
                                       status: :active,
                                       original_creator: owner
)

def create_task_for_ordering(seed_label, status:, task_type:, label:)
  organization_job_tasks.create_labeled(seed_label,
                                        status: status,
                                        task_type: task_type,
                                        label: label,
                                        job: organization_jobs.active_a,
                                        original_creator: users.buffy
  )
end

create_task_for_ordering(:todo_onsite_a,
                         status: :todo,
                         task_type: :onsite,
                         label: "Task A"
)

create_task_for_ordering(:done_onsite_b,
                         status: :done,
                         task_type: :onsite,
                         label: "Task B"
)

create_task_for_ordering(:cancelled_onsite_c,
                         status: :cancelled,
                         task_type: :onsite,
                         label: "Task C"
)

create_task_for_ordering(:todo_offsite_d,
                         status: :todo,
                         task_type: :offsite,
                         label: "Task D"
)

create_task_for_ordering(:done_offsite_e,
                         status: :done,
                         task_type: :offsite,
                         label: "Task E"
)

create_task_for_ordering(:cancelled_offsite_f,
                         status: :cancelled,
                         task_type: :offsite,
                         label: "Task F"
)