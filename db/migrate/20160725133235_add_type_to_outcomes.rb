class AddTypeToOutcomes < ActiveRecord::Migration
  def change
    add_column :outcomes, :type, :string
    add_column :outcomes, :lower_bound, :integer
    add_column :outcomes, :upper_bound, :integer
  end
end
