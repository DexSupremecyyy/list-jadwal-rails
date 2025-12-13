class Project < ApplicationRecord
  validates :tittle,presence:true
  validates :description, length: {minimum:8}
  validates :deadline, presence:true


  def telat?
    deadline.present? && deadline < Date.today
  end

  def hapus
    
  end

  def status_warna
    if telat?
      "red"
    else
      "green"
    end
  end

  def status_text
    if telat?
      "Telat"
    else
      "Aman"
    end
  end
end
