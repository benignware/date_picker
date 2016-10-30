module DatePicker
  module Styles
    class Pickadate
      def types
        [:date, :time]
      end
      def mapping()
        :pickadate
      end
      def template() 
        %{
          <%= input_html %>
          <script>
            (function($) {
              var
                type = '<%= type %>',
                plugin = 'picka' + type,
                options = $.extend(true, {}, <%= picker_options %>, {
                  monthsFull: <%= month_names.to_json %>,
                  monthsShort: <%= abbr_month_names.to_json %>,
                  weekdaysFull: <%= day_names.to_json %>,
                  weekdaysShort: <%= abbr_day_names.to_json %>,
                  format: '<%= picker_format %>',
                  formatSubmit: '<%= data_format %>',
                  hiddenName: true,
                  min: <%= min ? 'new Date("' + min.to_s + '")' : 'undefined' %>,
                  max: <%= max ? 'new Date("' + max.to_s + '")' : 'undefined' %>
                }),
                $element = $('#<%= input_id %>'),
                picker = $element[plugin] && $element[plugin](options)[plugin]('picker');
            })(jQuery);
          </script>
        }
      end
    end
  end
end