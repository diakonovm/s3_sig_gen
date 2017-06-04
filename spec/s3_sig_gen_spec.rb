require "spec_helper"

RSpec.describe S3SigGen do

  it "has a version number" do
    expect(S3SigGen::VERSION).not_to be nil
  end

  it "accepts an aws access key id, aws secret access key, region, bucket, key and acl as options on initialization" do
    options = {
      aws_access_key_id: "123456789",
      aws_secret_access_key: "123456789",
      region: "us-east-1",
      bucket: "asdf",
      key: "key",
      acl: "public-read"
    }
    s3_sig_gen = S3SigGen::Generator.new(options)
    hash = Hash[ s3_sig_gen.instance_variables.map { |name| [name.to_s.gsub("@", "").to_sym, s3_sig_gen.instance_variable_get(name)] } ]
    expect(hash).to eq(options)
  end

  it "accepts an aws access key id, aws secret access key, region, bucket, key and acl on initialization block" do
    options = {
      aws_access_key_id: "123456789",
      aws_secret_access_key: "123456789",
      region: "us-east-1",
      bucket: "asdf",
      key: "key",
      acl: "public-read"
    }
    s3_sig_gen = S3SigGen::Generator.new do |g|
      g.aws_access_key_id = options[:aws_access_key_id]
      g.aws_secret_access_key = options[:aws_secret_access_key]
      g.region = options[:region]
      g.bucket = options[:bucket]
      g.key = options[:key]
      g.acl = options[:acl]
    end
    hash = Hash[ s3_sig_gen.instance_variables.map { |name| [name.to_s.gsub("@", "").to_sym, s3_sig_gen.instance_variable_get(name)] } ]
    expect(hash).to eq(options)
  end

  it "generates a signature with the required keys" do
    options = {
      aws_access_key_id: "123456789",
      aws_secret_access_key: "123456789",
      region: "us-east-1",
      bucket: "asdf",
      key: "key",
      acl: "public-read"
    }
    signature = S3SigGen::Generator.new(options).signature
    expect(signature.has_key?("acl")).to be true
    expect(signature.has_key?("key")).to be true
    expect(signature.has_key?("success_action_status")).to be true
    expect(signature.has_key?("policy")).to be true
    expect(signature.has_key?("x-amz-algorithm")).to be true
    expect(signature.has_key?("x-amz-credential")).to be true
    expect(signature.has_key?("x-amz-date")).to be true
    expect(signature.has_key?("x-amz-signature")).to be true
  end

  xit "generates a valid AWS Version 4 signature" do

  end

end
