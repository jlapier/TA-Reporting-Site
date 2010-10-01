require 'spec_helper'

describe PDFConverter do
  describe "setup" do
    it "configures PDFKit" do
      PDFKit.should_receive(:configure)
      PDFConverter.new
    end
    it "detects the path to the wkhtmltopdf system command (uses /usr/bin/which)" do
      proc = mock(Proc)
      path = "/usr/bin/wkhtmltopdf"
      PDFKit.stub(:configure).and_yield(proc)
      proc.should_receive(:wkhtmltopdf=).with(path)
      pipe = mock(IO, {:readlines => [path], :read_close => nil})
      IO.should_receive(:popen).and_return(pipe)
      PDFConverter.new
    end
  end
  describe "formatters" do
    it "includes a Basic formatter if no options[:formatter] is set" do
      PDFConverter.should_receive(:include).with(Basic)
      PDFConverter.new
    end
    it "includes any given formatter in options[:formatter] => string" do
      PDFConverter.should_receive(:include).with(Reports)
      PDFConverter.new(:formatter => 'Reports')
    end
  end
  describe "html to pdf conversion" do
    before(:each) do
      @html = "<html><head><title>Some Title</title></head><body><h1>Heading</h1><p>Paragraph</p></body></html>"
      @pdfkit = mock(PDFKit, {
        :stylesheets => [],
        :to_pdf => nil
      })
      PDFKit.stub(:new).and_return(@pdfkit)
    end
    it "converts html to pdf" do
      @pdfkit.should_receive(:to_pdf)
      PDFKit.should_receive(:new).with(@html, {
        :footer_center => "[page] / [topage]",
        :margin_top=>"8mm",
        :margin_right=>"9mm",
        :margin_bottom=>"8mm",
        :margin_left=>"9mm"
      }).and_return(@pdfkit)
      converter = PDFConverter.new
      converter.html_to_pdf(@html)
    end
    it "loads stylesheets provided by formatter modules" do
      converter = PDFConverter.new
      PDFConverter.stylesheets.size.should be(1)
      converter = PDFConverter.new(:formatter => 'Reports')
      PDFConverter.stylesheets.size.should be(3)
    end
  end
end
