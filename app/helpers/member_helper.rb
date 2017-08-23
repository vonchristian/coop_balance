module MemberHelper
  def member_avatar(member, options = {})
  	if member
	    if member.avatar.file?
	      image_tag member.avatar.url(:medium), options
	    else
	      image_tag member.avatar_url, options
	    end
	  end
  end
end
