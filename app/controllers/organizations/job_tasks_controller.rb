# frozen_string_literal: true

class Organizations::JobTasksController < Organizations::BaseController
  before_action :load_organization_job, only: %i( new create )
  before_action :load_organization_job_task, only: %i( show edit update )
  before_action :load_organization_job_from_task, only: %i(show edit update)

  before_action :check_job_manage_tasks_authorization, only: %i(new create edit update)
  before_action :check_organization_job_task_authorization, only: %i( show edit update )
  before_action :set_breadcrumbs_for_job_and_organization, only: %i( new show edit )

  helper_method :main_application_navigation_link_key

  def show
    breadcrumb(t('loaf.breadcrumbs.organization_job_task', job_task_label: @organization_job_task.label),
               job_task_url(current_organization, @organization_job_task)
              )
  end

  def new
    breadcrumb :new_organization_job_task, new_organization_job_task_url
    @form = Organization::JobTaskForm.new(
      current_organization: current_organization,
      current_user: current_user,
      job: @organization_job,
    )
  end

  def edit
    breadcrumb(t('loaf.breadcrumbs.edit_organization_job_task', job_task_label: @organization_job_task.label),
               edit_job_task_url(current_organization, @organization_job_task)
              )
    @form = Organization::JobTaskForm.new(
      job_task: @organization_job_task,
      current_organization: current_organization,
      current_user: current_user
    )
  end

  def create
    @form = Organization::JobTaskForm.new(organization_job_task_params)
    @form.save!

    message = t('dispatcher.job_tasks.created_message')
    set_flash_success(message: message)

    organization_job_task = @form.job_task

    redirect_url = helpers.job_task_assigned_url(job_task: organization_job_task)

    respond_to do |format|
      format.html { redirect_to redirect_url }
      format.json { json_redirect(location: redirect_url)}
    end
  rescue ActiveRecord::RecordInvalid, ActiveModel::ValidationError
    default_respond_to_model_validation_error(html_action: :new, model: @form)
  end

  def update
    @form = Organization::JobTaskForm.new(organization_job_task_params.merge(
      job_task: @organization_job_task
    ))
    @form.save!

    organization_job_task = @form.job_task

    updated_message = t('dispatcher.job_tasks.updated_message', job_task_label: organization_job_task.label)
    set_flash_success(message: updated_message)

    redirect_url = helpers.job_task_assigned_url(job_task: organization_job_task)

    respond_to do |format|
      format.html { redirect_to redirect_url }
      format.json { json_redirect(location: redirect_url)}
    end
  rescue ActiveRecord::RecordInvalid, ActiveModel::ValidationError
    default_respond_to_model_validation_error(html_action: :edit, model: @form)
  end

  def main_application_navigation_link_key
    case params[:action].to_sym
    when :show
      :organization_job_task
    else
      :organization_job_tasks
    end
  end

  private

  def set_flash_success(message:)
    if using_web_awesome?
      icon = helpers.icon_set.job_task_icon
    else
      icon = helpers.job_task_icon
    end

    flash[:success] = flash_success_with_icon(message: message, icon: icon)
  end

  def set_breadcrumbs_for_job_and_organization
    breadcrumb :organization_jobs, :organization_jobs_path, match: :exact

    breadcrumb(t('loaf.breadcrumbs.organization_job', job_name: @organization_job.name),
               organization_job_url(current_organization, @organization_job), match: :exact
              )

    onsite = @organization_job_task&.onsite

    if onsite&.present?
      breadcrumb_label = t('loaf.breadcrumbs.organization_onsite', onsite_label: onsite.label
                          )
      breadcrumb(breadcrumb_label, onsite_url(current_organization, onsite), match: :exact)
    end
  end

  def load_organization_job
    @organization_job = authorized_scope(Organization::Job.all, with: Organization::JobPolicy).find(params[:job_id])
  end

  def load_organization_job_from_task
    @organization_job = @organization_job_task.job
  end

  def check_job_manage_tasks_authorization
    authorize!(@organization_job, to: :manage_tasks?, with: Organization::JobPolicy)
  end

  def check_organization_job_task_authorization
    authorize!(@organization_job_task, to: :manage?, with: Organization::JobTaskPolicy)
  end

  def load_organization_job_tasks
    @organization_job_tasks = scoped_relation
  end

  def load_organization_job_task
    @organization_job_task = authorized_scope(Organization::JobTask.all,
                                              with: Organization::JobTaskPolicy).find(params[:id])
  end

  def scoped_relation
    authorized_scope(Organization::JobTask.all, with: Organization::JobTaskPolicy)
  end

  def onsite_and_job_params_to_merge
    to_merge = {job: @organization_job}

    if params.dig(:organization_job_task)&.has_key?(:onsite)
      to_merge[:onsite] = @organization_job.onsites.find_by(id: params.dig(:organization_job_task, :onsite))
    end

    return to_merge
  end

  # Only allow a list of trusted parameters through.
  def organization_job_task_params
    params.fetch(:organization_job_task).permit(
      :label, :estimated_duration, :status, :task_type
    )
    .merge(onsite_and_job_params_to_merge)
    .merge(current_user: current_user, current_organization: current_organization)
  end
end
