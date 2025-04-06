class CreateOrganizationNotes < ActiveRecord::Migration[7.1]
  def change
    create_table :organization_notes do |t|
      t.references :organization, null: false, foreign_key: true
      t.references :original_author, null: false, foreign_key: { to_table: :users }
      t.references :resource, null: false, polymorphic: true, index: true
      t.jsonb :tiptap_document, null: false

      t.timestamps
    end
  end
end
