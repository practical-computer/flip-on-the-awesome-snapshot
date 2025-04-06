# frozen_string_literal: true

maintenance_agreement_company = Faker::Company.name
maintenance_onsite_label = "Tuneup"
maintenance_onsite_task = "Meter Read"
maintenance_job_task = "Supply Run"
maintenance_offsite_task = "Invoice"

def maintenance_agreement_job_name(company_name:)
  "#{company_name} // #{Faker::Invoice.reference}"
end

def maintenance_agreement_task_label(task:)
  "#{task} // #{Faker::Device.serial}"
end

def maintenance_agreement_onsite_label(onsite:)
  "#{onsite} // #{Faker::Device.platform}"
end

def create_maintenance_agreement_job(label, company_name:, **)
  organization_jobs.create_labeled(label,
                                   name: maintenance_agreement_job_name(company_name: company_name),
                                   organization: organizations.organization_1,
                                   original_creator: users.moonlighter,
                                   **
                                )
end

def create_maintenance_agreement_onsite(label, onsite_label:, job:, **)
  organization_onsites.create_labeled(label,
                                      label: maintenance_agreement_onsite_label(onsite: onsite_label),
                                      job: job,
                                      original_creator: users.moonlighter
                                  )
end

def create_maintenance_agreement_task(label, task_label:, **)
  organization_job_tasks.create_labeled(label,
                                        label: maintenance_agreement_task_label(task: task_label),
                                        organization: organizations.organization_1,
                                        original_creator: users.organization_1_department_head,
                                        **
  )
end

create_maintenance_agreement_job(:maintenance_agreement_job_1,
                                 company_name: maintenance_agreement_company,
                                 status: :archived
                                )

create_maintenance_agreement_onsite(:maintenance_agreement_onsite_1,
                                    onsite_label: maintenance_onsite_label,
                                    job: organization_jobs.maintenance_agreement_job_1
                                  )

create_maintenance_agreement_task(:maintenance_agreement_onsite_task_1,
                                  task_label: maintenance_onsite_task,
                                  onsite: organization_onsites.maintenance_agreement_onsite_1,
                                  job: organization_jobs.maintenance_agreement_job_1,
                                  task_type: :onsite,
                                  status: :cancelled
                                 )

create_maintenance_agreement_task(:maintenance_agreement_job_task_1,
                                  task_label: maintenance_job_task,
                                  job: organization_jobs.maintenance_agreement_job_1,
                                  task_type: :onsite,
                                  status: :done
                                 )

create_maintenance_agreement_task(:maintenance_agreement_offsite_task_1,
                                  task_label: maintenance_job_task,
                                  onsite: nil,
                                  job: organization_jobs.maintenance_agreement_job_1,
                                  task_type: :offsite,
                                  status: :todo
                                 )

create_maintenance_agreement_job(:maintenance_agreement_job_2,
                                 company_name: maintenance_agreement_company,
                                 status: :active
                                )

create_maintenance_agreement_onsite(:maintenance_agreement_onsite_2,
                                    onsite_label: maintenance_onsite_label,
                                    job: organization_jobs.maintenance_agreement_job_2
                                  )

create_maintenance_agreement_task(:maintenance_agreement_onsite_task_2,
                                  task_label: maintenance_onsite_task,
                                  onsite: organization_onsites.maintenance_agreement_onsite_2,
                                  job: organization_jobs.maintenance_agreement_job_2,
                                  task_type: :onsite,
                                  status: :cancelled
                                 )

create_maintenance_agreement_task(:maintenance_agreement_job_task_2,
                                  task_label: maintenance_job_task,
                                  job: organization_jobs.maintenance_agreement_job_2,
                                  task_type: :onsite,
                                  status: :done
                                 )

create_maintenance_agreement_task(:maintenance_agreement_offsite_task_2,
                                  task_label: maintenance_job_task,
                                  onsite: nil,
                                  job: organization_jobs.maintenance_agreement_job_2,
                                  task_type: :offsite,
                                  status: :todo
                                 )

create_maintenance_agreement_job(:maintenance_agreement_job_3,
                                 company_name: maintenance_agreement_company,
                                 status: :active
                                )

create_maintenance_agreement_onsite(:maintenance_agreement_onsite_3,
                                    onsite_label: maintenance_onsite_label,
                                    job: organization_jobs.maintenance_agreement_job_3
                                  )

create_maintenance_agreement_task(:maintenance_agreement_onsite_task_3,
                                  task_label: maintenance_onsite_task,
                                  onsite: organization_onsites.maintenance_agreement_onsite_3,
                                  job: organization_jobs.maintenance_agreement_job_3,
                                  task_type: :onsite,
                                  status: :cancelled
                                 )

create_maintenance_agreement_task(:maintenance_agreement_job_task_3,
                                  task_label: maintenance_job_task,
                                  job: organization_jobs.maintenance_agreement_job_3,
                                  task_type: :onsite,
                                  status: :done
                                 )

