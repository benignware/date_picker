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
          <!--<input id="<%= input_id %>_hidden" type="hidden" value="<%= value %>" name="<%= name %>"/>-->
          <script>
            (function() {
              console.log("-->", '#<%= input_id %>');
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
                  onSet: function(e) {
                    console.log("****SET");
                  }
                }),
                $element = $('#<%= input_id %>'),
                picker = $element[plugin] && $element[plugin](options)[plugin]('picker');
              
              console.log('--->', plugin, picker.set, picker, $element[plugin]);
              
              if (picker) { 
                console.log("SET", <%= time %>);
                //picker.set('select', <%= time %>);
              }
              
            })();
          </script>
        }
      end
    end
  end
end