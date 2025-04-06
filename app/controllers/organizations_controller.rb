# frozen_string_literal: true

class OrganizationsController < Users::BaseController
  before_action :load_organizations
  before_action :set_current_organization, only: [:show]
  before_action :set_webawesome_variant
  helper_method :main_application_navigation_link_key

  def index
  end

  def show
    base_relation = authorized_scope(Organization::Job.all,
                                     with: Organization::JobPolicy,
                                     context: {organization: current_organization}
                                    )
    loader = Organization::JobDatatableLoader.load(params: params, base_relation: base_relation)
    @datatable_form = loader.datatable_form
    @organization_jobs = loader.jobs
    @pagy = loader.pagy_instance
  end

  def main_application_navigation_link_key
    case params[:action].to_sym
    when :show
      :organization
    else
      :organizations
    end
  end

  protected

  def resolve_layout
    return "main_application" if params[:action] == "show"
    super
  end

  def load_organizations
    @organizations = authorized_scope(current_user.organizations.order(name: :asc), with: OrganizationPolicy)
  end

  def set_current_organization
    @current_organization = current_user.organizations.find(params[:id])
    authorize!(@current_organization, to: :show?, with: OrganizationPolicy)
  end
end
