# encoding: utf-8
module Cms::Model::Rel::Inquiry
  attr_accessor :in_inquiry

  def self.included(mod)
    mod.belongs_to :inquiry, :foreign_key => 'unid', :class_name => 'Cms::Inquiry',
      :dependent => :destroy

    mod.after_save :save_inquiry
  end

  def in_inquiry
    unless val = read_attribute(:in_inquiry)
      val = {}
      val = inquiry.attributes if inquiry
      write_attribute(:in_inquiry, val)
    end
    read_attribute(:in_inquiry)
  end

  def in_inquiry=(values)
    #@inquiry = values
    #@inquiry.each {|k,v| @inquiry[k.to_s] = nil if v.blank? }
    @inquiry = {}
    values.each {|k,v| @inquiry[k.to_s] = v if !v.blank? }
    write_attribute(:in_inquiry, @inquiry)
  end

  def inquiry_states
   {'visible' => '表示', 'hidden' => '非表示'}
  end
  
  def default_inquiry(params = {})
    unless g = Core.user.group
      return params
    end
    {:state => 'visible', :group_id => g.id, :tel => g.tel, :email => g.email}.merge(params)
  end
  
  def validate_inquiry
    if @inquiry && @inquiry['state'] == 'visible'
      errors.add "連絡先（課）", :empty if @inquiry['group_id'].blank?
      #errors.add "連絡先（室・担当）", :empty if @inquiry['charge'].blank?
      errors.add "連絡先（電話番号）", :empty if @inquiry['tel'].blank?
      errors.add "連絡先（メールアドレス）", :empty if @inquiry['email'].blank?
      errors.add "連絡先（電話番号）", :onebyte_characters if @inquiry['tel'].to_s !~/^[ -~｡-ﾟ]*$/
      errors.add "連絡先（ファクシミリ）", :onebyte_characters if @inquiry['fax'].to_s !~/^[ -~｡-ﾟ]*$/
      errors.add "連絡先（メールアドレス）", :onebyte_characters if @inquiry['email'].to_s !~/^[ -~｡-ﾟ]*$/
    end
  end

  def save_inquiry
    return false unless unid
    return true unless @inquiry

    values = @inquiry
    @inquiry = nil

    _inq = inquiry || Cms::Inquiry.new
    _inq.state    = values['state']    unless values['state'].nil?
    _inq.group_id = values['group_id'] unless values['group_id'].nil?
    _inq.charge   = values['charge']   #unless values['charge'].nil?
    _inq.tel      = values['tel']      unless values['tel'].nil?
    _inq.fax      = values['fax']      #unless values['fax'].nil?
    _inq.email    = values['email']    unless values['email'].nil?

    if _inq.new_record?
      _inq.id = unid
      return false unless _inq.save_with_direct_sql
    else
      return false unless _inq.save
    end
    inquiry(true)
    return true
  end
end
