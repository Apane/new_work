class CreateReports < ActiveRecord::Migration
  def change
    create_table :reports do |t|
      t.integer :reportable_id
      t.string :reportable_type
      t.belongs_to :user, index: true

      t.timestamps
    end
  end
end
