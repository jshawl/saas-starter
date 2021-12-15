module ApplicationHelper
  def as_currency int
    "$%.2f" % (int.to_f / 100)
  end
end
