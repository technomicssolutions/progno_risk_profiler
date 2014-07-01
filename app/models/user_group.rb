class UserGroup < ActiveRecord::Base
  attr_accessible :name, :status
  validates_presence_of :name
  has_many :groupings, :dependent=>:destroy
  has_many :users, :through => :groupings
  has_many :abilities, :through=>:ability_group_mappings
  has_many :ability_group_mappings, :dependent=>:destroy

  def update_ability_group_mapping(abilities)
    if !abilities.nil?
      current_abilities=self.ability_group_mappings
      current_abilities.each do |current_ability|
        if !abilities.member?current_ability.ability_id
          if AbilityGroupMapping.find current_ability.id
            AbilityGroupMapping.destroy current_ability.id
          end
        end
      end
      current_abilities = current_abilities.map {|current_ability| current_ability.id}
      abilities.each do |ability|
        if !current_abilities.member?ability
          AbilityGroupMapping.create(:ability_id=>ability, :user_group_id=>self.id)
        end
      end
      return true
    else
      return false
    end
  end

end
