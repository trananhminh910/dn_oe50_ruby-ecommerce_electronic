module ApplicationHelper
  def full_title page_title = ""
    base_title = t "pages.title"
    page_title.empty? ? base_title : page_title + " | " + base_title
  end

  def number_to_currency_format number
    if Settings.currency_regex.match?(number.to_s)
      Money.new(number.to_f.round(3), t("format.vnd")).format
    else
      number
    end
  end

  def show_message_for_field obj, attribute
    full_messages_for = obj.errors.full_messages_for(attribute)
    return if full_messages_for.empty?

    content_tag :ul, class: "text-danger" do
      full_messages_for.map{|msg| concat(content_tag(:li, msg))}
    end
  end

  def link_to_add_fields name, f_obj, association
    new_object = f_obj.object.send(association).class.new
    id = new_object.object_id
    fields = f_obj.fields_for(association, new_object, child_index: id) do |builder|
      render(association.to_s.singularize + "_fields", f: builder)
    end
    link_to(name, "#", class: "add_fields", data: {id: id, fields: fields.gsub("\n", "")})
  end
end
