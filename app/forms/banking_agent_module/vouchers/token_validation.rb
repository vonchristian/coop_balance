module BankingAgentModule 
  module Vouchers 
    class TokenValidation 
      include ActiveModel::Model
      attr_accessor :voucher_id, :token 

   
      def validate!
        if token == find_voucher.token 
          return true 
        end 
      end 

      def find_voucher 
        Voucher.find(voucher_id)
      end 
      
    end 
  end 
end 