create_maintenance_agreement_task(:maintenance_agreement_offsite_task_3,
                                  task_label: maintenance_job_task,
                                  onsite: nil,
                                  job: organization_jobs.maintenance_agreement_job_3,
                                  task_type: :offsite,
                                  status: :todo
                                 )

create_maintenance_agreement_job(:maintenance_agreement_job_4,
                                 company_name: maintenance_agreement_company,
                                 status: :archived
                                )

create_maintenance_agreement_onsite(:maintenance_agreement_onsite_4,
                                    onsite_label: maintenance_onsite_label,
                                    job: organization_jobs.maintenance_agreement_job_4
                                  )

create_maintenance_agreement_task(:maintenance_agreement_onsite_task_4,
                                  task_label: maintenance_onsite_task,
                                  onsite: organization_onsites.maintenance_agreement_onsite_4,
                                  job: organization_jobs.maintenance_agreement_job_4,
                                  task_type: :onsite,
                                  status: :cancelled
                                 )

create_maintenance_agreement_task(:maintenance_agreement_job_task_4,
                                  task_label: maintenance_job_task,
                                  job: organization_jobs.maintenance_agreement_job_4,
                                  task_type: :onsite,
                                  status: :done
                                 )

create_maintenance_agreement_task(:maintenance_agreement_offsite_task_4,
                                  task_label: maintenance_job_task,
                                  onsite: nil,
                                  job: organization_jobs.maintenance_agreement_job_4,
                                  task_type: :offsite,
                                  status: :todo
                                 )

repeat_job = organization_jobs.create_labeled(:repeat_customer,
                                              name: Faker::Company.name,
                                              organization: organizations.organization_1,
                                              original_creator: users.moonlighter
                                )

organization_onsites.create_labeled(:repeat_onsite_1,
                                    label: "Repeat Onsite 1",
                                    job: organization_jobs.repeat_customer,
                                    google_place: google_places.resident_1,
                                    original_creator: users.moonlighter
                                  )

organization_onsites.create_labeled(:repeat_onsite_2,
                                    label: "Repeat Onsite 2",
                                    job: organization_jobs.repeat_customer,
                                    google_place: google_places.resident_1,
                                    original_creator: users.moonlighter
                                  )


organization_job_tasks.create_labeled(:todo_repeat_onsite_1,
                                      label: "Install a breaker panel",
                                      job: repeat_job,
                                      onsite: organization_onsites.repeat_onsite_1,
                                      task_type: :onsite,
                                      status: :todo,
                                      original_creator: users.organization_1_owner,
                                      estimated_minutes: rand(100)
                                 )

organization_job_tasks.create_labeled(:todo_offsite_repeat_job,
                                      label: "Schedule inspection",
                                      job: repeat_job,
                                      onsite: nil,
                                      task_type: :offsite,
                                      status: :todo,
                                      original_creator: users.organization_1_owner,
                                      estimated_minutes: rand(100)
                                 )

organization_jobs.create_labeled(:archived_job,
                                 name: Faker::Company.name,
                                 organization: organizations.organization_1,
                                 original_creator: users.moonlighter,
                                 status: :archived
                                )

organization_job_tasks.create_labeled(:done_offsite_archived_job,
                                      label: "Send invoice",
                                      job: organization_jobs.archived_job,
                                      onsite: nil,
                                      task_type: :offsite,
                                      status: :done,
                                      original_creator: users.organization_1_owner,
                                      estimated_minutes: rand(100)
                                 )

organization_onsites.create_labeled(:archived_onsite,
                                    label: Faker::Bank.name,
                                    job: organization_jobs.archived_job,
                                    google_place: google_places.business,
                                    original_creator: users.organization_1_department_head
                                  )

organization_job_tasks.create_labeled(:cancelled_onsite_archived_job,
                                      label: "Run new conduit",
                                      job: organization_jobs.archived_job,
                                      onsite: organization_onsites.archived_onsite,
                                      task_type: :onsite,
                                      status: :cancelled,
                                      original_creator: users.organization_1_owner,
                                      estimated_minutes: rand(100)
                                 )

job_for_organization_2 = organization_jobs.create_labeled(:new_customer_organization_2,
                                                          name: Faker::Company.name,
                                                          organization: organizations.organization_2,
                                                          original_creator: users.moonlighter
                                )


organization_job_tasks.create_labeled(:job_for_organization_2_onsite,
                                      label: "Dig trentches",
                                      job: job_for_organization_2,
                                      task_type: :onsite,
                                      status: :todo,
                                      original_creator: users.organization_2_owner,
                                      estimated_minutes: rand(100)
                                    )

organization_jobs.create_labeled(:other_job,
                                 name: Faker::Company.name,
                                 organization: organizations.organization_1,
                                 original_creator: users.moonlighter
                                )