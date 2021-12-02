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
end
