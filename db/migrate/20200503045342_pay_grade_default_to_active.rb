class PayGradeDefaultToActive < ActiveRecord::Migration[5.2]
  def change
    change_column_default :pay_grades, :active, true  
  end
end
