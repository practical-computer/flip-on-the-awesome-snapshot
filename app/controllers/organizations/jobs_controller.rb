# frozen_string_literal: true

class Organizations::JobsController < Organizations::BaseController
  include Pagy::Backend

  before_action :load_organization_jobs, only: %i(index)

  before_action :check_create_organization_job_authorization, only: %i(new create)

  before_action :load_organization_job, only: %i( show edit update )
  before_action :check_organization_job_authorization, only: %i( show edit update )

  breadcrumb :organization_jobs, :organization_jobs_path, match: :exact

  helper_method :main_application_navigation_link_key

  def index
    loader = Organization::JobDatatableLoader.load(params: params, base_relation: @organization_jobs)
    @datatable_form = loader.datatable_form
    @organization_jobs = loader.jobs
    @pagy = loader.pagy_instance
  end

  def show
    breadcrumb(t('loaf.breadcrumbs.organization_job', job_name: @organization_job.name),
               organization_job_url(current_organization, @organization_job)
              )

    @job_task_form = Organization::JobTaskForm.new(
      current_organization: current_organization,
      current_user: current_user,
      job: @organization_job,
    )

    datatable_payload = (job_task_datatable_params[:datatable] ||
                                Organization::Datatables::JobTaskDatatableForm.default_payload
                               )

    @job_task_datatable_form = Organization::Datatables::JobTaskDatatableForm.new(datatable_payload)

    task_relation_builder = Organization::JobTaskRelationBuilder.new(payload: @job_task_datatable_form.payload,
                                                                     relation: @organization_job.tasks)
    @pagy, @job_tasks = pagy(task_relation_builder.applied_relation, overflow: :last_page)
  end

  def new
    breadcrumb :new_organization_job, new_organization_job_url
    @form = Organization::JobForm.new(
      current_organization: current_organization,
      current_user: current_user
    )
  end

  def edit
    breadcrumb(t('loaf.breadcrumbs.edit_organization_job', job_name: @organization_job.name),
               edit_organization_job_url(current_organization, @organization_job)
              )
    @form = Organization::JobForm.new(
      job: @organization_job,
      current_organization: current_organization,
      current_user: current_user
    )
  end

  def create
    @form = Organization::JobForm.new(organization_job_params)
    @form.save!

    set_flash_success(message: t('dispatcher.jobs.created_message'))

    organization_job = @form.job

    respond_to do |format|
      format.html { redirect_to organization_job_url(current_organization, organization_job) }
      format.json { json_redirect(location: organization_job_url(current_organization, organization_job))}
    end
  rescue ActiveRecord::RecordInvalid, ActiveModel::ValidationError
    default_respond_to_model_validation_error(html_action: :new, model: @form)
  end

  def update
    @form = Organization::JobForm.new(organization_job_params.merge(
      job: @organization_job
    ))
    @form.save!

    organization_job = @form.job

    updated_message = t('dispatcher.jobs.updated_message', job_name: organization_job.name)
    set_flash_success(message: updated_message)

    respond_to do |format|
      format.html { redirect_to organization_job_url(current_organization, organization_job) }
      format.json { json_redirect(location: organization_job_url(current_organization, organization_job))}
    end
  rescue ActiveRecord::RecordInvalid, ActiveModel::ValidationError
    default_respond_to_model_validation_error(html_action: :edit, model: @form)
  end

  def main_application_navigation_link_key
    case params[:action].to_sym
    when :show
      :organization_job
    else
      :organization_jobs
    end
  end

  private

  def set_flash_success(message:)
    if using_web_awesome?
      icon = helpers.icon_set.job_icon
    else
      icon = helpers.job_icon
    end

    flash[:success] = flash_success_with_icon(message: message, icon: icon)
  end

  def check_create_organization_job_authorization
    authorize!(nil, to: :create?, with: Organization::JobPolicy)
  end

  def check_organization_job_authorization
    authorize!(@organization_job, to: :manage?, with: Organization::JobPolicy)
  end

  def load_organization_jobs
    @organization_jobs = scoped_relation
  end

  def load_organization_job
    @organization_job = authorized_scope(Organization::Job.all, with: Organization::JobPolicy).find(params[:id])
  end

  def scoped_relation
    authorized_scope(Organization::Job.all, with: Organization::JobPolicy)
  end

  # Only allow a list of trusted parameters through.
  def organization_job_params
    params.fetch(:organization_job).permit(
      :name, :note, :status, :google_place
    ).merge(current_user: current_user, current_organization: current_organization)
  end

  def organization_job_datatable_params
    params.permit(datatable: [:sort_key, :sort_direction, filters: {}])
  end

  alias_method :job_task_datatable_params, :organization_job_datatable_params
end
