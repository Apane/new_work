class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string :name

      t.timestamps
    end

    Category.create([
      {name: 'SocialGathering' },
      {name: 'Food' },
      {name: 'Movies' },
      {name: 'Drinks' },
      {name: 'Hangout' },
      {name: 'Show' },
      {name: 'PhysicalActivity' },
      {name: 'Presentation' },
      {name: 'Other' }
    ])
  end
end

