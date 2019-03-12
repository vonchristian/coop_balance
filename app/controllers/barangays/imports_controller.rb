module Barangays
	class ImportsController < ApplicationController

		def create
			@barangays_import = Barangays::ImportsProcessing.new(import_params).parse_records!
			redirect_to barangays_url, notice: "Barangays are successfully uploaded."
		end

		private
		def import_params
			params.require(:barangays_imports_processing).permit(:file, :cooperative_id)		
		end
	end
end