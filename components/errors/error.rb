class Errors::Error < StandardError

  def message
    { status: "error", distance: -1, error: "error description" }
  end
end
