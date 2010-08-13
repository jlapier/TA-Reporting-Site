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

  def html_to_pdf(html="")
    @pdfkit = PDFKit.new(html, :page_size => "Letter")
    PDFConverter.stylesheets.each do |stylesheet|
      @pdfkit.stylesheets << stylesheet
    end
    @pdfkit.to_pdf
  end
end

module Basic
  def self.included(base)
    PDFConverter.stylesheets = [
      File.join(Rails.root, "public/stylesheets/blueprint/print.css")
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
