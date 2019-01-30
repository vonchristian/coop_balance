class MemberSerializer
  include FastJsonapi::ObjectSerializer
  attributes :first_name, :middle_name, :last_name
end
