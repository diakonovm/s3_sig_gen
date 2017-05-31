require "spec_helper"

RSpec.describe S3SigGen do
  it "has a version number" do
    expect(S3SigGen::VERSION).not_to be nil
  end

  it "does something useful" do
    expect(false).to eq(true)
  end
end
