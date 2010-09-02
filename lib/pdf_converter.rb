class PDFConverter
  
  cattr_accessor :stylesheets
  attr_reader :pdfkit
  @@stylesheets = []
  
  def initialize(options={})
    PDFKit.configure do |config|
      pipe = IO.popen("/usr/bin/which wkhtmltopdf")
      wkhtmltopdf_path = pipe.readlines.first.to_s.strip.freeze
      config.wkhtmltopdf = wkhtmltopdf_path
    end
    self.class.send(:include, options[:formatter].constantize) if options[:formatter]
    self.class.send(:include, Basic) unless options[:formatter]
  end
  def page_to_pdf(url)
    @pdfkit = PDFKit.new(url, {
      :footer_center => "[page] / [topage]",
      :header_spacing => "5",
      :footer_spacing => "5"
    })
    @pdfkit.to_pdf
  end
  def html_to_pdf(html="")
    @pdfkit = PDFKit.new(html, {
      :footer_center => "[page] / [topage]",
      :margin_bottom => "8mm",
      :margin_top => "8mm",
      :margin_left => "9mm",
      :margin_right => "9mm"
    })
    PDFConverter.stylesheets.each do |stylesheet|
      @pdfkit.stylesheets << stylesheet
    end
    @pdfkit.to_pdf
  end
end

module Basic
  def self.included(base)
    PDFConverter.stylesheets = [
      File.join(Rails.root, "public/stylesheets/pdf_basic.css")
    ]
  end
end

module Reports
  def self.included(base)
    PDFConverter.stylesheets = [
      File.join(Rails.root, "public/stylesheets/blueprint/print.css"),
      File.join(Rails.root, "public/stylesheets/application.css"),
      File.join(Rails.root, "public/stylesheets/text_and_colors.css")
    ]
  end
end
