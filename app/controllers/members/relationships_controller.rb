module Members
  class RelationshipsController < ApplicationController
    def new
      @member = Member.find(params[:member_id])
      @relationship = @member.relationships.build
      if params[:search].present?
        @members = Member.text_search(params[:search]).paginate(page: params[:page], per_page: 25)
      else
        @members = @member.recommended_relationships.paginate(page: params[:page], per_page: 25)
      end
    end
    def create
      @member = Member.find(params[:member_id])
      @relationship = @member.relationships.create(relationship_params)
      if @relationship.valid?
        @relationship.save
        redirect_to new_member_relationship_url(@member), notice: "Relationship saved successfully."
      else
        render :new
      end
    end

    private
    def relationship_params
      params.require(:relationship).
      permit(:relationship_type, :relationer_id, :relationer_type, :relationee_id)
    end
  end
end
