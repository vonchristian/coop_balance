UserPolicy = Struct.new(:user, :record) do
  def new?
    create?
  end

  def create?
    user.system_administrator?
  end

  def show?
    user == record || user.system_administrator?
  end

  def edit?
    user == record || user.system_administrator?
  end

  def update?
    edit?
  end
end
