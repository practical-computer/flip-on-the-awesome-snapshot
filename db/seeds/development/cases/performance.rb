# frozen_string_literal: true

require 'faker'

organization = organizations.create(:performance,
                                    unique_by: :name,
                                    name: "Performance Testing",
                                    timezone: "Eastern Time (US & Canada)"
                                  )

lorene = users.create(:lorene, unique_by: :email, email: "lorene@example.com", name: "Lorene Mckee")
lorene.memberships.find_or_create_by!(organization: organization, membership_type: :organization_manager, state: :active)


job_count = 50
onsite_count = 5
onsite_task_count = 5
no_onsite_task_count = 5

job_count.times do |n|
  job = organization.jobs.find_or_create_by!(
    name: "Performance Job #{n}",
  ) do |x|
    x.status = Organization::Job.statuses.keys.sample
    x.original_creator = lorene
  end

  onsite_count.times.each do |onsite_n|
    onsite = job.onsites.find_or_create_by!(
      label: "Onsite #{onsite_n}"
    ) do |x|
      x.status = Organization::Onsite.statuses.keys.sample
      x.priority = Organization::Onsite.priorities.keys.sample
      x.original_creator = lorene
    end

    onsite_task_count.times do |onsite_task_n|
      onsite.tasks.find_or_create_by!(
        label: "Onsite Task #{onsite_task_n}",
        job: job
      ) do |x|
        x.original_creator = lorene
        x.task_type = Organization::JobTask.task_types.keys.sample
        x.status = Organization::JobTask.statuses.keys.sample
      end
    end
  end

  no_onsite_task_count.times do |no_onsite_task_n|
    job.tasks.find_or_create_by!(
      label: "No Onsite Task #{no_onsite_task_n}",
    ) do |x|
      x.original_creator = lorene
      x.task_type = Organization::JobTask.task_types.keys.sample
      x.status = Organization::JobTask.statuses.keys.sample
    end
  end
end