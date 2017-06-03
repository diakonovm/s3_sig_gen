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

<form action="https://asdf.s3.amazonaws.com/" method="post" enctype="multipart/form-data">
  <input type="hidden" name="key" value="<%= @signature["key"] %>" />
  <input type="hidden" name="acl" value="<%= @signature["acl"] %>" />
  <!-- <input type="hidden" name="x-amz-server-side-encryption" value="AES256" />  -->
  <input type="hidden" name="success_action_status" value="<%= @signature["success_action_status"] %>" />
  <input type="hidden" name="X-Amz-Credential" value="<%= @signature["x-amz-credential"] %>" />
  <input type="hidden" name="X-Amz-Algorithm" value="<%= @signature["x-amz-algorithm"] %>" />
  <input type="hidden" name="X-Amz-Date" value="<%= @signature["x-amz-date"] %>" />
  <input type="hidden" name="Policy" value="<%= @signature["policy"] %>" />
  <input type="hidden" name="X-Amz-Signature" value="<%= @signature["x-amz-signature"] %>" />
  File:
  <input type="file" name="file" /> <br />
  <!-- The elements after this will be ignored -->

  <input type="submit" name="submit" value="upload"/>
</form>
