# frozen_string_literal: true

class Organizations::NotesController < Organizations::BaseController
  before_action :load_organization_notes, only: %i(index)

  before_action :check_create_organization_note_authorization, only: %i(new create)

  before_action :load_resource_from_path_params_gid, only: %i(new)

  before_action :load_organization_note, only: %i( show edit update destroy)
  before_action :check_organization_note_authorization, only: %i( show edit update destroy)

  breadcrumb :organization_notes, :organization_notes_path, match: :exact

  helper_method :main_application_navigation_link_key

  def index
  end

  def show
    breadcrumb(t('loaf.breadcrumbs.organization_note'),
               organization_note_url(current_organization, @organization_note)
              )
  end

  def new
    breadcrumb :new_organization_note, new_organization_note_url
    @form = Organization::NoteForm.new(
      current_organization: current_organization,
      current_user: current_user,
      resource: @resource
    )
  end

  def edit
    breadcrumb(t('loaf.breadcrumbs.edit_organization_note'),
               edit_organization_note_url(current_organization, @organization_note)
              )
    @form = Organization::NoteForm.new(
      note: @organization_note,
      current_organization: current_organization,
      current_user: current_user
    )
  end

  def create
    @form = Organization::NoteForm.new(organization_note_params.merge(
      resource: Organization::Note.resource_from_sgid(sgid: params.fetch(:organization_note).fetch(:resource_gid))
    ))
    @form.save!

    set_flash_success(message: t('dispatcher.notes.created_message'))

    organization_note = @form.note

    redirect_url = helpers.note_resource_url(note: organization_note)

    respond_to do |format|
      format.html { redirect_to redirect_url }
      format.json { json_redirect(location: redirect_url)}
    end
  rescue ActiveRecord::RecordInvalid, ActiveModel::ValidationError
    default_respond_to_model_validation_error(html_action: :new, model: @form)
  end

  def update
    @form = Organization::NoteForm.new(organization_note_params.merge(
      note: @organization_note
    ))
    @form.save!

    organization_note = @form.note

    updated_message = t('dispatcher.notes.updated_message')
    set_flash_success(message: updated_message)

    redirect_url = helpers.note_resource_url(note: organization_note)

    respond_to do |format|
      format.html { redirect_to redirect_url }
      format.json { json_redirect(location: redirect_url)}
    end
  rescue ActiveRecord::RecordInvalid, ActiveModel::ValidationError
    default_respond_to_model_validation_error(html_action: :edit, model: @form)
  end

  def destroy
    redirect_url = helpers.note_resource_url(note: @organization_note)

    @organization_note.destroy!

    set_flash_notice(message: t('dispatcher.notes.deleted_message'))

    respond_to do |format|
      format.html { redirect_to redirect_url }
      format.json { json_redirect(location: redirect_url)}
    end
  end

  def main_application_navigation_link_key
    case params[:action].to_sym
    when :show
      :organization_note
    else
      :organization_notes
    end
  end

  private

  def set_flash_success(message:)
    if using_web_awesome?
      icon = helpers.icon_set.notes_icon
    else
      icon = helpers.note_icon
    end

    flash[:success] = flash_success_with_icon(message: message, icon: icon)
  end

  def set_flash_notice(message:)
    if using_web_awesome?
      icon = helpers.icon_set.notes_icon
    else
      icon = helpers.note_icon
    end

    flash[:notice] = flash_notice_with_icon(message: message, icon: icon)
  end

  def check_create_organization_note_authorization
    authorize!(nil, to: :create?, with: Organization::NotePolicy)
  end

  def check_organization_note_authorization
    authorize!(@organization_note, to: :manage?, with: Organization::NotePolicy)
  end

  def load_organization_notes
    @organization_notes = scoped_relation
  end

  def load_resource_from_path_params_gid
    @resource = Organization::Note.resource_from_sgid(sgid: params.fetch(:resource_gid))
    raise ActiveRecord::RecordNotFound if @resource.nil?
  end

  def load_organization_note
    @organization_note = authorized_scope(current_organization.notes, with: Organization::NotePolicy).find(params[:id])
  end

  def scoped_relation
    authorized_scope(current_organization.notes.reverse_chronological, with: Organization::NotePolicy)
  end

  # Only allow a list of trusted parameters through.
  def organization_note_params
    params.fetch(:organization_note).permit(
      :tiptap_document
    ).merge(current_user: current_user, current_organization: current_organization)
  end
end
