Date::DATE_FORMATS[:year_month_number] = lambda{ |date| date.strftime("%Y-%m") }
Date::DATE_FORMATS[:month_year_string] = lambda{ |date| date.strftime("%B %Y") }
