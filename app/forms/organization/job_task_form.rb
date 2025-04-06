# frozen_string_literal: true

class Organization::JobTaskForm
  include ActiveModel::API
  include ActiveModel::Validations::Callbacks
  include ActionPolicy::Behaviour
  include JobManageAuthorizationCheck

  authorize :user, through: :current_user
  authorize :organization, through: :current_organization
  authorize :job

  attr_accessor :current_user, :current_organization, :job,
                :job_task, :onsite,
                :label, :task_type, :status, :estimated_duration

  validates :current_organization, presence: true, allow_blank: false, allow_nil: false
  validates :current_user, presence: true, allow_blank: false, allow_nil: false
  validates :job, presence: true, allow_blank: false, allow_nil: false
  validates :onsite, presence: true, allow_blank: false, allow_nil: true

  validate :can_manage_job_tasks?

  def initialize(attributes = {})
    super

    self.job ||= self.job_task&.job
    self.onsite ||= self.job_task&.onsite
    self.label ||= self.job_task&.label
    self.task_type ||= self.job_task&.task_type || "onsite"
    self.status ||= self.job_task&.status || "todo"
    self.estimated_duration ||= self.job_task&.estimated_minutes || "1:00"

    clear_onsite_if_empty_value_provided(attributes)

    if self.job_task.present?
      update_existing_job_task
    else
      build_new_job_task
    end
  end

  def save!
    validate!
    self.job_task.save!
  rescue ActiveRecord::RecordInvalid => e
    self.errors.merge!(e.record.errors)
    raise e
  end

  def persisted?
    self.job_task.persisted?
  end

  def model_name
    self.job_task.model_name
  end

  def available_onsites
    self.job.onsites.available_to_assign_tasks_to
  end

  def clear_onsite_if_empty_value_provided(attributes)
    return unless attributes.has_key?(:onsite)
    return if attributes[:onsite].present?
    self.onsite = nil
  end

  def update_existing_job_task
    self.job_task.onsite = self.onsite
    self.job_task.label = self.label
    self.job_task.task_type = self.task_type
    self.job_task.status = self.status
    self.job_task.estimated_minutes = PracticalFramework::DurationParser.to_minutes(duration: self.estimated_duration)
  end

  def build_new_job_task
    self.job_task = job.tasks.build(
      onsite: self.onsite,
      label: self.label,
      task_type: self.task_type,
      status: self.status,
      estimated_minutes: PracticalFramework::DurationParser.to_minutes(duration: self.estimated_duration),
      original_creator: current_user
    )
  end

  def can_manage_job_tasks?
    job_can_manage?(policy_action: :manage_tasks?, cannot_manage_error_key: :cannot_manage_job_tasks)
  end
end