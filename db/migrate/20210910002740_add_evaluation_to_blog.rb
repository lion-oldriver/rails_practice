class AddEvaluationToBlog < ActiveRecord::Migration[5.2]
  def change
    add_column :blogs, :evaluation, :float
  end
end
