class AdditionController < ActionController::Base
	def showinputfields
		render 'showinputfields'
	end

	def perform
		firstvalue = params[:firstvalue].to_i
    	secondvalue = params[:secondvalue].to_i
    	result = firstvalue + secondvalue

   
	    f = open('/tmp/result.txt', 'w')
	    f.puts result.to_s
	    f.close
	    redirect_to '/display'
	end

	def display
		f = open('/tmp/result.txt', 'r')
	    @result = f.read.strip
	    f.close
	    render 'display'
	end

end