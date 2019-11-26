class AddLinkToCycles < ActiveRecord::Migration[5.2]
  def change
    add_column :cycles, :link, :text
  end
end
