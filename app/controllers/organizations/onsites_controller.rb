# frozen_string_literal: true

class Organizations::OnsitesController < Organizations::BaseController
  include Pagy::Backend

  before_action :load_organization_job, only: %i( new create )
  before_action :load_organization_onsite, only: %i( show edit update )
  before_action :load_organization_job_from_onsite, only: %i(show edit update)

  before_action :check_job_manage_onsites_authorization, only: %i(new create edit update)
  before_action :check_show_organization_onsite_authorization, only: %i( show )
  before_action :check_manage_organization_onsite_authorization, only: %i( edit update )

  before_action :set_organization_job_breadcrumb

  helper_method :main_application_navigation_link_key

  def show
    breadcrumb_label = t('loaf.breadcrumbs.organization_onsite', onsite_label: @organization_onsite.label,
                                                                 job_name: @organization_onsite.job.name
                        )
    breadcrumb breadcrumb_label, onsite_url(current_organization, @organization_onsite)

    @note_form = Organization::NoteForm.new(
      current_organization: current_organization,
      current_user: current_user,
      resource: @organization_onsite
    )

    @job_task_form = Organization::JobTaskForm.new(
      current_organization: current_organization,
      current_user: current_user,
      job: @organization_job,
      onsite: @organization_onsite
    )

    datatable_payload = (job_task_datatable_params[:datatable] ||
                         Organization::Datatables::JobTaskDatatableForm.default_payload
                        )

    @job_task_datatable_form = Organization::Datatables::JobTaskDatatableForm.new(datatable_payload)

    task_relation_builder = Organization::JobTaskRelationBuilder.new(payload: @job_task_datatable_form.payload,
                                                                     relation: @organization_onsite.tasks)

    @pagy, @job_tasks = pagy(task_relation_builder.applied_relation, overflow: :last_page)
  end

  def new
    breadcrumb :new_organization_onsite, new_organization_job_onsite_url(current_organization, @organization_job)
    @form = Organization::OnsiteForm.new(
      current_organization: current_organization,
      current_user: current_user,
      job: @organization_job
    )
  end

  def edit
    breadcrumb_label = t('loaf.breadcrumbs.edit_organization_onsite', onsite_label: @organization_onsite.label,
                                                                 job_name: @organization_onsite.job.name
                        )

    breadcrumb breadcrumb_label, edit_onsite_url(current_organization, @organization_onsite)
    @form = Organization::OnsiteForm.new(
      onsite: @organization_onsite,
      current_organization: current_organization,
      current_user: current_user
    )
  end

  def create
    @form = Organization::OnsiteForm.new(organization_onsite_params)
    @form.save!

    set_flash_after_create

    organization_onsite = @form.onsite

    respond_to do |format|
      format.html { redirect_to onsite_url(current_organization, organization_onsite) }
      format.json { json_redirect(location: onsite_url(current_organization, organization_onsite))}
    end
  rescue ActiveRecord::RecordInvalid, ActiveModel::ValidationError
    handle_form_errors(render_action: :new)
  end

  def update
    @form = Organization::OnsiteForm.new(organization_onsite_params.merge(
      onsite: @organization_onsite
    ))
    @form.save!

    organization_onsite = @form.onsite

    set_flash_after_update(organization_onsite: organization_onsite)

    respond_to do |format|
      format.html { redirect_to onsite_url(current_organization, organization_onsite) }
      format.json { json_redirect(location: onsite_url(current_organization, organization_onsite))}
    end
  rescue ActiveRecord::RecordInvalid, ActiveModel::ValidationError
    handle_form_errors(render_action: :edit)
  end

  def main_application_navigation_link_key
    case params[:action].to_sym
    when :show
      :organization_onsite
    else
      :organization_onsites
    end
  end

  private

  def set_flash_after_create
    if using_web_awesome?
      icon = helpers.icon_set.onsite_icon
    else
      icon = helpers.onsite_icon
    end

    message = t('dispatcher.onsites.created_message')
    flash[:success] = flash_success_with_icon(message: message, icon: icon)
  end

  def set_flash_after_update(organization_onsite:)
    if using_web_awesome?
      icon = helpers.icon_set.onsite_icon
    else
      icon = helpers.onsite_icon
    end

    message = t('dispatcher.onsites.updated_message', onsite_label: organization_onsite.label,
                                                      job_name: organization_onsite.job.name
               )
    flash[:success] = flash_success_with_icon(message: message, icon: icon)
  end

  def handle_form_errors(render_action:)
    respond_to do |format|
      format.json do
        errors = PracticalFramework::FormBuilders::Base.build_error_json(model: @form,
                                                                         helpers: helpers)
        render json: errors, status: :bad_request
      end
      format.html do
        render render_action, status: :bad_request
      end
    end
  end

  def set_organization_job_breadcrumb
    breadcrumb :organization_jobs, :organization_jobs_path, match: :exact
    breadcrumb(t('loaf.breadcrumbs.organization_job', job_name: @organization_job.name),
               organization_job_url(current_organization, @organization_job)
              )
  end

  def load_organization_job
    @organization_job = authorized_scope(Organization::Job.all, with: Organization::JobPolicy).find(params[:job_id])
  end

  def load_organization_job_from_onsite
    @organization_job = @organization_onsite.job
  end

  def check_job_manage_onsites_authorization
    authorize!(@organization_job, to: :manage_onsites?, with: Organization::JobPolicy)
  end

  def check_manage_organization_onsite_authorization
    authorize!(@organization_onsite, to: :manage?, with: Organization::OnsitePolicy)
  end

  def check_show_organization_onsite_authorization
    authorize!(@organization_onsite, to: :show?, with: Organization::OnsitePolicy)
  end

  def load_organization_onsite
    @organization_onsite = scoped_relation.find(params[:id])
  end

  def scoped_relation
    authorized_scope(Organization::Onsite.all, with: Organization::OnsitePolicy)
  end

  # Only allow a list of trusted parameters through.
  def organization_onsite_params
    params.fetch(:organization_onsite).permit(
      :label, :priority, :status, :google_place
    ).merge(current_user: current_user,
            current_organization: current_organization,
            job: @organization_job
           )
  end

  def job_task_datatable_params
    params.permit(datatable: [:sort_key, :sort_direction, filters: {}])
  end
end
