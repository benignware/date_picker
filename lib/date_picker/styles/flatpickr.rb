module DatePicker
  module Styles
    class Flatpickr
      def types
        [:date, :datetime, :time]
      end
      def mapping
        :flatpickr
      end
      def template
        %{
          <input id="<%= input_id %>" name="<%= name %>"/>
          <script>
            (function() {
              var
                options = <%= picker_options %>,
                opts = {
                  dateFormat: "<%= data_format %>",
                  timeFormat: '\u2063',
                  enableTime: <%= type.to_s != 'date' %>,
                  noCalendar: <%= type.to_s == 'time' %>,
                  utc: <%= type.to_s == 'time' %>,
                  defaultDate: new Date(<%= time %>),
                  minDate: <%= min ? 'new Date("' + min.to_s + '")' : 'undefined' %>,
                  maxDate: <%= max ? 'new Date("' + max.to_s + '")' : 'undefined' %>,
                  altInput: true,
                  altFormat: "<%= picker_format %>",
                  time_24hr: <%= /(?<!\\\\\\\\)H/ === picker_format %>
                }
              for (prop in opts) {
                options[prop] = opts[prop]
              }
              console.log("options: ", options);
              var
                picker = flatpickr && flatpickr('#<%= input_id %>', options);
              if (picker) {
                //picker.setDate(new Date(<%= time %>));
              }
            })();
          </script>
        }
      end
    end
  end
end