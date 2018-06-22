class WeekDayInput < SimpleForm::Inputs::Base
  def input(wrapper_options = nil)
    merged_input_options = merge_wrapper_options(input_html_options, wrapper_options)
    weekdays = [:monday, :tuesday, :wednesday, :thursday, :friday, :saturday, :sunday].each_with_index.map do |day, i|
      [I18n.t(:"date.day_names")[(i+1)%7], day]
    end
    @builder.select(attribute_name, weekdays, input_options, merged_input_options )
  end
end
