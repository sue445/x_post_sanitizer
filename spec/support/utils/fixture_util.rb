module FixtureUtil
  # @param fixture_name [String]
  # @return [Hash]
  def read_status_fixture(fixture_name)
    json = spec_dir.join("support", "fixtures", fixture_name).read
    JSON.parse(json)
  end
end
