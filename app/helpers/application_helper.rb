module ApplicationHelper
  def default_meta_tags
    {
      site: "#{t("controller.#{controller_name}")} | #{t('title')}",
      description: t('desc'),
      keywords: t('keywords'), 
      reverse: true,
    }
  end
  #def sortable(column, title = nil)  
    #title ||= column.titleize  
    #css_class = (column == sort_column) ? "current #{sort_direction}" : nil  
    #direction = (column == sort_column && sort_direction == "asc") ? "desc" : "asc"  
    #link_to title, params.merge(sort: column, direction: direction, page: nil), {class: css_class}  
  #end

  def action_show(class_constantize  = nil,diy_action = nil)
    class_constantize ||=  controller_name.singularize.capitalize.constantize
    diy_action ||= action_name
    t('titles.'+diy_action,model: class_constantize.model_name.human)
    #    output  +=  model.model_name.human
    #    elsif action_name == 'new'
  end

  def could_bread?
    !['home','sessions','registrations','inventories'].include? controller_name
  end

  #def link_to_add_fields(name, f, association)
    #new_object = f.object.class.reflect_on_association(association).klass.new
    #fields = f.fields_for(association, new_object, child_index: "new_#{association}") do |builder|
      #render(association.to_s.singularize + "_fields", f: builder)
    #end
    #link_to_function(name, h("add_fields(this, \"#{association}\", \"#{escape_javascript(fields)}\")"))
  #end

  #def base_target_blank
    #content_for :head ,raw('<base target="_blank">')
  #end

  def section p ,&block
    default_p = {
      title:'',
      id:'',
      section_id:''
    }
    p = default_p.merge(p)
    content = capture(&block) 
    render 's',p.merge(content: content)
  end

  def upload_image_tag upload,name,size=nil
   if upload
     content = image_tag upload.image.url(size),alt:name,title:name
   else
     content = "<img src='/images/nopic.gif'  alt='#{name}' title='#{name}' />"
   end
   raw content
  end

  def p_field record,attr_name
    if record.send(attr_name).blank?
      ''
    else 
      content = "<p><b>#{record.class.human_attribute_name(attr_name)}:</b>#{record.send(attr_name)}</p>"
      raw content
    end
  end
end
