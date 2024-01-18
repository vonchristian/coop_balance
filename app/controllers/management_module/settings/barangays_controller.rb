module ManagementModule
  module Settings
    class BarangaysController < ApplicationController
      def index
        @barangays_import = Barangays::ImportsProcessing.new
      end
    end
  end
end