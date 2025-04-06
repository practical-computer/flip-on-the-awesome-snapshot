class CreateOrganizationAttachments < ActiveRecord::Migration[7.1]
  def change
    create_table :organization_attachments do |t|
      t.references :organization, null: false
      t.references :user, null: false
      t.jsonb :attachment_data, index: {using: :gin}

      t.timestamps
    end
  end
end
