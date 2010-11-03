require File.expand_path(File.join(File.dirname(__FILE__),
                                   %w[.. example_helper]))



p = Prawn::Document.new
p_break = " \n\n"
lorem = "Lorem ipsum dolor sit amet, <i>consectetur adipisicing elit</i>, <b>sed do</b> eiusmod tempor incididunt ut labore et dolore magna aliqua.#{p_break}Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.#{p_break}Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."    

#calculate column parameters
options = {:columns=>3, :top_margin=>40, :bottom_margin=>150, :size=>8, :align=>:justify, :inline_format => true}
p.formatted_columns(lorem*20, options)
p.start_new_page
p.formatted_columns(lorem*15, :columns=>2, :size=>11, :align=>:left, :inline_format=> true)
p.start_new_page
lorem =  [{:text=>"This is some ", :styles=>[], :color=>nil, :link=>nil, :anchor=>nil, :font=>nil, :size=>nil, :character_spacing=>nil}, 
{:text=>"italic", :styles=>[:italic], :color=>nil, :link=>nil, :anchor=>nil, :font=>nil, :size=>nil, :character_spacing=>nil}, 
{:text=>" and ", :styles=>[], :color=>nil, :link=>nil, :anchor=>nil, :font=>nil, :size=>nil, :character_spacing=>nil}, 
{:text=>"bold", :styles=>[:bold], :color=>nil, :link=>nil, :anchor=>nil, :font=>nil, :size=>nil, :character_spacing=>nil}, 
{:text=>" text. eiusmod tempor incididunt ut labore et dolore magna aliqua.#{p_break}Ut enim ad minim veniam.", :styles=>[], :color=>nil, :link=>nil, :anchor=>nil, :font=>nil, :size=>nil, :character_spacing=>nil}]

p.bounding_box([50,p.bounds.top-50], :width=>400, :height=>400) do
	p.formatted_columns(lorem*24, :columns=>5, :size=>8, :gutter => 10, :align=>:left, :top_margin=>0, :bottom_margin=>0)
end
p.render_file("columns_test.pdf")

