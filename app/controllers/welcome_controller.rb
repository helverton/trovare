class WelcomeController < ApplicationController
	def index
	  render :file => 'public/site/index.html'
	end
end