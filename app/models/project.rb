class Project < ApplicationRecord
  validates :tittle,presence:true
  validates :description, length: {minimum:8}
  validates :deadline, presence:true


  def telat?
    deadline.present? && deadline < Date.today
  end

  def status_warna_border
    if telat?
      "border_merah"
    else
      "border_hijau"
    end
  end
  
  def status_warna_text
    if telat?
      "text_merah"
    else
      "text_hijau"
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
