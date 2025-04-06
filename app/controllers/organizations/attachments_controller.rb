# frozen_string_literal: true

class Organizations::AttachmentsController < Organizations::BaseController
  before_action :authorize_creation, only: [:create]
  def create
    attachment = current_organization.attachments.create!(user: current_user, attachment: attachment_params)

    response_payload = {
      url: attachment.attachment.url,
      sgid: attachment.sgid_for_document
    }

    render json: response_payload, status: :created
  end

  protected

  def attachment_params
    params.require(:file)
  end

  def authorize_creation
    authorize!(nil, to: :create?, with: Organization::AttachmentPolicy)
  end
end