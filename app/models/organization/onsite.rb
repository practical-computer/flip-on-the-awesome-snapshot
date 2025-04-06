# frozen_string_literal: true

class Organization::Onsite < ApplicationRecord
  belongs_to :original_creator, class_name: "User"
  belongs_to :job
  has_one :organization, through: :job
  belongs_to :google_place, optional: true
  has_many :notes, as: :resource, dependent: :destroy
  has_many :tasks, class_name: "JobTask", dependent: :destroy

  validates :label, presence: true,
                   allow_blank: false,
                   allow_nil: false

  enum :priority, { regular_priority: 0, high_priority: 1 }, default: :regular_priority
  enum :status, { draft: 0, scheduled: 1, in_progress: 2, done: 3, discarded: 4 }, default: :draft

  scope :available_to_assign_tasks_to, -> { where(status: [:draft, :scheduled, :in_progress]) }

  generates_token_for :readonly_view do
    readonly_token_generated_at
  end

  after_commit :break_caches

  def break_caches
    Caching::BreakTasksAndOnsitesCacheForOrganizationJob.perform_later(job: job)

    if job_id_previously_was.present?
      Caching::BreakTasksAndOnsitesCacheForOrganizationJob.perform_later(
        job: Organization::Job.find(job_id_previously_was)
      )
    end
  end
end
