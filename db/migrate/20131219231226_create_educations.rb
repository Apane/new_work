class CreateEducations < ActiveRecord::Migration
  def change
    create_table :educations do |t|
      t.string :name

      t.timestamps
    end
      Education.create([{ name: 'High school' }, { name: 'GED' }, { name: 'Bachelors' },
      { name: 'Masters' }, { name: 'PhD' }])
  end
end
