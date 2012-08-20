class Link < ActiveRecord::Base
 has_many :link_types

 #before_create :check_object
 #after_create            :after_create, :cache_delete
 #after_update            :cache_delete
 #after_destroy           :cache_delete

=begin

  Link.add(
    :link_types_id            => 12,
    :link_object_source       => 'Ticket',
    :link_object_source_value => 1,
    :link_object_target       => 'Ticket',
    :link_object_target_value => 1
  )

  Link.add(
    :link_types_id            => 12,
    :link_object_source_id    => '1',
    :link_object_source_value => 1,
    :link_object_target_id    => '1',
    :link_object_target_value => 1,
  )
 
  Link.get_links_for_source_object(
    :link_object       => 'Ticket',
    :link_object_value => 1
  )
 
  Link.get_links_for_target_object(
    :link_object       => 'Ticket',
    :link_object_value => 1,
  )

 Link.delete_link_by_source( :source_value => 1 )
 
 Link.delete_link_by_target( :target_value => 1 )
 
 Link.delete_all_links_by_value( :object_value => 1 )
=end


  def self.get_links_for_source_object(data)
    linkobject_id = self.get_linktype_by_name( :name => data[:link_object] )
    if linkobject_id
      where( :link_object_source_id => linkobject_id, :link_object_source_value => data[:link_object_value] )
    end
  end

  def self.get_links_for_target_object(data)
    linkobject_id = self.get_linktype_by_name( :name => data[:link_object] )
    if linkobject_id
      where( :link_object_target_id => linkobject_id, :link_object_target_value => data[:link_object_value] )
    end
  end

  def self.add(data)
    if data.has_key?(:link_object_source)

      # it exists we have to delete it
      linkobject_id = self.get_linktype_by_name( :name => data[:link_object_source] )
      data[:link_object_source_id] = linkobject_id
      data.delete( :link_object_source )
    end
              
    if data.has_key?(:link_object_target)
      # it exists we have to delete it
      linkobject_id = self.get_linktype_by_name( :name => data[:link_object_target] )
      data[:link_object_target_id] = linkobject_id
      data.delete( :link_object_target )
    end

    Link.create(data)
  end

  def self.delete_link_by_source(data)
   Link.where( :link_object_source_value => data[:source_value] ).destroy_all
  end

  def self.delete_link_by_target(data)
    Link.where( :link_object_target_value => data[:target_value] ).destroy_all
  end

  def self.delete_all_links_by_value(data)
    Link.where( ["link_object_source_value = ? or link_object_target_value = ?", data[:object_value], data[:object_value]] ).destroy_all
  end


  private
    def self.get_linktype_by_name(data)
      linkid = Link::Object.where(:name=>data[:name]).first
      if linkid
        return linkid.id
      else
        return nil
      end
      return linkid
    end

    #checks for a valid link type
    def check_valid_link_type
      Rails.logger.info "Logger Test"
      puts "pre check link type"
    end

    def get_linkobject_by_key
      puts "check for exisiting link"
    end

    #checks for an exisiting ling
    def check_existing_link
    	puts "check for exisiting link"
    end
end

class Link::Type < ActiveRecord::Base
end

class Link::Object < ActiveRecord::Base
end