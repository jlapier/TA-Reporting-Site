# == Schema Information
#
# Table name: users
#
#  id                  :integer       not null, primary key
#  name                :string(255)   
#  email               :string(255)   
#  crypted_password    :string(255)   
#  password_salt       :string(255)   
#  persistence_token   :string(255)   not null
#  single_access_token :string(255)   
#  perishable_token    :string(255)   
#  login_count         :integer       default(0)
#  failed_login_count  :integer       default(0)
#  last_request_at     :datetime      
#  current_login_at    :datetime      
#  last_login_at       :datetime      
#  current_login_ip    :string(255)   
#  last_login_ip       :string(255)   
#  is_admin            :boolean       
#  created_at          :datetime      
#  updated_at          :datetime      
#  openid_identifier   :string(255)   
# End Schema

class User < ActiveRecord::Base
  #has_many :password_resets, :order => 'created_at DESC', :dependent => :destroy
  before_create :make_admin_if_first_user

  acts_as_authentic do |c|
    c.validate_email_field = false
    #c.openid_optional_fields = [:fullname, :email, "http://axschema.org/contant/email"]
  end

  # class << self
  #   def find_by_openid_identifier(identifier)
  #     first(:conditions => { :openid_identifier => identifier }) ||
  #       new(:openid_identifier => identifier)
  #   end
  # end
  # 
  # def map_openid_registration(sreg)
  #   self.email = sreg["email"] if email.blank?
  #   self.name  = sreg["fullname"] if name.blank?
  # end
  
  def confirm_password_reset
    reset_perishable_token!
    Notification.deliver_password_reset_confirmation(self)
  end
  
  def password_reset_confirmed(confirming_ip)
    return false if password_resets.empty?
    # ok to just confirm first in collection due to :order set in has_many
    password_resets.first.confirm(confirming_ip)
  end

  private
    def make_admin_if_first_user
      self.is_admin = true if User.count == 0
    end
end
