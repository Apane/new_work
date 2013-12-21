class CreateEthnicities < ActiveRecord::Migration
  def change
    create_table :ethnicities do |t|
      t.string :name

      t.timestamps
    end
      Ethnicity.create([{ name: 'Asian' }, { name: 'Native American' }, { name: 'Hispanic/Latin' },
      { name: 'Middle Eastern' }, { name: 'Indian' }, { name: 'White' }, { name: 'Black' },
      { name: 'Pacific Islander' }, { name: 'Other' } ])
  end
end

