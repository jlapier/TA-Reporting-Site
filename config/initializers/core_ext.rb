
require 'RMagick'

require 'pdfkit'
PDFKit.configure do |pdfkit_config|
  pdfkit_config.wkhtmltopdf = "/Users/jf/.rvm/gems/ruby-1.8.7-p299/bin/wkhtmltopdf"
end
