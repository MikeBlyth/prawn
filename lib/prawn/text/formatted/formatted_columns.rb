# encoding: utf-8

# text/formatted/formatted_columns.rb : Implements text flowing in evenly 
#  spaced columns
#
# This modification to Prawn was begun by Mike Blyth
# Prawn itself is copyright February 2010, Daniel Nelson. All Rights Reserved.
#
# This is free software. Please see the LICENSE and COPYING files for details.
#
class Array
	def remove_leading_blank_lines
		shadow = self.dup
		substr = ''
		self.each do |a|
			if (a.is_a? Hash) && (a[:text].is_a? String)
				substr = a[:text].remove_leading_blank_lines 
			end	
			substr = a.lstrip if a.is_a? String
			shadow.shift if substr == ''
			break if substr != ''
		end 
		if (shadow[0].is_a? Hash) && shadow[0][:text]
			shadow[0][:text] = substr
		end
		shadow
	end
end

class String
	def remove_leading_blank_lines
		paragraphs = self.split "\n"
		paragraphs.shift while paragraphs[0] && paragraphs[0].lstrip == ''
		return paragraphs.join "\n"
	end
end

module Prawn
  module Text
    module Formatted

    # 
    # Flow text in any number of columns with automatic continuing to following pages until
	# all text is set.
    # * uses entire bounds height and width unless margins are included in options
    # * always starts in first column regardless of current state of page
    # * uses formatted_text_box method but outputs raw text unless :inline_format is specified
	# * will accept either a single string (like other text methods) or a formatted-text array
	#	(like formatted_ methods). 
	#
    # == Options (default values marked in [])
    #
    # <tt>:columns</tt>:: <tt>number</tt>. Number of columns across layout [2]
    # <tt>:top_margin</tt>:: <tt>number</tt>. Top margin from enclosing bounds to top of columns [0]
    # <tt>:bottom_margin</tt>:: <tt>number</tt>. Margin from enclosing bounds to bottom of columns [0]
	# <tt>:gutter</tt>:: <tt>number</tt>. Space between columns in points [18]
	# <tt>:inline_format</tt>:: <tt>boolean</tt>. Allows inline formatting as in other text methods.
	# 											  Not required if a formatted array is used for input.
    # Any other options are also passed to formatted_text_box so you can use :size, :style, or whatever.

	def formatted_columns(text, options)
      # Handle options
      gutter = options[:gutter] || 18
      columns = options[:columns] || 2
      top_margin = options[:top_margin] || 0
      bottom_margin = options[:bottom_margin] || 0
      # calculate column left edges and widths (all are same width)
      col_width = (bounds.width-(columns-1)*gutter)/columns
      col_left_edge = []
      0.upto(columns-1) do |x|
        col_left_edge << x*(col_width+gutter)
      end  

      # Initialize excess_text for setting text    
 	  # excess_text keeps what's left over after filling a given column
	  if text.class != Array			# already in formatted_text array?
        # convert to formatted_text array
		if options[:inline_format]
			text = Text::Formatted::Parser.to_array(text) 
		else
			text = [{:text=>"#{text}"}]  # just use the raw text if not :inline_format
		end
	  end
	  column_number = 0
	  [:gutter, :columns, :top_margin, :bottom_margin, :inline_format].each {|key| options.delete(key)}
      # now repeat cycle of fill a column, fill next column with leftover text, etc., 
      # ... going to next page after filling all the columns on current page
      until text.empty?
        text = formatted_text_box(text, {
          :width => col_width,
          :height => bounds.height-top_margin-bottom_margin,
          :overflow => :truncate,
          :at => [col_left_edge[column_number], bounds.top-top_margin],
        }.merge(options)) # merge any options sent as parameters, which could include :align, :style etc.
        column_number = (column_number+1) % columns
		text = text.remove_leading_blank_lines  # remove whitespace at top of columns. Should we do this on first column, too, 
					   #   or assume that it must be intentional if it's at the beginning?
#puts "Top column, text=#{text.to_s}" if
        start_new_page if column_number == 0 && !text.empty?
      end
  end #method

    end
  end
end
